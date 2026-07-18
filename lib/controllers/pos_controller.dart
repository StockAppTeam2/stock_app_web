import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';
import 'package:stock_app_web/core/services/firestore_service.dart';
import 'package:stock_app_web/models/pos_model.dart';

class PosController {
  final firestoreService = getIt<FirestoreService>();
  final _cache = getIt<CacheRepository>();

  Future<List<int>> getPosDataUsingDateInFirebase(
    String todayDate,
    String shopId,
  ) async {
    int posValPerDay = 0;
    int posCumulative = 0;

    // getting one day pos value based on date selection
    DocumentSnapshot posInfo = await FirebaseFirestore.instance
        .collection('pos')
        .doc(shopId.toString())
        .collection('date')
        .doc(todayDate)
        .get();

    if (posInfo.exists) {
      Map<String, dynamic> data = posInfo.data() as Map<String, dynamic>;
      if (data.isNotEmpty) {
        posValPerDay = data['posValue'];
        posCumulative = data['posCumulative'];
      }
    }

    return [posValPerDay, posCumulative];
  }

  Future<List<NewPosModel>> readAllItemsFirestoreUsingDate(String date) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('pos')
        .where('posDate', isGreaterThanOrEqualTo: date)
        .where('posDate', isLessThan: '$date\uf8ff')
        .get();

    return snapshot.docs.map((doc) => NewPosModel.fromMap(doc.data())).toList();
  }

  Future<List<String>> getPosMonths(String docId) async {
    List<String> posMonths = [];
    final doc = await firestoreService.getDocument(
      collection: 'web_cache',
      docId: docId,
    );

    if (doc.exists) {
      print('getPosMonths1');
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data.isNotEmpty && data.containsKey('posMonths')) {
        print('posMonths ${data['posMonths']}');
        List<String> posMonths = List<String>.from(data['posMonths'] ?? []);

        final currentMonth =
            '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}';

        if (posMonths.contains(currentMonth)) {
          print('pos Current month exists');
          return posMonths;
        } else {
          print('pos Current month does not exist');
          posMonths.add(currentMonth);
          await FirebaseFirestore.instance
              .collection('web_cache')
              .doc(docId)
              .update({'posMonths': FieldValue.arrayUnion(posMonths)});
          return posMonths;
        }
      }
    }

    if (posMonths.isEmpty) {
      print('getPosMonths2');
      List<String> months = await getAvailableMonths(docId);
      print('months $months');
      await firestoreService.add(
        collection: 'web_cache',
        docId: docId,
        data: {'posMonths': months},
      );

      return months;
    }
    return [];
  }

  Future<List<String>> getAvailableMonths(String shopId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('pos')
        .doc(shopId)
        .collection('date')
        .get();

    final months = <String>{}; // Set removes duplicates

    for (final doc in snapshot.docs) {
      // Document ID format: yyyy-MM-dd
      final month = doc.id.substring(0, 7); // yyyy-MM
      months.add(month);
    }

    final result = months.toList()..sort();
    return result;
  }

  Map<String, String> getMonthRange(String yearMonth) {
    final parts = yearMonth.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);

    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);

    String format(DateTime date) {
      return '${date.year}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';
    }

    print('pos: start :${format(start)} , end: ${format(end)}');

    return {'start': format(start), 'end': format(end)};
  }

  Future<List<NewPosModel>> getPosData(String monthAndYear) async {
    print('called ffffffffffff');
    print('monthAndYear $monthAndYear');
    final range = getMonthRange(monthAndYear);
    String shopId = await getIt<ShopIdController>().getShopId();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('pos')
        .doc(shopId)
        .collection('date')
        .where('posDate', isGreaterThanOrEqualTo: range['start'])
        .where('posDate', isLessThan: range['end'])
        .get();

    for (final doc in snapshot.docs) {
      print(doc.id);
    }

    print('completed ffffffffffff');
    return snapshot.docs
        .map((doc) => NewPosModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addNewPosData(NewPosModel newData) async {
    String shopId = await getIt<ShopIdController>().getShopId();

    final now = DateTime.now();

    final start = '${now.year}-${now.month.toString().padLeft(2, '0')}-01';
    final end = '${now.year}-${(now.month + 1).toString().padLeft(2, '0')}-01';

    final snapshot = await FirebaseFirestore.instance
        .collection('pos')
        .doc(shopId)
        .collection('date')
        .where('posDate', isGreaterThanOrEqualTo: start)
        .where('posDate', isLessThan: end)
        .orderBy('posDate', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final latestDoc = snapshot.docs.first;
      print(latestDoc.id);
      newData.posCumulative =
          newData.posValue + latestDoc.get('posCumulative') as int;
    } else {
      newData.posCumulative = newData.posValue;
    }

    // items id
    int lastPosId = await _cache.getIntCacheFirebase(key: 'lastPosId');
    await _cache.addIntCacheFirebase('lastPosId', lastPosId + 1);

    newData.id = lastPosId + 1;

    DocumentReference posInfoRef = FirebaseFirestore.instance
        .collection('pos')
        .doc(shopId)
        .collection('date')
        .doc(newData.posDate);

    await posInfoRef.set(newData.toMap(), SetOptions(merge: true));
  }

  Future<void> deletePos(NewPosModel product) async {
    String shopId = await getIt<ShopIdController>().getShopId();
    DocumentReference posInfoRef = FirebaseFirestore.instance
        .collection('pos')
        .doc(shopId)
        .collection('date')
        .doc(product.posDate);
    await posInfoRef.delete();
  }
}

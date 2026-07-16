import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/services/firestore_service.dart';
import 'package:stock_app_web/models/pos_model.dart';

class PosController {
  final firestoreService = getIt<FirestoreService>();

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
    final List<String> months = [];

    DateTime current = DateTime(2024, 10, 1);
    DateTime today = DateTime.now();

    while (!current.isAfter(today)) {
      String date =
          '${current.year.toString().padLeft(4, '0')}-'
          '${current.month.toString().padLeft(2, '0')}-'
          '${current.day.toString().padLeft(2, '0')}';

      print('date $date');

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('pos')
          .doc(shopId)
          .collection('date')
          .doc(date)
          .get();

      if (doc.exists) {
        print('doc exist $doc');
        months.add(
          '${current.year}-${current.month.toString().padLeft(2, '0')}',
        );

        // Jump to the first day of the next month
        print('Jump to the first day of the next month');
        current = DateTime(current.year, current.month + 1, 1);
      } else {
        // Check the next day
        print('Check the next day');
        current = current.add(const Duration(days: 1));
      }
    }

    return months;
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
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';
import 'package:stock_app_web/core/services/firestore_cache_service.dart';
import 'package:stock_app_web/models/previous_year_sales_cumulative.dart';

class LastYearSalesCumulativeRepo {
  final _firestoreCacheService = getIt<FirestoreCacheService>();
  final _cache = getIt<CacheRepository>();

  static const String previousYearSalesCumulative =
      'PreviousYearSalesCumulative';
  static const String salesCollection = 'sales';

  Future<List<String>> getLastYearCumulativeMonths() async {
    List<String> lastYearCumulativeMonths = [];
    String shopId = await getIt<ShopIdController>().getShopId();

    final doc = await _firestoreCacheService.getCache(docId: shopId);

    if (doc.exists) {
      print('lastYearCumulativeMonths1');
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data.isNotEmpty) {
        if (data.containsKey('lastYearCumulativeMonths')) {
          print('lastYearCumulativeMonths ${data['lastYearCumulativeMonths']}');

          List<String> lastYearCumulativeMonths = List<String>.from(
            data['lastYearCumulativeMonths'] ?? [],
          );

          final currentMonth =
              '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}';

          if (lastYearCumulativeMonths.contains(currentMonth)) {
            print('lastYearCumulativeMonths Current month exists');
            return lastYearCumulativeMonths;
          } else {
            print('lastYearCumulativeMonths Current month does not exist');
            lastYearCumulativeMonths.add(currentMonth);
            await FirebaseFirestore.instance
                .collection('web_cache')
                .doc(shopId)
                .update({
                  'lastYearCumulativeMonths': FieldValue.arrayUnion(
                    lastYearCumulativeMonths,
                  ),
                });
            return lastYearCumulativeMonths;
          }
        }
      }
    }

    if (lastYearCumulativeMonths.isEmpty) {
      print('lastYearCumulativeMonths2');
      List<String> months = await getAvailableMonths(shopId);
      print('months $months');
      await _firestoreCacheService.addCache(
        docId: shopId,
        data: {'lastYearCumulativeMonths': months},
      );

      return months;
    }
    return [];
  }

  Future<List<String>> getAvailableMonths(String shopId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(salesCollection)
        .doc(shopId)
        .collection(previousYearSalesCumulative)
        .get();

    final Set<String> uniqueMonths = {};

    for (final doc in snapshot.docs) {
      // Document ID format: yyyy-MM-dd
      uniqueMonths.add(doc.id.substring(0, 7));
    }

    final months = uniqueMonths.toList()
      ..sort((a, b) => b.compareTo(a)); // Newest first

    return months;
  }

  Future<void> addLastYearSalesCumulative(
    PreviousYearSalesCumulativeModel model,
  ) async {
    String shopId = await getIt<ShopIdController>().getShopId();

    // cumu id
    int lastItemsId = await _cache.getIntCacheFirebase(
      key: 'lastSalesCumulativeId',
    );
    await _cache.addIntCacheFirebase('lastSalesCumulativeId', lastItemsId + 1);

    model.id = lastItemsId + 1;

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(salesCollection)
        .doc(shopId)
        .collection(previousYearSalesCumulative)
        .doc(model.date);
    await documentReference.set(model.toMap(), SetOptions(merge: true));
  }

  Future<List<PreviousYearSalesCumulativeModel>> getPreviousYearSalesCumulative(
    String monthAndYear,
  ) async {
    final range = getMonthRange(monthAndYear);
    String shopId = await getIt<ShopIdController>().getShopId();
    //
    QuerySnapshot snapshot1 = await FirebaseFirestore.instance
        .collection(salesCollection)
        .doc(shopId)
        .collection(previousYearSalesCumulative)
        .get();

    print(
      'snapshot1.docs.length: ${snapshot1.docs.map((e) {
        print(e.data());
        return e;
      })}',
    );
    //

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(salesCollection)
        .doc(shopId)
        .collection(previousYearSalesCumulative)
        .where('date', isGreaterThanOrEqualTo: range['start'])
        .where('date', isLessThan: range['end'])
        .get();

    for (final doc in snapshot.docs) {
      print(doc.id);
    }

    print('completed ffffffffffff');
    return snapshot.docs
        .map(
          (doc) => PreviousYearSalesCumulativeModel.fromMap(
            doc.data() as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Map<String, String> getMonthRange(String yearMonth) {
    final parts = yearMonth.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);

    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);

    String format(DateTime date) {
      return '${date.year - 1}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';
    }

    print('getMonthRange: start :${format(start)} , end: ${format(end)}');

    return {'start': format(start), 'end': format(end)};
  }

  Future<void> deletePreviousYearSalesCumulative(String date) async {
    String shopId = await getIt<ShopIdController>().getShopId();

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(salesCollection)
        .doc(shopId)
        .collection(previousYearSalesCumulative)
        .doc(date);
    await documentReference.delete();
  }
}

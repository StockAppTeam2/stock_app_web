import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/Internet_connection_repo.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';
import 'package:stock_app_web/core/repositories/firestore_repo.dart';
import 'package:stock_app_web/core/repositories/opening_firestore_repo.dart';
import 'package:stock_app_web/core/repositories/purchase_firestore_repo.dart';
import 'package:stock_app_web/core/services/firestore_cache_service.dart';
import 'package:stock_app_web/models/brand_model.dart';
import 'package:stock_app_web/models/inward_table_model.dart';
import 'package:stock_app_web/models/items_table_model.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class ReceiptController {
  final _cache = getIt<CacheRepository>();
  final _internetConnectionRepo = getIt<InternetConnectionRepo>();
  final _firestoreCacheService = getIt<FirestoreCacheService>();
  final _openingFireRepo = getIt<OpeningFirestoreRepo>();
  final _purchaseFirestoreRepo = getIt<PurchaseFirestoreRepo>();

  Future<void> addViewDate(String key, String value) async {
    await _cache.addStringCacheLocalAndFirebase(key, value);
  }

  Future<String> getViewDate(String key) async {
    return await _cache.getStringCacheLocalAndFirebase(key: key);
  }

  Future<List<InwardViewModel>> getInwardData(
    String date,
    String shopId,
  ) async {
    List<InwardViewModel> data = await _purchaseFirestoreRepo.getInwardDoc(
      date,
      shopId,
    );
    return data;
  }

  Future<List<String>> getReceiptMonths() async {
    List<String> receiptMonths = [];
    String shopId = await getIt<ShopIdController>().getShopId();

    final doc = await _firestoreCacheService.getCache(docId: shopId);

    if (doc.exists) {
      print('getReceiptMonths1');
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data.isNotEmpty) {
        if (data.containsKey('receiptMonths')) {
          print('receiptMonths ${data['receiptMonths']}');

          List<String> receiptMonths = List<String>.from(
            data['receiptMonths'] ?? [],
          );

          final currentMonth =
              '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}';

          if (receiptMonths.contains(currentMonth)) {
            print('receiptMonths Current month exists');
            return receiptMonths;
          } else {
            print('receiptMonths Current month does not exist');
            receiptMonths.add(currentMonth);
            await FirebaseFirestore.instance
                .collection('web_cache')
                .doc(shopId)
                .update({
                  'receiptMonths': FieldValue.arrayUnion(receiptMonths),
                });
            return receiptMonths;
          }
        }
      }
    }

    if (receiptMonths.isEmpty) {
      print('getReceiptMonths1');
      List<String> months = await getAvailableMonths(shopId);
      print('months $months');
      await _firestoreCacheService.addCache(
        docId: shopId,
        data: {'receiptMonths': months},
      );

      return months;
    }
    return [];
  }

  Future<List<String>> getAvailableMonths(String shopId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('inward')
        .doc(shopId)
        .collection('date')
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
  // Future<List<String>> getAvailableMonths(String shopId) async {
  //   final List<String> months = [];
  //
  //   DateTime current = DateTime(2024, 10, 1);
  //   DateTime today = DateTime.now();
  //
  //   while (!current.isAfter(today)) {
  //     String date =
  //         '${current.year.toString().padLeft(4, '0')}-'
  //         '${current.month.toString().padLeft(2, '0')}-'
  //         '${current.day.toString().padLeft(2, '0')}';
  //
  //     print('date $date');
  //
  //     DocumentSnapshot doc = await FirebaseFirestore.instance
  //         .collection('inward')
  //         .doc(shopId)
  //         .collection('date')
  //         .doc(date)
  //         .get();
  //
  //     if (doc.exists) {
  //       print('doc exist $doc');
  //       months.add(
  //         '${current.year}-${current.month.toString().padLeft(2, '0')}',
  //       );
  //
  //       // Jump to the first day of the next month
  //       print('Jump to the first day of the next month');
  //       current = DateTime(current.year, current.month + 1, 1);
  //     } else {
  //       // Check the next day
  //       print('Check the next day');
  //       current = current.add(const Duration(days: 1));
  //     }
  //   }
  //
  //   return months;
  // }

  Future<List<BrandModel>> getActiveBrands() async {
    List<BrandModel> data = await _openingFireRepo.getActiveBrands();
    return data;
  }

  Future<void> addNewReceipt({
    required int inputCase,
    required int inputBottle,
    required String invoiceNo,
    required int bottlePerBundle,
    required int price,
    required int productId,
    required int mobileNumber,
    required String currentDate,
  }) async {
    bool isConnected = await _internetConnectionRepo.checkInternetConnection();
    if (isConnected) {
      String shopId = await _cache.getStringCacheLocal(key: 'shopId');

      int totalInwardRetailUnits = (inputCase * bottlePerBundle) + inputBottle;
      int totalPriceInward = totalInwardRetailUnits * price;

      String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());

      // inward id
      int lastInwardId = await _cache.getIntCacheFirebase(key: 'lastInwardId');
      await _cache.addIntCacheFirebase('lastInwardId', lastInwardId + 1);

      InwardTableModel inward = InwardTableModel(
        id: lastInwardId + 1,
        phoneNumber: mobileNumber,
        date: currentDate,
        time: currentTime,
        inwardBundle: inputCase,
        inwardRetail: inputBottle,
        isSynced: 1,
        invoiceNo: invoiceNo,
        invoiceDate: currentDate,
        productId: productId,
        totalInwardRetailUnits: totalInwardRetailUnits,
        totalPriceInward: totalPriceInward,
      );

      ItemsTableModel? itemsData;

      List<ItemsViewModel> itemsModelData = await _openingFireRepo
          .getOpeningDoc(currentDate, shopId);

      if (itemsModelData.isEmpty) return;
      final item = itemsModelData
          .where((e) => e.productId == inward.productId)
          .firstOrNull;

      if (item != null) {
        print('item.id: ${item.id}, shopId: $shopId');
        print(item.productId);
        int totalActualRetailUnits =
            inward.totalInwardRetailUnits + item.totalActualRetailUnits;
        int actualBundle = totalActualRetailUnits ~/ item.bottlePerBundle;
        int actualRetail = totalActualRetailUnits % item.bottlePerBundle;
        int totalActualPrice = totalActualRetailUnits * item.price;
        print(
          '$totalActualRetailUnits $actualBundle $actualRetail $totalActualPrice',
        );
        item.phoneNumber = inward.phoneNumber;
        item.actualBundle = actualBundle;
        item.actualRetail = actualRetail;
        item.totalActualRetailUnits = totalActualRetailUnits;
        item.totalPriceActual = totalActualPrice;
        item.isSynced = 1;
        item.id = int.parse(item.id.toString());
        print('item.toMap(): ${item.toMap()}');
        ItemsTableModel itemsTableModel = ItemsTableModel.fromMap(item.toMap());

        itemsData = itemsTableModel;
      } else {
        // items id
        int lastItemsId = await _cache.getIntCacheFirebase(key: 'lastItemsId');
        await _cache.addIntCacheFirebase('lastItemsId', lastItemsId + 1);

        ItemsTableModel itemsTableModel = ItemsTableModel(
          id: lastItemsId + 1,
          productId: productId,
          phoneNumber: mobileNumber,
          date: currentDate,
          time: currentTime,
          openingBundle: inputCase,
          openingRetail: inputBottle,
          actualBundle: inputCase,
          actualRetail: inputBottle,
          closingBundle: -1,
          closingRetail: -1,
          totalOpenRetailUnits: totalInwardRetailUnits,
          totalCloseRetailUnits: -1,
          totalActualRetailUnits: totalInwardRetailUnits,
          totalPriceOpening: totalPriceInward,
          totalPriceClosing: -1,
          totalPriceActual: totalPriceInward,
          isSynced: 1,
          unscannedEntry: 0,
          checkOpeningCase: 0,
          checkOpeningBottle: 0,
          checkOpeningCaseBottle: 0,
          checkClosingCase: 0,
          checkClosingBottle: 0,
          checkClosingCaseBottle: 0,
          checkCurrentCase: 0,
          checkCurrentBottle: 0,
          checkCurrentCaseBottle: 0,
        );
        itemsData = itemsTableModel;
      }

      await _purchaseFirestoreRepo.addNewReceipt(
        inward: inward,
        docId: currentDate,
        item: itemsData,
        shopId: shopId,
      );
    } else {
      showErrorToast('No Internet Connection');
    }
  }

  Future<bool> checkProductExist(String productId, String date) async {
    String shopId = await _cache.getStringCacheLocal(key: 'shopId');
    bool isProduceExist = await _purchaseFirestoreRepo.checkProductExist(
      docId: date,
      shopId: shopId,
      productId: productId,
    );
    return isProduceExist;
  }

  Future<String> checkTodayExistingInvoiceNumber(String date) async {
    String shopId = await _cache.getStringCacheLocal(key: 'shopId');
    String isProduceExist = await _purchaseFirestoreRepo
        .checkTodayExistingInvoiceNumber(docId: date, shopId: shopId);
    return isProduceExist;
  }

  // Future<List<InwardDailyFolderModel>> getInwardDailyDetails({
  //   required String month,
  // }) async {
  //   String shopId = await _cache.getStringCacheLocal(key: 'shopId');
  //   List<InwardDailyFolderModel> invoiceTotals = await _purchaseFirestoreRepo
  //       .getInwardDailyDetails(month: month, shopId: shopId);
  //
  //   return invoiceTotals;
  // }

  Future<List<InwardDailyFolderModel>> getInwardDailyDetails({
    required int pageSize,
    required String month,
    String? lastDate,
  }) async {
    String shopId = await _cache.getStringCacheLocal(key: 'shopId');

    List<InwardDailyFolderModel> invoiceTotals = await _purchaseFirestoreRepo
        .loadFirstPageViewDate(
          lastDate: lastDate,
          limit: pageSize,
          shopId: shopId,
        );
    return invoiceTotals;
  }

  Future<bool> enableEdit({required String date}) async {
    String shopId = await _cache.getStringCacheLocal(key: 'shopId');
    bool allowEdit = await _purchaseFirestoreRepo.enableEdit(
      shopId: shopId,
      date: date,
    );
    return allowEdit;
  }

  Future<void> editReceipt({
    required int inputCase,
    required int inputBottle,
    required InwardViewModel model,
  }) async {
    bool isConnected = await _internetConnectionRepo.checkInternetConnection();
    if (isConnected) {
      String shopId = await _cache.getStringCacheLocal(key: 'shopId');

      int totalOldInwardRetailUnits =
          (model.inwardBundle * model.bottlePerBundle) + model.inwardRetail;
      int totalInwardRetailUnits =
          (inputCase * model.bottlePerBundle) + inputBottle;
      int totalPriceInward = totalInwardRetailUnits * model.price;

      String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());

      InwardTableModel inward = InwardTableModel(
        id: model.id,
        phoneNumber: model.phoneNumber,
        date: model.date,
        time: currentTime,
        inwardBundle: inputCase,
        inwardRetail: inputBottle,
        isSynced: 1,
        invoiceNo: model.invoiceNo,
        invoiceDate: model.date,
        productId: model.productId,
        totalInwardRetailUnits: totalInwardRetailUnits,
        totalPriceInward: totalPriceInward,
      );

      ItemsTableModel? itemsData;

      List<ItemsViewModel> itemsModelData = await _openingFireRepo
          .getOpeningDoc(model.date, shopId);

      if (itemsModelData.isEmpty) return;
      final item = itemsModelData
          .where((e) => e.productId == inward.productId)
          .firstOrNull;

      if (item != null) {
        print(item.productId);
        int totalOldActualRetailUnits =
            item.totalActualRetailUnits - totalOldInwardRetailUnits;
        int totalActualRetailUnits =
            totalOldActualRetailUnits + inward.totalInwardRetailUnits;
        int actualBundle = totalActualRetailUnits ~/ item.bottlePerBundle;
        int actualRetail = totalActualRetailUnits % item.bottlePerBundle;
        int totalActualPrice = totalActualRetailUnits * item.price;

        item.id = item.id;
        item.phoneNumber = inward.phoneNumber;
        item.actualBundle = actualBundle;
        item.actualRetail = actualRetail;
        item.totalActualRetailUnits = totalActualRetailUnits;
        item.totalPriceActual = totalActualPrice;
        item.isSynced = 1;
        ItemsTableModel itemsTableModel = ItemsTableModel.fromMap(item.toMap());

        itemsData = itemsTableModel;
      }

      await _purchaseFirestoreRepo.addNewReceipt(
        inward: inward,
        docId: model.date,
        item: itemsData!,
        shopId: shopId,
      );
    } else {
      showErrorToast('No Internet Connection');
    }
  }

  Future<void> deleteReceipt(InwardViewModel model) async {
    bool isConnected = await _internetConnectionRepo.checkInternetConnection();
    if (isConnected) {
      String shopId = await _cache.getStringCacheLocal(key: 'shopId');

      List<ItemsViewModel> itemsModelData = await _openingFireRepo
          .getOpeningDoc(model.date, shopId);

      if (itemsModelData.isEmpty) return;
      final item = itemsModelData
          .where((e) => e.productId == model.productId)
          .firstOrNull;

      ItemsTableModel? itemsData;

      if (item != null) {
        print(item.productId);
        int totalOldActualRetailUnits =
            item.totalActualRetailUnits - model.totalInwardRetailUnits;
        int actualBundle = totalOldActualRetailUnits ~/ item.bottlePerBundle;
        int actualRetail = totalOldActualRetailUnits % item.bottlePerBundle;
        int totalActualPrice = totalOldActualRetailUnits * item.price;

        item.id = item.id;
        item.phoneNumber = model.phoneNumber;
        item.actualBundle = actualBundle;
        item.actualRetail = actualRetail;
        item.totalActualRetailUnits = totalOldActualRetailUnits;
        item.totalPriceActual = totalActualPrice;
        item.isSynced = 1;
        ItemsTableModel itemsTableModel = ItemsTableModel.fromMap(item.toMap());

        itemsData = itemsTableModel;
      }

      await _purchaseFirestoreRepo.deleteReceipt(
        inward: model,
        docId: model.date,
        item: itemsData!,
        shopId: shopId,
      );
    } else {
      showErrorToast('No Internet Connection');
    }
  }

  Future<bool> checkClosingNotExist(String viewDate) async {
    bool isExist = await _openingFireRepo.checkClosingNotExist(viewDate);
    return isExist;
  }
}

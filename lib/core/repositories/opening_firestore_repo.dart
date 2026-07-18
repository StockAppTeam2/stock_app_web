import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/brand_firestore_repo.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';
import 'package:stock_app_web/core/repositories/sales_firestore_repo.dart';
import 'package:stock_app_web/core/services/firestore_service.dart';
import 'package:stock_app_web/models/brand_model.dart';
import 'package:stock_app_web/models/items_table_model.dart';
import 'package:stock_app_web/models/sales_cumulative_model.dart';
import 'package:stock_app_web/models/sales_table_model.dart';

class OpeningFirestoreRepo {
  final firestoreService = getIt<FirestoreService>();
  final cacheRepository = getIt<CacheRepository>();
  final brandFirestoreRepo = getIt<BrandFirestoreRepo>();
  final _viewDateController = getIt<ViewDateController>();
  final _salesFirestoreRepo = getIt<SalesFirestoreRepo>();

  static const itemsCollection = "items";
  static const salesCollection = "sales";
  static const dateSubCollection = "date";
  static const salesCumulativeSubCollection = "salesCumulative";

  Future<bool> checkFirstOpening() async {
    String shopId = await cacheRepository.getStringCacheLocal(key: 'shopId');

    List<bool> isExist = await firestoreService.collectionExists(
      collection: itemsCollection,
      shopId: shopId,
      subCollection: dateSubCollection,
    );
    return isExist[0];
  }

  Future<bool> checkFirstDay() async {
    String shopId = await cacheRepository.getStringCacheLocal(key: 'shopId');

    List<bool> isExist = await firestoreService.collectionExists(
      collection: itemsCollection,
      shopId: shopId,
      subCollection: dateSubCollection,
    );
    return isExist[1];
  }

  Future<List<BrandModel>> getActiveBrands() async {
    String shopId = await cacheRepository.getStringCacheLocal(key: 'shopId');

    List<BrandModel> data = await brandFirestoreRepo.getBrandCollection(shopId);
    print('List<BrandModel>: $data');

    List<BrandModel> brandData = data
        .where((brand) => brand.isActive == 0)
        .toList();

    return brandData;
  }

  Future<List<ItemsViewModel>> getOpeningDoc(String date, String shopId) async {
    List<ItemsViewModel> valuesList = [];

    DocumentSnapshot documentSnapshot = await firestoreService
        .getSubCollectionDocument(
          collection: itemsCollection,
          shopId: shopId,
          subCollection: dateSubCollection,
          docId: date,
        );

    if (!documentSnapshot.exists) return [];
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    if (data.isEmpty) return [];

    List<BrandModel> brandData = await brandFirestoreRepo.getBrandCollection(
      shopId,
    );
    try {
      data.forEach((key, value) {
        Map<String, dynamic> itemMap = Map<String, dynamic>.from(value);
        print('dd: ${value['date']}');
        // print('abcd ${itemMap['actualBundle']}');
        if (itemMap['actualBundle'] != 0 || itemMap['actualRetail'] != 0) {
          // Find matching brand
          BrandModel? brand;
          try {
            brand = brandData.firstWhere(
              (e) => e.productId == itemMap['productId'],
            );
          } catch (_) {
            brand = null;
          }

          // Merge Brand + Item
          if (brand != null) {
            itemMap.addAll(brand.toMap());
          }

          // print('itemMap: $itemMap');
          itemMap['date'] = value['date'];
          itemMap['id'] = value['id'];
          valuesList.add(ItemsViewModel.fromMap(itemMap));
        }
      });
    } catch (e) {
      print('e $e');
    }

    return valuesList;
  }

  Future<void> addOpeningData(
    String date,
    Map<String, dynamic> data,
    SalesTableModel salesData,
  ) async {
    String shopId = await cacheRepository.getStringCacheLocal(key: 'shopId');
    await cacheRepository.addStringCacheLocalAndFirebase('viewDateUi', date);

    String firstOpeningDate = await cacheRepository
        .getStringCacheLocalAndFirebase(key: 'firstOpeningDate');

    if (firstOpeningDate == '') {
      await cacheRepository.addStringCacheLocalAndFirebase(
        'firstOpeningDate',
        date,
      );

      firstOpeningDate = date;
    }

    await firestoreService.addSubCollectionDoc(
      collection: itemsCollection,
      shopId: shopId,
      subCollection: dateSubCollection,
      docId: firstOpeningDate,
      data: data,
    );

    Map<String, dynamic> salesDataMap = createSalesDataMap(salesData);

    await firestoreService.addSubCollectionDoc(
      collection: salesCollection,
      shopId: shopId,
      subCollection: dateSubCollection,
      docId: firstOpeningDate,
      data: salesDataMap,
    );
  }

  Map<String, dynamic> createSalesDataMap(SalesTableModel data) {
    Map<String, dynamic> itemsData = {};

    itemsData[data.productId.toString()] = data.toMap();

    return itemsData;
  }

  Future<void> editOpeningData(String date, Map<String, dynamic> data) async {
    String shopId = await cacheRepository.getStringCacheLocal(key: 'shopId');
    await cacheRepository.addStringCacheLocalAndFirebase('viewDateUi', date);

    String firstOpeningDate = await cacheRepository
        .getStringCacheLocalAndFirebase(key: 'firstOpeningDate');

    if (firstOpeningDate == '') {
      await cacheRepository.addStringCacheLocalAndFirebase(
        'firstOpeningDate',
        date,
      );

      firstOpeningDate = date;
    }

    await firestoreService.addSubCollectionDoc(
      collection: itemsCollection,
      shopId: shopId,
      subCollection: dateSubCollection,
      docId: firstOpeningDate,
      data: data,
    );
  }

  Future<void> deleteOpeningData(ItemsViewModel product) async {
    String shopId = await cacheRepository.getStringCacheLocal(key: 'shopId');
    print('product.date ${product.date}');

    DocumentReference document = FirebaseFirestore.instance
        .collection(itemsCollection)
        .doc(shopId)
        .collection(dateSubCollection)
        .doc(product.date);

    DocumentSnapshot documentSnapshot = await document.get();
    print('documentSnapshot op: ${documentSnapshot.exists}');

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      if (data.isNotEmpty) {
        if (data.containsKey(product.productId.toString())) {
          document.update({product.productId.toString(): FieldValue.delete()});
        }
        debugPrint('opening item deleted');
      }
    }
  }

  Future<void> addNewClosing({
    required SalesTableModel sales,
    required ItemsTableModel item,
    required String docId,
    required String shopId,
  }) async {
    String value = await _viewDateController.getViewDateForUi();

    DocumentReference salesDocRef = FirebaseFirestore.instance
        .collection(salesCollection)
        .doc(shopId)
        .collection(dateSubCollection)
        .doc(docId);

    DocumentReference salesCumulativeDocRef = FirebaseFirestore.instance
        .collection(salesCollection)
        .doc(shopId)
        .collection(salesCumulativeSubCollection)
        .doc(docId);

    DocumentReference itemsDocRef = FirebaseFirestore.instance
        .collection(itemsCollection)
        .doc(shopId)
        .collection(dateSubCollection)
        .doc(docId);

    Map<String, dynamic> salesDataMap = createSalesDataMap(sales);
    Map<String, dynamic> itemsMap = createItemsDataMapForFirebase(item);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(salesDocRef, salesDataMap, SetOptions(merge: true));
      transaction.set(itemsDocRef, itemsMap, SetOptions(merge: true));
    });

    DocumentSnapshot snapshot = await salesDocRef.get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;

      if (data['productId'] == sales.productId) {
        List<SalesViewModel> data = await _salesFirestoreRepo.getSalesDoc(
          value,
          shopId,
        );
        SalesCumulativeModel salesCumulative = await _salesFirestoreRepo
            .calculateSalesCumulative(data);

        await salesCumulativeDocRef.set(
          salesCumulative.toMap(),
          SetOptions(merge: true),
        );
      } else {
        print('Product does not exist');
      }
    }
  }

  Map<String, dynamic> createItemsDataMapForFirebase(ItemsTableModel data) {
    Map<String, dynamic> itemsData = {};

    itemsData[data.productId.toString()] = data.toMap();

    return itemsData;
  }

  Future<bool> checkClosingExist(String date) async {
    String shopId = await cacheRepository.getStringCacheLocal(key: 'shopId');

    DocumentReference itemsDocRef = FirebaseFirestore.instance
        .collection(itemsCollection)
        .doc(shopId)
        .collection(dateSubCollection)
        .doc(date);
    DocumentSnapshot documentSnapshot = await itemsDocRef.get();

    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    if (data.isEmpty) return true;

    bool isClosingNotEntered = data.values.any(
      (v) => v['totalCloseRetailUnits'] == -1,
    );

    print('isClosingNotEntered $isClosingNotEntered');
    return !isClosingNotEntered;
  }

  Future<bool> checkClosingNotExist(String date) async {
    String shopId = await cacheRepository.getStringCacheLocal(key: 'shopId');

    DocumentReference itemsDocRef = FirebaseFirestore.instance
        .collection(itemsCollection)
        .doc(shopId)
        .collection(dateSubCollection)
        .doc(date);
    DocumentSnapshot documentSnapshot = await itemsDocRef.get();

    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    if (data.isEmpty) return true;

    bool isClosingNotEntered = data.values.any(
      (v) => v['totalCloseRetailUnits'] != -1,
    );

    print('isClosingNotEntered $isClosingNotEntered');
    return isClosingNotEntered;
  }

  Future<List<String>> checkTodayYesterdayDataExist() async {
    String shopId = await cacheRepository.getStringCacheLocal(key: 'shopId');
    List<String> dates = [];

    DateFormat formatter = DateFormat('yyyy-MM-dd');

    String today = formatter.format(DateTime.now());
    String yesterday = formatter.format(
      DateTime.now().subtract(const Duration(days: 1)),
    );

    DocumentSnapshot todayDoc = await FirebaseFirestore.instance
        .collection(itemsCollection)
        .doc(shopId)
        .collection(dateSubCollection)
        .doc(today)
        .get();

    DocumentSnapshot yesterdayDoc = await FirebaseFirestore.instance
        .collection(itemsCollection)
        .doc(shopId)
        .collection(dateSubCollection)
        .doc(yesterday)
        .get();

    if (!todayDoc.exists) {
      dates.add(today);
    }
    if (!yesterdayDoc.exists) {
      dates.add(yesterday);
    }

    return dates;
  }

  Future<void> cbToOb(String lastDataExistDate, String obDate) async {
    String shopId = await cacheRepository.getStringCacheLocal(key: 'shopId');
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection(itemsCollection)
        .doc(shopId)
        .collection(dateSubCollection)
        .doc(lastDataExistDate)
        .get();

    if (!doc.exists) return;

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    if (data.isEmpty) return;

    DocumentReference itemsDocRef = FirebaseFirestore.instance
        .collection(itemsCollection)
        .doc(shopId)
        .collection(dateSubCollection)
        .doc(obDate);

    DocumentReference salesDocRef = FirebaseFirestore.instance
        .collection(salesCollection)
        .doc(shopId)
        .collection(dateSubCollection)
        .doc(obDate);

    // items id
    int lastItemsId = await cacheRepository.getIntCacheFirebase(
      key: 'lastItemsId',
    );

    // sales id
    int lastSalesId = await cacheRepository.getIntCacheFirebase(
      key: 'lastSalesId',
    );

    // items
    List<ItemsTableModel> itemsModelData = [];
    List<SalesTableModel> salesModelData = [];

    String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    String currentDate = DateTime.now().toString().substring(0, 10);

    //change date add today item collection data
    data.forEach((key, value) {
      lastItemsId++;
      ItemsTableModel newOpening = ItemsTableModel(
        id: lastItemsId + 1,
        productId: value['productId'],
        phoneNumber: value['phoneNumber'],
        date: currentDate,
        time: currentTime,
        openingBundle: value['closingBundle'],
        openingRetail: value['closingRetail'],
        actualBundle: value['closingBundle'],
        actualRetail: value['closingRetail'],
        closingBundle: -1,
        closingRetail: -1,
        totalOpenRetailUnits: value['totalCloseRetailUnits'],
        totalCloseRetailUnits: -1,
        totalActualRetailUnits: value['totalCloseRetailUnits'],
        totalPriceOpening: value['totalPriceClosing'],
        totalPriceClosing: -1,
        totalPriceActual: value['totalPriceClosing'],
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
      itemsModelData.add(newOpening);
    });

    await cacheRepository.addIntCacheFirebase('lastItemsId', lastItemsId + 1);
    Map<String, dynamic> itemsMap = createItemsListDataMapForFirebase(
      itemsModelData,
    );

    //change date add sales collection data
    data.forEach((key, value) {
      lastSalesId++;
      SalesTableModel salesData = SalesTableModel(
        id: lastSalesId + 1,
        productId: value['productId'],
        phoneNumber: value['phoneNumber'],
        date: currentDate,
        time: currentTime,
        totalPriceSales: -1,
        totalSalesRetailUnits: -1,
        salesBundle: -1,
        salesRetail: -1,
        isSynced: 1,
      );
      salesModelData.add(salesData);
    });

    await cacheRepository.addIntCacheFirebase('lastSalesId', lastSalesId + 1);
    Map<String, dynamic> salesMap = createSalesListDataMap(salesModelData);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(salesDocRef, salesMap, SetOptions(merge: true));
      transaction.set(itemsDocRef, itemsMap, SetOptions(merge: true));
    });
  }

  Map<String, dynamic> createItemsListDataMapForFirebase(
    List<ItemsTableModel> data,
  ) {
    Map<String, dynamic> itemsData = {};

    for (var item in data) {
      itemsData[item.productId.toString()] = item.toMap();
    }

    return itemsData;
  }

  Map<String, dynamic> createSalesListDataMap(List<SalesTableModel> data) {
    Map<String, dynamic> itemsData = {};

    for (var item in data) {
      itemsData[item.productId.toString()] = item.toMap();
    }

    return itemsData;
  }
}

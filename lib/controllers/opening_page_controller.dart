import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/Internet_connection_repo.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';
import 'package:stock_app_web/core/repositories/download_pdf_repo.dart';
import 'package:stock_app_web/core/repositories/firestore_repo.dart';
import 'package:stock_app_web/core/repositories/opening_firestore_repo.dart';
import 'package:stock_app_web/models/brand_model.dart';
import 'package:stock_app_web/models/items_table_model.dart';
import 'package:stock_app_web/models/sales_table_model.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class OpeningPageController {
  final _openingFireRepo = getIt<OpeningFirestoreRepo>();
  final _cache = getIt<CacheRepository>();
  final _downloadPdf = getIt<DownloadPdfRepo>();
  final _internetConnectionRepo = getIt<InternetConnectionRepo>();
  final fireRepo = getIt<FirestoreRepo>();

  Future<void> addViewType(String key, String value) async {
    await _cache.addStringCacheLocalAndFirebase(key, value);
  }

  Future<String> getViewType(String key) async {
    return await _cache.getStringCacheLocalAndFirebase(key: key);
  }

  Future<String> getMobileNumber(String key) async {
    return await _cache.getStringCacheLocalAndFirebase(key: key);
  }

  Future<List<BrandModel>> getActiveBrands() async {
    List<BrandModel> data = await _openingFireRepo.getActiveBrands();
    return data;
  }

  Future<List<ItemsViewModel>> getOpeningData(
    String date,
    String shopId,
  ) async {
    List<ItemsViewModel> data = await _openingFireRepo.getOpeningDoc(
      date,
      shopId,
    );
    return data;
  }

  Future<void> downloadPdf(
    BuildContext context,
    bool isDailyStatement,
    bool isSmsPage,
  ) async {
    await _downloadPdf.downloadEmptyPdf(context, isDailyStatement, isSmsPage);
  }

  Future<void> addNewOpening({
    required int inputCase,
    required int inputBottle,
    required int bottlePerBundle,
    required int price,
    required int productId,
    required int mobileNumber,
  }) async {
    bool isConnected = await _internetConnectionRepo.checkInternetConnection();
    if (isConnected) {
      int totalBottles = (inputCase * bottlePerBundle) + inputBottle;
      int totalPrice = totalBottles * price;
      int formattedCase = totalBottles ~/ bottlePerBundle;
      int formattedBottle = totalBottles % bottlePerBundle;

      String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      String currentDate = DateTime.now().toString().substring(0, 10);

      // items id
      int lastItemsId = await _cache.getIntCacheFirebase(key: 'lastItemsId');
      await _cache.addIntCacheFirebase('lastItemsId', lastItemsId + 1);
      // sales id
      int lastSalesId = await _cache.getIntCacheFirebase(key: 'lastSalesId');
      await _cache.addIntCacheFirebase('lastSalesId', lastSalesId + 1);

      ItemsTableModel newOpening = ItemsTableModel(
        id: lastItemsId + 1,
        productId: productId,
        phoneNumber: mobileNumber,
        date: currentDate,
        time: currentTime,
        openingBundle: formattedCase,
        openingRetail: formattedBottle,
        actualBundle: formattedCase,
        actualRetail: formattedBottle,
        closingBundle: -1,
        closingRetail: -1,
        totalOpenRetailUnits: totalBottles,
        totalCloseRetailUnits: -1,
        totalActualRetailUnits: totalBottles,
        totalPriceOpening: totalPrice,
        totalPriceClosing: -1,
        totalPriceActual: totalPrice,
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

      Map<String, dynamic> itemsMap = createItemsDataMapForFirebase(newOpening);

      SalesTableModel salesData = SalesTableModel(
        id: lastSalesId + 1,
        productId: productId,
        phoneNumber: mobileNumber,
        date: currentDate,
        time: currentTime,
        totalPriceSales: -1,
        totalSalesRetailUnits: -1,
        salesBundle: -1,
        salesRetail: -1,
        isSynced: 1,
      );

      await _openingFireRepo.addOpeningData(currentDate, itemsMap, salesData);
    } else {
      showErrorToast('No Internet Connection');
    }
  }

  Future<void> editOpening({
    required int inputCase,
    required int inputBottle,
    required int mobileNumber,
    required ItemsViewModel product,
  }) async {
    bool isConnected = await _internetConnectionRepo.checkInternetConnection();
    if (isConnected) {
      int totalBottles = (inputCase * product.bottlePerBundle) + inputBottle;
      int totalPrice = totalBottles * product.price;
      int formattedCase = totalBottles ~/ product.bottlePerBundle;
      int formattedBottle = totalBottles % product.bottlePerBundle;

      String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      String currentDate = DateTime.now().toString().substring(0, 10);

      ItemsTableModel newOpening = ItemsTableModel(
        productId: product.productId,
        phoneNumber: mobileNumber,
        date: currentDate,
        time: currentTime,
        openingBundle: formattedCase,
        openingRetail: formattedBottle,
        actualBundle: formattedCase,
        actualRetail: formattedBottle,
        closingBundle: -1,
        closingRetail: -1,
        totalOpenRetailUnits: totalBottles,
        totalCloseRetailUnits: -1,
        totalActualRetailUnits: totalBottles,
        totalPriceOpening: totalPrice,
        totalPriceClosing: -1,
        totalPriceActual: totalPrice,
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

      Map<String, dynamic> itemsMap = createItemsDataMapForFirebase(newOpening);

      await _openingFireRepo.editOpeningData(currentDate, itemsMap);
    } else {
      showErrorToast('No Internet Connection');
    }
  }

  Map<String, dynamic> createItemsDataMapForFirebase(ItemsTableModel data) {
    Map<String, dynamic> itemsData = {};

    itemsData[data.productId.toString()] = data.toMap();

    return itemsData;
  }

  Future<bool> checkFirstDay() async {
    bool isFirstDay = await _openingFireRepo.checkFirstDay();
    return isFirstDay;
  }

  Future<void> deleteOpening(ItemsViewModel product) async {
    await _openingFireRepo.deleteOpeningData(product);
  }

  Future<List<String>> getDates(String? lastDate, int pageSize) async {
    final dates = await fireRepo.loadFirstPageViewDate(
      lastDate: lastDate,
      limit: pageSize,
    );
    return dates;
  }

  Future<bool> checkClosingExist(String date) async {
    bool isExist = await _openingFireRepo.checkClosingExist(date);
    return isExist;
  }

  Future<List<String>> checkTodayYesterdayDataExist() async {
    List<String> isExist = await _openingFireRepo
        .checkTodayYesterdayDataExist();
    return isExist;
  }

  Future<void> cbToOb(String lastDataExistDate, String obDate) async {
    await _openingFireRepo.cbToOb(lastDataExistDate, obDate);
  }
}

import 'package:intl/intl.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/Internet_connection_repo.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';
import 'package:stock_app_web/core/repositories/firestore_repo.dart';
import 'package:stock_app_web/core/repositories/opening_firestore_repo.dart';
import 'package:stock_app_web/models/items_table_model.dart';
import 'package:stock_app_web/models/sales_table_model.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class ClosingPageController {
  final _cache = getIt<CacheRepository>();
  final _openingFirestoreRepo = getIt<OpeningFirestoreRepo>();
  final _internetConnectionRepo = getIt<InternetConnectionRepo>();

  Future<void> addViewType(String key, String value) async {
    await _cache.addStringCacheLocalAndFirebase(key, value);
  }

  Future<String> getViewType(String key) async {
    return await _cache.getStringCacheLocalAndFirebase(key: key);
  }

  Future<List<ItemsViewModel>> getClosingData(
    String date,
    String shopId,
  ) async {
    List<ItemsViewModel> data = await _openingFirestoreRepo.getOpeningDoc(
      date,
      shopId,
    );
    return data;
  }

  Future<void> addNewClosing({
    required ItemsViewModel currentItem,
    required int mobileNumber,
    required String currentDate,
    required int inputCase,
    required int inputBottle,
  }) async {
    bool isConnected = await _internetConnectionRepo.checkInternetConnection();
    if (isConnected) {
      String shopId = await _cache.getStringCacheLocal(key: 'shopId');
      String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());

      // items
      int totalClosingRetailUnits =
          (inputCase * currentItem.bottlePerBundle) + inputBottle;
      int totalClosingPrice = totalClosingRetailUnits * currentItem.price;
      int closingBundle =
          totalClosingRetailUnits ~/ currentItem.bottlePerBundle;
      int closingRetail = totalClosingRetailUnits % currentItem.bottlePerBundle;

      currentItem.phoneNumber = currentItem.phoneNumber;
      currentItem.closingBundle = closingBundle;
      currentItem.closingRetail = closingRetail;
      currentItem.totalCloseRetailUnits = totalClosingRetailUnits;
      currentItem.totalPriceClosing = totalClosingPrice;
      currentItem.isSynced = 1;

      // sales
      int totalSalesRetailUnits =
          currentItem.totalActualRetailUnits - totalClosingRetailUnits;
      int formattedCase = totalSalesRetailUnits ~/ currentItem.bottlePerBundle;
      int formattedBottle = totalSalesRetailUnits % currentItem.bottlePerBundle;
      int totalPriceSales = totalSalesRetailUnits * currentItem.price;

      SalesTableModel sales = SalesTableModel(
        id: currentItem.id,
        productId: currentItem.productId,
        phoneNumber: mobileNumber,
        date: currentDate,
        time: currentTime,
        totalPriceSales: totalPriceSales,
        totalSalesRetailUnits: totalSalesRetailUnits,
        salesBundle: formattedCase,
        salesRetail: formattedBottle,
        isSynced: 1,
      );

      await _openingFirestoreRepo.addNewClosing(
        sales: sales,
        item: ItemsTableModel.fromMap(currentItem.toMap()),
        docId: currentDate,
        shopId: shopId,
      );
    } else {
      showErrorToast('No Internet Connection');
    }
  }
}

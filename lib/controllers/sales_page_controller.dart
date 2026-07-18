import 'package:intl/intl.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/Internet_connection_repo.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';
import 'package:stock_app_web/core/repositories/firestore_repo.dart';
import 'package:stock_app_web/core/repositories/opening_firestore_repo.dart';
import 'package:stock_app_web/core/repositories/sales_firestore_repo.dart';
import 'package:stock_app_web/models/items_table_model.dart';
import 'package:stock_app_web/models/sales_table_model.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class SalesPageController {
  final _internetConnectionRepo = getIt<InternetConnectionRepo>();
  final _cache = getIt<CacheRepository>();
  final _openingFireRepo = getIt<OpeningFirestoreRepo>();
  final _salesFirestoreRepo = getIt<SalesFirestoreRepo>();

  Future<List<SalesViewModel>> getSalesData(String date, String shopId) async {
    List<SalesViewModel> data = await _salesFirestoreRepo.getSalesDoc(
      date,
      shopId,
    );
    return data;
  }

  Future<List<SalesEntryViewModel>> getSalesEntryModelData(
    String date,
    String shopId,
  ) async {
    List<SalesEntryViewModel> data = await _salesFirestoreRepo.getSalesEntryDoc(
      date,
      shopId,
    );
    return data;
  }

  Future<void> addNewSales({
    required SalesEntryViewModel currentItem,
    required int mobileNumber,
    required String currentDate,
    required int inputBottle,
  }) async {
    bool isConnected = await _internetConnectionRepo.checkInternetConnection();
    if (isConnected) {
      String shopId = await _cache.getStringCacheLocal(key: 'shopId');

      List<ItemsViewModel> itemsModelData = await _openingFireRepo
          .getOpeningDoc(currentDate, shopId);

      if (itemsModelData.isEmpty) return;

      final item = itemsModelData
          .where((e) => e.productId == currentItem.productId)
          .firstOrNull;

      if (item != null) {
        int totalSalesRetailUnits = inputBottle;
        int formattedCase =
            totalSalesRetailUnits ~/ currentItem.bottlePerBundle;
        int formattedBottle =
            totalSalesRetailUnits % currentItem.bottlePerBundle;
        int totalPriceSales = inputBottle * currentItem.price;

        String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());

        // // sales id
        // int lastSalesId = await _cache.getIntCacheFirebase(key: 'lastSalesId');
        // await _cache.addIntCacheFirebase('lastSalesId', lastSalesId + 1);

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

        print('item.id: ${item.id}, shopId: $shopId');
        print(item.productId);
        int totalClosingRetailUnits =
            item.totalActualRetailUnits - sales.totalSalesRetailUnits;
        int closingBundle = totalClosingRetailUnits ~/ item.bottlePerBundle;
        int closingRetail = totalClosingRetailUnits % item.bottlePerBundle;
        int totalClosingPrice = totalClosingRetailUnits * item.price;

        print(
          '$totalClosingRetailUnits $closingBundle $closingRetail $totalClosingPrice',
        );

        item.phoneNumber = sales.phoneNumber;
        item.closingBundle = closingBundle;
        item.closingRetail = closingRetail;
        item.totalCloseRetailUnits = totalClosingRetailUnits;
        item.totalPriceClosing = totalClosingPrice;
        item.isSynced = 1;
        item.id = int.parse(item.id.toString());
        print('item.toMap(): ${item.toMap()}');

        ItemsTableModel itemsTableModel = ItemsTableModel.fromMap(item.toMap());

        await _salesFirestoreRepo.addNewSales(
          sales: sales,
          docId: currentDate,
          item: itemsTableModel,
          shopId: shopId,
        );
      }
    } else {
      showErrorToast('No Internet Connection');
    }
  }
}

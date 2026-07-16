import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/services/firestore_service.dart';

class MatchE2eController {
  final _viewDateController = getIt<ViewDateController>();
  final firestoreService = getIt<FirestoreService>();

  Future<bool> allowChangeTheEntryType() async {
    String shopId = await getIt<ShopIdController>().getShopId();
    String value = await _viewDateController.getViewDateForUi();

    bool isValidClosing = await firestoreService.hasValidTotalCloseRetailUnits(
      collection: 'items',
      shopId: shopId,
      subCollection: 'date',
      docId: value,
    );
    bool isValidSales = await firestoreService.hasValidTotalSalesRetailUnits(
      collection: 'items',
      shopId: shopId,
      subCollection: 'date',
      docId: value,
    );

    if (isValidClosing) {
      print('totalCloseRetailUnits is not -1');
    } else {
      print('Document closingdoes not exist or value is -1');
    }
    if (isValidSales) {
      print('TotalSalesRetailUnits is not -1');
    } else {
      print('Document sales does not exist or value is -1');
    }

    return isValidClosing && isValidSales;
  }
}

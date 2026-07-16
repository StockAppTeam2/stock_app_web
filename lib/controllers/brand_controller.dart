import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/Internet_connection_repo.dart';
import 'package:stock_app_web/core/repositories/brand_firestore_repo.dart';
import 'package:stock_app_web/models/brand_model.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class BrandController {
  final brandFirestoreRepo = getIt<BrandFirestoreRepo>();
  final _internetConnectionRepo = getIt<InternetConnectionRepo>();
  final _viewDateController = getIt<ViewDateController>();

  Future<List<BrandModel>> loadBrands() async {
    String shopId = await getIt<ShopIdController>().getShopId();

    List<BrandModel> brandData = await brandFirestoreRepo.getBrandCollection(
      shopId,
    );
    return brandData;
  }

  Future<void> addNewBrand(String productId, BrandModel brand) async {
    bool isConnected = await _internetConnectionRepo.checkInternetConnection();
    if (isConnected) {
      String shopId = await getIt<ShopIdController>().getShopId();

      Map<String, dynamic> brandData = {};

      brandData[brand.productId.toString()] = brand.toMap();

      await brandFirestoreRepo.addBrand(productId, shopId, brandData, brand);
    } else {
      showErrorToast('No Internet Connection');
    }
  }

  Future<bool> checkCurrentStockIsZero(String productId) async {
    bool isConnected = await _internetConnectionRepo.checkInternetConnection();
    if (isConnected) {
      String shopId = await getIt<ShopIdController>().getShopId();
      String viewDate = await _viewDateController.getViewDateForUi();

      bool isZero = await brandFirestoreRepo.checkCurrentStockIsZero(
        productId,
        shopId,
        viewDate,
      );
      return isZero;
    } else {
      showErrorToast('No Internet Connection');
    }
    return false;
  }

  Future<void> editAllTableData(String productId, BrandModel brand) async {
    bool isConnected = await _internetConnectionRepo.checkInternetConnection();
    if (isConnected) {
      String shopId = await getIt<ShopIdController>().getShopId();

      String viewDate = await _viewDateController.getViewDateForUi();

      Map<String, dynamic> brandData = {};

      brandData[brand.productId.toString()] = brand.toMap();

      await brandFirestoreRepo.editBrand(
        productId,
        shopId,
        brandData,
        brand,
        viewDate,
      );
    } else {
      showErrorToast('No Internet Connection');
    }
  }

  Future<void> deleteBrand(String productId) async {
    String shopId = await getIt<ShopIdController>().getShopId();
    await brandFirestoreRepo.deleteBrand(productId, shopId);
  }
}

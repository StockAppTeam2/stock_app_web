import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';

class ShopIdController {
  final cacheRepo = getIt<CacheRepository>();

  String _shopId = '';

  String get shopId => _shopId;

  Future<String> getShopId() async {
    String shopId = await cacheRepo.getStringCacheLocal(key: 'shopId');
    _shopId = shopId;
    return shopId;
  }

  Future<void> setShopId(String value) async {
    await cacheRepo.addStringCacheLocal('shopId', value);
  }
}

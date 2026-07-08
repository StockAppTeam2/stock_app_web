import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';
import 'package:stock_app_web/core/repositories/firestore_repo.dart';
import 'package:stock_app_web/models/items_table_model.dart';

class ClosingPageController {
  final _cache = getIt<CacheRepository>();
  final _fireRepo = getIt<FirestoreRepo>();

  Future<void> addViewType(String key, String value) async {
    await _cache.addStringCache(key, value);
  }

  Future<String> getViewType(String key) async {
    return await _cache.getStringCache(key: key);
  }

  Future<List<ItemsViewModel>> getClosingData(
    String date,
    String shopId,
  ) async {
    List<ItemsViewModel> data = await _fireRepo.getOpeningDoc(date, shopId);
    return data;
  }
}

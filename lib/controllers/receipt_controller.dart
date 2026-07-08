import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';
import 'package:stock_app_web/core/repositories/firestore_repo.dart';
import 'package:stock_app_web/models/inward_table_model.dart';

class ReceiptController {
  final _cache = getIt<CacheRepository>();
  final _fireRepo = getIt<FirestoreRepo>();

  Future<void> addViewDate(String key, String value) async {
    await _cache.addStringCache(key, value);
  }

  Future<String> getViewDate(String key) async {
    return await _cache.getStringCache(key: key);
  }

  Future<List<InwardViewModel>> getInwardData(
    String date,
    String shopId,
  ) async {
    List<InwardViewModel> data = await _fireRepo.getInwardDoc(date, shopId);
    return data;
  }
}

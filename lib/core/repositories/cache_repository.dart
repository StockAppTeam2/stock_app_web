import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/services/local_cache_service.dart';
import 'package:stock_app_web/core/services/firestore_cache_service.dart';

class CacheRepository {
  final cacheService = getIt<LocalCacheService>();
  final firestoreCacheService = getIt<FirestoreCacheService>();

  // ========= add cache ========
  Future<void> addStringCacheLocal(String key, String value) async {
    await cacheService.addStringCache(key: key, value: value);
  }

  Future<void> addStringCacheFirebase(String key, String value) async {
    String shopId = await cacheService.getStringCache(key: 'shopId');
    if (shopId != '') {
      await firestoreCacheService.addCache(docId: shopId, data: {key: value});
    }
  }

  Future<void> addIntCacheFirebase(String key, int value) async {
    String shopId = await cacheService.getStringCache(key: 'shopId');
    if (shopId != '') {
      await firestoreCacheService.addCache(docId: shopId, data: {key: value});
    }
  }

  Future<void> addStringCacheLocalAndFirebase(String key, String value) async {
    await addStringCacheLocal(key, value);
    await addStringCacheFirebase(key, value);
  }

  // =========== get cache ===========
  Future<String> getStringCacheLocal({required String key}) async {
    String value = await cacheService.getStringCache(key: key);

    return value;
  }

  Future<String> getStringCacheFirebase({required String key}) async {
    String shopId = await cacheService.getStringCache(key: 'shopId');
    if (shopId == '') return '';
    final doc = await firestoreCacheService.getCache(docId: shopId);

    if (!doc.exists) return '';
    final data = doc.data() as Map<String, dynamic>;

    if (data.isEmpty || !data.containsKey(key)) return '';

    return data[key];
  }

  Future<int> getIntCacheFirebase({required String key}) async {
    String shopId = await cacheService.getStringCache(key: 'shopId');
    if (shopId == '') return 0;
    final doc = await firestoreCacheService.getCache(docId: shopId);

    if (!doc.exists) return 0;
    final data = doc.data() as Map<String, dynamic>;

    if (data.isEmpty || !data.containsKey(key)) return 0;

    return data[key];
  }

  Future<String> getStringCacheLocalAndFirebase({required String key}) async {
    String value = await getStringCacheLocal(key: key);
    if (value == '') {
      String cache = await getStringCacheFirebase(key: key);
      return cache;
    }
    return value;
  }
}

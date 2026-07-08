import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/services/cache_service.dart';
import 'package:stock_app_web/core/services/firestore_service.dart';

class CacheRepository {
  final cacheService = getIt<CacheService>();
  final firestoreService = getIt<FirestoreService>();

  Future<void> addStringCache(String key, String value) async {
    await firestoreService.add(
      collection: 'web_cache',
      docId: '3810',
      data: {key: value},
    );
    await cacheService.addStringCache(key: key, value: value);
  }

  Future<String> getStringCache({required String key}) async {
    String value = await cacheService.getStringCache(key: key);
    if (value == '') {
      final doc = await firestoreService.getDocument(
        collection: 'web_cache',
        docId: '3810',
      );

      if (!doc.exists) {
        DateTime dateTime = DateTime.now();
        await firestoreService.add(
          collection: 'web_cache',
          docId: '3810',
          data: {key: dateTime.toString().substring(0, 10)},
        );
        return dateTime.toString().substring(0, 10);
      }

      final data = doc.data() as Map<String, dynamic>;

      if (data.isEmpty || !data.containsKey(key)) return '';
      return data[key];
    }
    return value;
  }
}

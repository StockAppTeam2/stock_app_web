import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/brand_firestore_repo.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';
import 'package:stock_app_web/core/services/firestore_service.dart';
import 'package:stock_app_web/models/brand_model.dart';
import 'package:stock_app_web/models/inward_table_model.dart';
import 'package:stock_app_web/models/items_table_model.dart';
import 'package:stock_app_web/models/sales_table_model.dart';

class FirestoreRepo {
  final firestoreService = getIt<FirestoreService>();
  final cacheRepository = getIt<CacheRepository>();

  Future<List<String>> loadFirstPageViewDate({
    String? lastDate,
    int limit = 10,
  }) async {
    String shopId = await cacheRepository.getStringCacheLocal(key: 'shopId');
    final snapshot = await firestoreService.getPaginatedDataUsingLastDate(
      collection: 'items',
      subCollection: 'date',
      shopId: shopId,
      lastDate: lastDate,
      limit: limit,
    );

    return snapshot.docs.map((e) => e.id).toList();
  }

  Future<List<String>> getBrandDetails({
    required String shopId,
    required String docId,
    required String key,
  }) async {
    QuerySnapshot snapshot = await firestoreService.getSubCollection(
      collection: 'master',
      shopId: shopId,
      subCollection: docId,
    );

    List<String> uniqueGroups = snapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)[key] as String)
        .toSet()
        .toList();

    return uniqueGroups;
  }

  Future<Map<String, dynamic>> getReportsData({
    required String shopId,
    required String docId,
  }) async {
    Map<String, dynamic> data = await firestoreService.getReportsData(
      shopId: shopId,
      docId: docId,
    );
    return data;
  }

  Future<DocumentSnapshot> getDocument({
    required String collection,
    required String docId,
  }) async {
    return firestoreService.getDocument(collection: collection, docId: docId);
  }
}

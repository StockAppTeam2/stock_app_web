import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCacheService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const cacheCollection = 'web_cache';

  Future<void> addCache({
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    return await _db
        .collection(cacheCollection)
        .doc(docId)
        .set(data, SetOptions(merge: true));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCache({
    required String docId,
  }) {
    return _db.collection(cacheCollection).doc(docId).get();
  }
}

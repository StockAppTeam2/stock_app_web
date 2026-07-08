import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServiceItems {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addSampleDataFirestore({
    required String mainCollection,
    required String mainDocId,
    required String subCollection,
    required String subDocId,
    required Map<String, dynamic> data,
  }) async {
    await _db.runTransaction((transaction) async {
      DocumentReference docRef = _db
          .collection(mainCollection)
          .doc(mainDocId)
          .collection(subCollection)
          .doc(subDocId);

      transaction.set(docRef, data, SetOptions(merge: true));
    });
  }
}

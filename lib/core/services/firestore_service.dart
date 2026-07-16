import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  int retryCount = 0;

  Future<DocumentSnapshot> getDocument({
    required String collection,
    required String docId,
  }) async {
    return await _db.collection(collection).doc(docId).get();
  }

  Future<DocumentSnapshot> getSubCollectionDocument({
    required String collection,
    required String shopId,
    required String subCollection,
    required String docId,
  }) async {
    return await _db
        .collection(collection)
        .doc(shopId)
        .collection(subCollection)
        .doc(docId)
        .get();
  }

  Future<QuerySnapshot> getSubCollection({
    required String collection,
    required String shopId,
    required String subCollection,
  }) async {
    return await _db
        .collection(collection)
        .doc(shopId)
        .collection(subCollection)
        .get();
  }

  Future<List<bool>> collectionExists({
    required String collection,
    required String shopId,
    required String subCollection,
  }) async {
    final snapshot = await _db
        .collection(collection)
        .doc(shopId)
        .collection(subCollection)
        .limit(2)
        .get();

    return [snapshot.docs.isEmpty, snapshot.docs.length == 1];
  }

  Future<void> add({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) {
    return _db
        .collection(collection)
        .doc(docId)
        .set(data, SetOptions(merge: true));
  }

  Future<void> addSubCollectionDoc({
    required String collection,
    required String shopId,
    required String subCollection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    return await _db
        .collection(collection)
        .doc(shopId)
        .collection(subCollection)
        .doc(docId)
        .set(data, SetOptions(merge: true));
  }

  Future<void> addSalesAdjustment({
    required String mainCollection,
    required String mainDocId,
    required String subCollection,
    required String subDocId,
    required Map<String, dynamic> data,
  }) async {
    return await _db
        .collection(mainCollection)
        .doc(mainDocId)
        .collection(subCollection)
        .doc(subDocId)
        .set(data);
  }

  Future<bool> createMastersDefaultBrands(
    String shopId,
    String brandFormat,
  ) async {
    List<Map<String, String>> updatedDocs = [];
    try {
      DateTime modifiedDate = DateTime.now();

      Future<void> updateDocuments({
        required CollectionReference collectionRef,
        required String subcollectionRef,
        required String idField,
      }) async {
        WriteBatch batch = _db.batch();
        int batchCount = 0;
        int maxBatchSize = 450;
        QuerySnapshot snapshot = await collectionRef.get();
        int snapshotLen = 0;

        for (var doc in snapshot.docs) {
          print('brand update count $batchCount');
          Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
          docData['shopId'] = shopId;
          String docId = docData[idField].toString();
          DocumentReference masterDocRef = _db
              .collection('master')
              .doc(shopId)
              .collection(subcollectionRef)
              .doc(docId);

          batch.set(masterDocRef, docData, SetOptions(merge: true));
          updatedDocs.add({"collection": subcollectionRef, "docId": docId});
          batchCount++;
          snapshotLen++;

          if (batchCount >= maxBatchSize) {
            await batch.commit();
            batch = _db.batch();
            batchCount = 0;
          }
        }
        if (batchCount > 0) {
          await batch.commit();
          snapshotLen = 0;
          batchCount = 0;
        }
        // Update master flag
        await _db.collection('master').doc(shopId).set({
          'isNewBrandUpdated': modifiedDate.toString(),
        }, SetOptions(merge: true));

        updatedDocs.add({"collection": "master", "docId": shopId});
        await Future.delayed(Duration(milliseconds: 200));
        AggregateQuerySnapshot brandCount = await _db
            .collection('master')
            .doc(shopId)
            .collection(subcollectionRef)
            .count()
            .get();
        int brandCounts = brandCount.count ?? 0;
        if (brandCounts == snapshotLen) {
          //retry
          if (retryCount < 1) {
            await updateDocuments(
              collectionRef: collectionRef,
              subcollectionRef: subcollectionRef,
              idField: idField,
            );
          }
        }
      }

      //
      // SIZE
      await updateDocuments(
        collectionRef: _db
            .collection('brandFormats')
            .doc(brandFormat)
            .collection('size'),
        subcollectionRef: 'size',
        idField: 'id',
      );

      // RANGE
      await updateDocuments(
        collectionRef: _db
            .collection('brandFormats')
            .doc(brandFormat)
            .collection('range'),
        subcollectionRef: 'range',
        idField: 'id',
      );

      // GROUP
      await updateDocuments(
        collectionRef: _db
            .collection('brandFormats')
            .doc(brandFormat)
            .collection('group'),
        subcollectionRef: 'group',
        idField: 'id',
      );

      // CATEGORY
      await updateDocuments(
        collectionRef: _db
            .collection('brandFormats')
            .doc(brandFormat)
            .collection('category'),
        subcollectionRef: 'category',
        idField: 'id',
      );

      // BRAND
      await updateDocuments(
        collectionRef: _db
            .collection('brandFormats')
            .doc(brandFormat)
            .collection('brand'),
        subcollectionRef: 'brand',
        idField: 'productId',
      );
      return true;
    } catch (e) {
      print('new brand creation bug: $e');
      for (var item in updatedDocs) {
        await _db
            .collection('master')
            .doc(shopId)
            .collection(item["collection"]!)
            .doc(item["docId"])
            .delete();
      }
      return false;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPaginatedDataUsingLastDoc({
    required String collectionRef,
    required DocumentSnapshot? lastDoc,
    int limit = 20,
  }) async {
    Query<Map<String, dynamic>> query = _db
        .collection(collectionRef)
        .orderBy(FieldPath.documentId, descending: true)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    return await query.get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPaginatedDataUsingLastDate({
    required String collection,
    required String subCollection,
    required String shopId,
    String? lastDate,
    int limit = 15,
  }) async {
    Query<Map<String, dynamic>> query = _db
        .collection(collection)
        .doc(shopId)
        .collection(subCollection)
        .orderBy(FieldPath.documentId, descending: true)
        .limit(limit);

    if (lastDate != null) {
      query = query.startAfter([lastDate]);
    }

    return await query.get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>>
  getPaginatedDataUsingLastDateInward({
    required String collection,
    required String subCollection,
    required String shopId,
    String? lastDate,
    int limit = 15,
  }) async {
    Query<Map<String, dynamic>> query = _db
        .collection(collection)
        .doc(shopId)
        .collection(subCollection)
        .orderBy(FieldPath.documentId, descending: true)
        .limit(limit);

    if (lastDate != null) {
      query = query.startAfter([lastDate]);
    }

    return await query.get();
  }

  Future<Map<String, dynamic>> getReportsData({
    required String shopId,
    required String docId,
  }) async {
    final docItems = await FirebaseFirestore.instance
        .collection('items')
        .doc(shopId)
        .collection('date')
        .doc(docId)
        .get();
    final docInward = await FirebaseFirestore.instance
        .collection('inward')
        .doc(shopId)
        .collection('date')
        .doc(docId)
        .get();
    final docSales = await FirebaseFirestore.instance
        .collection('sales')
        .doc(shopId)
        .collection('date')
        .doc(docId)
        .get();
    final docReturn = await FirebaseFirestore.instance
        .collection('return_stock')
        .doc(shopId)
        .collection('date')
        .doc(docId)
        .get();

    int totalOpening = 0;
    int totalInward = 0;
    int totalActual = 0;
    int totalClosing = 0;
    int totalSales = 0;
    int totalReturn = 0;

    if (docItems.exists) {
      Map<String, dynamic> data = docItems.data() as Map<String, dynamic>;

      data.forEach((productId, value) {
        if (value is Map<String, dynamic>) {
          totalActual += (value['totalPriceActual'] ?? 0) as int;
          totalClosing += (value['totalPriceClosing'] ?? 0) as int;
          totalOpening += (value['totalPriceOpening'] ?? 0) as int;
        }
      });

      print('Total Actual : $totalActual');
      print('Total Closing: $totalClosing');
      print('Total Opening: $totalOpening');
    }

    if (docInward.exists) {
      Map<String, dynamic> data = docInward.data() as Map<String, dynamic>;

      data.forEach((productId, value) {
        if (value is Map<String, dynamic>) {
          totalInward += (value['totalPriceInward'] ?? 0) as int;
        }
      });

      print('Total Inward : $totalInward');
    }

    if (docSales.exists) {
      Map<String, dynamic> data = docSales.data() as Map<String, dynamic>;

      data.forEach((productId, value) {
        if (value is Map<String, dynamic>) {
          totalSales += (value['totalPriceSales'] ?? 0) as int;
        }
      });

      print('Total Sales : $totalSales');
    }
    if (docReturn.exists) {
      Map<String, dynamic> data = docReturn.data() as Map<String, dynamic>;

      data.forEach((productId, value) {
        if (value is Map<String, dynamic>) {
          totalReturn += (value['totalPriceReturn'] ?? 0) as int;
        }
      });

      print('Total Return : $totalReturn');
    }
    return {
      'totalActual': totalActual,
      'totalClosing': totalClosing,
      'totalOpening': totalOpening,
      'totalInward': totalInward,
      'totalSales': totalSales,
      'totalReturn': totalReturn,
    };
  }

  Future<bool> hasValidTotalCloseRetailUnits({
    required String collection,
    required String shopId,
    required String subCollection,
    required String docId,
  }) async {
    final doc = await _db
        .collection(collection)
        .doc(shopId)
        .collection(subCollection)
        .doc(docId)
        .get();

    if (!doc.exists) return false;

    final data = doc.data() as Map<String, dynamic>;

    final map = data.map(
      (key, value) => MapEntry(key, Map<String, dynamic>.from(value as Map)),
    );

    bool hasValidValue = map.values.any(
      (item) => (item['totalCloseRetailUnits'] ?? -1) != -1,
    );

    if (hasValidValue) {
      print('At least one item has totalCloseRetailUnits != -1');
      return false;
    } else {
      print('All items have totalCloseRetailUnits == -1');
      return true;
    }
  }

  Future<bool> hasValidTotalSalesRetailUnits({
    required String collection,
    required String shopId,
    required String subCollection,
    required String docId,
  }) async {
    final doc = await _db
        .collection(collection)
        .doc(shopId)
        .collection(subCollection)
        .doc(docId)
        .get();

    if (!doc.exists) return false;

    final data = doc.data() as Map<String, dynamic>;

    final map = data.map(
      (key, value) => MapEntry(key, Map<String, dynamic>.from(value as Map)),
    );

    bool hasValidValue = map.values.any(
      (item) => (item['totalSalesRetailUnits'] ?? -1) != -1,
    );

    if (hasValidValue) {
      print('At least one item has totalSalesRetailUnits != -1');
      return false;
    } else {
      print('All items have totalSalesRetailUnits == -1');
      return true;
    }
  }
}

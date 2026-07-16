import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/services/firestore_service.dart';
import 'package:stock_app_web/models/brand_model.dart';

class BrandFirestoreRepo {
  final firestoreService = getIt<FirestoreService>();

  Future<List<BrandModel>> getBrandCollection(String shopId) async {
    List<BrandModel> brandModel = [];

    DocumentSnapshot documentSnapshot = await firestoreService
        .getSubCollectionDocument(
          collection: 'web_cache',
          shopId: shopId,
          subCollection: 'brand',
          docId: 'brand',
        );

    if (documentSnapshot.exists) {
      print('getBrandCollection1');
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      if (data.isEmpty) return [];

      data.forEach((key, value) {
        brandModel.add(BrandModel.fromMap(value));
      });

      return brandModel;
    } else {
      print('getBrandCollection2');
      QuerySnapshot querySnapshot = await firestoreService.getSubCollection(
        collection: 'master',
        shopId: shopId,
        subCollection: 'brand',
      );

      if (querySnapshot.docs.isEmpty) return [];

      List<Map<String, dynamic>> data = querySnapshot.docs
          .map((data) => data.data() as Map<String, dynamic>)
          .toList();

      if (data.isEmpty) return [];

      for (Map<String, dynamic> brand in data) {
        if (brand.containsKey('brandGroup')) {
          if (!brand.containsKey('buyingPrice')) {
            brand['buyingPrice'] = 0;
          }
          brandModel.add(BrandModel.fromMapForOldData(brand));
        } else if (brand.containsKey('groups')) {
          if (!brand.containsKey('buyingPrice')) {
            brand['buyingPrice'] = 0;
          }
          brandModel.add(BrandModel.fromMap(brand));
        }
      }

      Map<String, dynamic> brandBackupData = createBrandDataMapForFirebase(
        brandModel,
      );

      await firestoreService.addSubCollectionDoc(
        collection: 'web_cache',
        shopId: shopId,
        subCollection: 'brand',
        docId: 'brand',
        data: brandBackupData,
      );

      return brandModel;
    }
  }

  Map<String, dynamic> createBrandDataMapForFirebase(List<BrandModel> data) {
    Map<String, dynamic> brandData = {};

    for (var item in data) {
      brandData[item.productId.toString()] = item.toMap();
    }

    return brandData;
  }

  Future<void> addBrand(
    String productId,
    String shopId,
    Map<String, dynamic> data,
    BrandModel brand,
  ) async {
    DocumentReference masterDocRef = FirebaseFirestore.instance
        .collection('master')
        .doc(shopId)
        .collection('brand')
        .doc(productId);

    DocumentReference cacheDocRef = FirebaseFirestore.instance
        .collection('web_cache')
        .doc(shopId)
        .collection('brand')
        .doc('brand');

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(masterDocRef, brand.toMap(), SetOptions(merge: true));
      transaction.set(cacheDocRef, data, SetOptions(merge: true));
    });
  }

  Future<void> editBrand(
    String productId,
    String shopId,
    Map<String, dynamic> brandData,
    BrandModel brand,
    String docId,
  ) async {
    final firestore = FirebaseFirestore.instance;

    final itemsDocRef = firestore
        .collection('items')
        .doc(shopId)
        .collection('date')
        .doc(docId);

    final inwardDocRef = firestore
        .collection('inward')
        .doc(shopId)
        .collection('date')
        .doc(docId);

    final salesDocRef = firestore
        .collection('sales')
        .doc(shopId)
        .collection('date')
        .doc(docId);

    final salesCumulativeRef = firestore
        .collection('sales')
        .doc(shopId)
        .collection('salesCumulative')
        .doc(docId);

    final masterDocRef = firestore
        .collection('master')
        .doc(shopId)
        .collection('brand')
        .doc(productId);

    final cacheDocRef = firestore
        .collection('web_cache')
        .doc(shopId)
        .collection('brand')
        .doc('brand');

    final itemsDoc = await itemsDocRef.get();
    final inwardDoc = await inwardDocRef.get();
    final salesDoc = await salesDocRef.get();
    final salesCumulativeDoc = await salesCumulativeRef.get();

    await firestore.runTransaction((transaction) async {
      // ---------------- ITEMS ----------------

      if (itemsDoc.exists) {
        final itemsData = itemsDoc.data() as Map<String, dynamic>;

        for (final entry in itemsData.entries) {
          if (entry.key == brand.productId.toString()) {
            final item = await updateItemData(brand, entry.value);

            transaction.set(itemsDocRef, item, SetOptions(merge: true));
          }
        }
      }

      // ---------------- INWARD ----------------

      if (inwardDoc.exists) {
        final inwardData = inwardDoc.data() as Map<String, dynamic>;

        for (final entry in inwardData.entries) {
          final keyList = entry.key.split(' ');

          if (keyList.first == brand.productId.toString()) {
            final inward = await updateInwardData(
              brand,
              entry.value,
              entry.key,
            );

            transaction.set(inwardDocRef, inward, SetOptions(merge: true));
          }
        }
      }

      // ---------------- SALES ----------------

      if (salesDoc.exists) {
        final salesData = salesDoc.data() as Map<String, dynamic>;

        for (final entry in salesData.entries) {
          final usersData = await updateSalesData(brand, entry.value);

          final sales = usersData[0] as Map<String, dynamic>;

          transaction.set(salesDocRef, sales, SetOptions(merge: true));

          if (salesCumulativeDoc.exists) {
            final cumulative =
                salesCumulativeDoc.data() as Map<String, dynamic>;

            if (cumulative.containsKey('totalCumulative')) {
              final salesCumulative = usersData[1] as int;

              transaction.set(salesCumulativeRef, {
                'totalCumulative':
                    (cumulative['totalCumulative'] as int) - salesCumulative,
              }, SetOptions(merge: true));
            }
          }
        }
      }

      // ---------------- BRAND ----------------

      transaction.set(masterDocRef, brand.toMap(), SetOptions(merge: true));

      // ---------------- CACHE ----------------

      transaction.set(cacheDocRef, brandData, SetOptions(merge: true));
    });
  }

  Future<Map<String, dynamic>> updateItemData(
    BrandModel brandModel,
    Map<String, dynamic> value,
  ) async {
    Map<String, dynamic> usersData = {};

    int totalOpenRetailUnitsF = value['totalOpenRetailUnits'] as int;
    int totalCloseRetailUnitsF = value['totalCloseRetailUnits'] as int;
    int totalActualRetailUnitsF = value['totalActualRetailUnits'] as int;

    int totalPriceOpening = totalOpenRetailUnitsF * brandModel.price;
    int totalPriceClosing = totalCloseRetailUnitsF * brandModel.price;
    int totalPriceActual = totalActualRetailUnitsF * brandModel.price;

    if (totalCloseRetailUnitsF == -1) {
      usersData[brandModel.productId.toString()] = {
        'totalPriceOpening': totalPriceOpening,
        'totalPriceActual': totalPriceActual,
      };
    } else {
      usersData[brandModel.productId.toString()] = {
        'totalPriceOpening': totalPriceOpening,
        'totalPriceClosing': totalPriceClosing,
        'totalPriceActual': totalPriceActual,
      };
    }

    return usersData;
  }

  Future<Map<String, dynamic>> updateInwardData(
    BrandModel brandModel,
    Map<String, dynamic> value,
    String key,
  ) async {
    Map<String, dynamic> usersData = {};
    int totalInwardRetailUnits = value['totalInwardRetailUnits'] as int;
    int totalPriceInward = totalInwardRetailUnits * brandModel.price;

    usersData[key] = {'totalPriceInward': totalPriceInward};

    return usersData;
  }

  Future<List> updateSalesData(
    BrandModel brandModel,
    Map<String, dynamic> value,
  ) async {
    Map<String, dynamic> usersData = {};
    int difference = 0;

    int totalSalesRetailUnits = value['totalSalesRetailUnits'] as int;
    int totalPriceSales = totalSalesRetailUnits * brandModel.price;

    if (value.containsKey('totalPriceSales')) {
      int oldPriceSales = value['totalPriceSales'] as int;
      difference = oldPriceSales - totalPriceSales;

      usersData[brandModel.productId.toString()] = {
        'totalPriceSales': totalPriceSales,
      };
    } else if (value.containsKey('totalPrice')) {
      int oldPriceSales = value['totalPrice'] as int;
      difference = oldPriceSales - totalPriceSales;

      usersData[brandModel.productId.toString()] = {
        'totalPrice': totalPriceSales,
      };
    }

    return [usersData, difference];
  }

  Future<bool> checkCurrentStockIsZero(
    String productId,
    String shopId,
    String docId,
  ) async {
    final itemsDocRef = FirebaseFirestore.instance
        .collection('items')
        .doc(shopId)
        .collection('date')
        .doc(docId);

    final itemsDoc = await itemsDocRef.get();

    if (!itemsDoc.exists) return true;

    final data = itemsDoc.data() as Map<String, dynamic>;

    if (!data.containsKey(productId)) return true;

    final product = data[productId] as Map<String, dynamic>;

    return (product['totalActualRetailUnits'] ?? 0) == 0;
  }

  Future<void> deleteBrand(String productId, String shopId) async {
    DocumentReference masterDocRef = FirebaseFirestore.instance
        .collection('master')
        .doc(shopId)
        .collection('brand')
        .doc(productId);

    DocumentReference cacheDocRef = FirebaseFirestore.instance
        .collection('web_cache')
        .doc(shopId)
        .collection('brand')
        .doc('brand');

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.delete(masterDocRef);
      transaction.set(cacheDocRef, {
        productId: FieldValue.delete(),
      }, SetOptions(merge: true));
    });
  }
}

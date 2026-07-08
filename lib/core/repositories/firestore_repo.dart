import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/services/firestore_service.dart';
import 'package:stock_app_web/models/brand_model.dart';
import 'package:stock_app_web/models/inward_table_model.dart';
import 'package:stock_app_web/models/items_table_model.dart';
import 'package:stock_app_web/models/sales_table_model.dart';

class FirestoreRepo {
  final firestoreService = getIt<FirestoreService>();

  Future<List<String>> loadFirstPageViewDate({
    String? lastDate,
    int limit = 10,
  }) async {
    final snapshot = await firestoreService.getPaginatedDataUsingLastDate(
      collection: 'items',
      subCollection: 'date',
      shopId: '3810',
      //'10169'
      lastDate: lastDate,
      limit: limit,
    );

    return snapshot.docs.map((e) => e.id).toList();
  }

  Future<List<ItemsViewModel>> getOpeningDoc(String date, String shopId) async {
    List<ItemsViewModel> valuesList = [];

    DocumentSnapshot documentSnapshot = await firestoreService
        .getSubCollectionDocument(
          collection: 'items',
          shopId: shopId,
          subCollection: 'date',
          docId: date,
        );

    if (!documentSnapshot.exists) return [];
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    if (data.isEmpty) return [];

    List<BrandModel> brandData = await getBrandCollection(shopId);
    try {
      data.forEach((key, value) {
        Map<String, dynamic> itemMap = Map<String, dynamic>.from(value);
        // print('abcd ${itemMap['actualBundle']}');
        if (itemMap['actualBundle'] != 0 || itemMap['actualRetail'] != 0) {
          // Find matching brand
          BrandModel? brand;
          try {
            brand = brandData.firstWhere(
              (e) => e.productId == itemMap['productId'],
            );
          } catch (_) {
            brand = null;
          }

          // Merge Brand + Item
          if (brand != null) {
            itemMap.addAll(brand.toMap());
          }
          // print('itemMap: $itemMap');

          valuesList.add(ItemsViewModel.fromMap(itemMap));
        }
      });
    } catch (e) {
      print('e $e');
    }

    return valuesList;
  }

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

      print('databrand: ${data.length}');
      if (data.isEmpty) return [];
      print('data present');

      for (Map<String, dynamic> brand in data) {
        print('brand called');
        brand['buyingPrice'] = 0;
        brandModel.add(BrandModel.fromMap(brand));
        print('brand modified');
      }
      print('brandModelLL:brandModel: ${brandModel.length}');

      Map<String, dynamic> brandBackupData = createBrandDataMapForFirebase(
        brandModel,
      );
      print('brandBackupData ${brandBackupData.length}');

      await firestoreService.addSubCollectionDoc(
        collection: 'web_cache',
        shopId: shopId,
        subCollection: 'brand',
        docId: 'brand',
        data: brandBackupData,
      );
      print('daata addedd succes');

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

  Future<List<SalesViewModel>> getSalesDoc(String date, String shopId) async {
    try {
      List<SalesViewModel> valuesList = [];

      DocumentSnapshot documentSnapshot = await firestoreService
          .getSubCollectionDocument(
            collection: 'sales',
            shopId: shopId,
            subCollection: 'date',
            docId: date,
          );

      DocumentSnapshot itemDocumentSnapshot = await firestoreService
          .getSubCollectionDocument(
            collection: 'items',
            shopId: shopId,
            subCollection: 'date',
            docId: date,
          );

      if (!documentSnapshot.exists) return [];
      if (!itemDocumentSnapshot.exists) return [];

      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      Map<String, dynamic> itemData =
          itemDocumentSnapshot.data() as Map<String, dynamic>;

      if (data.isEmpty) return [];
      if (itemData.isEmpty) return [];

      List<BrandModel> brandData = await getBrandCollection(shopId);

      List<String> dataExitProduct = [];
      itemData.forEach((key, value) {
        Map<String, dynamic> itemMap = Map<String, dynamic>.from(value);
        if (itemMap['actualBundle'] != 0 || itemMap['actualRetail'] != 0) {
          dataExitProduct.add(itemMap['productId'].toString());
        }
      });

      // print('dataExitProduct $dataExitProduct');

      data.forEach((key, value) {
        Map<String, dynamic> salesMap = Map<String, dynamic>.from(value);
        if (dataExitProduct.contains(salesMap['productId'].toString())) {
          // Find matching brand
          BrandModel? brand;
          try {
            brand = brandData.firstWhere(
              (e) => e.productId == salesMap['productId'],
            );
          } catch (_) {
            brand = null;
          }

          // Merge Brand + Item
          if (brand != null) {
            salesMap.addAll(brand.toMap());
          }

          valuesList.add(SalesViewModel.fromMap(salesMap));
        }
      });
      return valuesList;
    } catch (e) {
      print('sales error: $e');
    }
    return [];
  }

  Future<List<InwardViewModel>> getInwardDoc(String date, String shopId) async {
    try {
      List<InwardViewModel> valuesList = [];

      DocumentSnapshot documentSnapshot = await firestoreService
          .getSubCollectionDocument(
            collection: 'inward',
            shopId: shopId,
            subCollection: 'date',
            docId: date,
          );

      if (!documentSnapshot.exists) return [];

      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      if (data.isEmpty) return [];

      List<BrandModel> brandData = await getBrandCollection(shopId);
      // print('data $data');
      data.forEach((key, value) {
        Map<String, dynamic> inwardMap = Map<String, dynamic>.from(value);

        // Find matching brand
        BrandModel? brand;
        try {
          brand = brandData.firstWhere(
            (e) => e.productId == inwardMap['productId'],
          );
        } catch (_) {
          brand = null;
        }

        // Merge Brand + Item
        if (brand != null) {
          inwardMap.addAll(brand.toMap());
        }
        // print('inwardMap: $inwardMap');

        valuesList.add(InwardViewModel.fromMap(inwardMap));
      });

      return valuesList;
    } catch (e) {
      print('receipt error $e');
    }
    return [];
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
}

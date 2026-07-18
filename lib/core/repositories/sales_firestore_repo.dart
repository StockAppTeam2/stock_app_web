import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/brand_firestore_repo.dart';
import 'package:stock_app_web/core/services/firestore_service.dart';
import 'package:stock_app_web/models/brand_model.dart';
import 'package:stock_app_web/models/items_table_model.dart';
import 'package:stock_app_web/models/sales_cumulative_model.dart';
import 'package:stock_app_web/models/sales_table_model.dart';

class SalesFirestoreRepo {
  final firestoreService = getIt<FirestoreService>();
  final _viewDateController = getIt<ViewDateController>();
  final _brandFirestoreRepo = getIt<BrandFirestoreRepo>();

  static const salesCollection = "sales";
  static const dateSubCollection = "date";
  static const itemsCollection = "items";
  static const salesCumulativeSubCollection = "salesCumulative";

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

      List<BrandModel> brandData = await _brandFirestoreRepo.getBrandCollection(
        shopId,
      );

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

  Future<List<SalesEntryViewModel>> getSalesEntryDoc(
    String date,
    String shopId,
  ) async {
    try {
      List<SalesEntryViewModel> valuesList = [];

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

      List<BrandModel> brandData = await _brandFirestoreRepo.getBrandCollection(
        shopId,
      );

      Map<String, Map<String, dynamic>> itemLookup = {};

      itemData.forEach((key, value) {
        final itemMap = Map<String, dynamic>.from(value);

        if (itemMap['actualBundle'] != 0 || itemMap['actualRetail'] != 0) {
          itemLookup[itemMap['productId'].toString()] = itemMap;
        }
      });

      // print('dataExitProduct $dataExitProduct');

      data.forEach((key, value) {
        final salesMap = Map<String, dynamic>.from(value);

        final productId = salesMap['productId'].toString();

        if (itemLookup.containsKey(productId)) {
          // Add brand data
          try {
            final brand = brandData.firstWhere(
              (e) => e.productId.toString() == productId,
            );
            salesMap.addAll(brand.toMap());
          } catch (_) {}

          // Add item data
          print('itemLookup[productId]! ${itemLookup[productId]!}');
          salesMap.addAll(itemLookup[productId]!);

          print('salesMap $salesMap');

          valuesList.add(SalesEntryViewModel.fromMap(salesMap));
        }
      });
      return valuesList;
    } catch (e) {
      print('sales error: $e');
    }
    return [];
  }

  Future<void> addNewSales({
    required SalesTableModel sales,
    required ItemsTableModel item,
    required String docId,
    required String shopId,
  }) async {
    String value = await _viewDateController.getViewDateForUi();

    DocumentReference salesDocRef = FirebaseFirestore.instance
        .collection(salesCollection)
        .doc(shopId)
        .collection(dateSubCollection)
        .doc(docId);

    DocumentReference salesCumulativeDocRef = FirebaseFirestore.instance
        .collection(salesCollection)
        .doc(shopId)
        .collection(salesCumulativeSubCollection)
        .doc(docId);

    DocumentReference itemsDocRef = FirebaseFirestore.instance
        .collection(itemsCollection)
        .doc(shopId)
        .collection(dateSubCollection)
        .doc(docId);

    Map<String, dynamic> salesDataMap = createSalesDataMap(sales);
    Map<String, dynamic> itemsMap = createItemsDataMapForFirebase(item);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(salesDocRef, salesDataMap, SetOptions(merge: true));
      transaction.set(itemsDocRef, itemsMap, SetOptions(merge: true));
    });

    DocumentSnapshot snapshot = await salesDocRef.get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;

      if (data['productId'] == sales.productId) {
        List<SalesViewModel> data = await getSalesDoc(value, shopId);
        SalesCumulativeModel salesCumulative = await calculateSalesCumulative(
          data,
        );

        await salesCumulativeDocRef.set(
          salesCumulative.toMap(),
          SetOptions(merge: true),
        );
      } else {
        print('Product does not exist');
      }
    }
  }

  Map<String, dynamic> createSalesDataMap(SalesTableModel data) {
    Map<String, dynamic> itemsData = {};

    itemsData[data.productId.toString()] = data.toMap();

    return itemsData;
  }

  Map<String, dynamic> createItemsDataMapForFirebase(ItemsTableModel data) {
    Map<String, dynamic> itemsData = {};

    itemsData[data.productId.toString()] = data.toMap();

    return itemsData;
  }

  Future<SalesCumulativeModel> calculateSalesCumulative(
    List<SalesViewModel> salesData,
  ) async {
    //1000
    List<SalesViewModel> imfl1000 = salesData
        .where(
          (element) => element.size == '1000 ml' && element.group == "IMFL",
        )
        .toList();
    int total1000Bottles = imfl1000.fold(
      0,
      (sum, element) => sum + element.totalSalesRetailUnits,
    );

    debugPrint('imfl1000 $imfl1000');
    debugPrint('total1000Bottles $total1000Bottles');

    for (final val in imfl1000) {
      debugPrint(
        'imfl1000 val totalSalesRetailUnits ${val.totalSalesRetailUnits}',
      );
    }

    //750
    List<SalesViewModel> imfl750 = salesData
        .where((element) => element.size == '750 ml' && element.group == "IMFL")
        .toList();
    int total750Bottles = imfl750.fold(
      0,
      (sum, element) => sum + element.totalSalesRetailUnits,
    );

    debugPrint('imfl750 $imfl750');
    debugPrint('total750Bottles $total750Bottles');

    for (final val in imfl750) {
      debugPrint(
        'imfl750 val totalSalesRetailUnits ${val.totalSalesRetailUnits}',
      );
    }

    //375
    List<SalesViewModel> imfl375 = salesData
        .where((element) => element.size == '375 ml' && element.group == "IMFL")
        .toList();
    int total375Bottles = imfl375.fold(
      0,
      (sum, element) => sum + element.totalSalesRetailUnits,
    );

    debugPrint('imfl375 $imfl375');
    debugPrint('total375Bottles $total375Bottles');

    for (final val in imfl375) {
      debugPrint(
        'imfl375 val totalSalesRetailUnits ${val.totalSalesRetailUnits}',
      );
    }

    //180
    List<SalesViewModel> imfl180 = salesData
        .where((element) => element.size == '180 ml' && element.group == "IMFL")
        .toList();
    int total180Bottles = imfl180.fold(
      0,
      (sum, element) => sum + element.totalSalesRetailUnits,
    );

    debugPrint('imfl180 $imfl180');
    debugPrint('total180Bottles $total180Bottles');

    for (final val in imfl180) {
      debugPrint(
        'imfl180 val totalSalesRetailUnits ${val.totalSalesRetailUnits}',
      );
    }

    //650
    List<SalesViewModel> beer650 = salesData
        .where((element) => element.size == '650 ml' && element.group == "BEER")
        .toList();
    int total650Bottles = beer650.fold(
      0,
      (sum, element) => sum + element.totalSalesRetailUnits,
    );

    debugPrint('beer650 $beer650');
    debugPrint('total650Bottles $total650Bottles');

    for (final val in beer650) {
      debugPrint(
        'beer650 val totalSalesRetailUnits ${val.totalSalesRetailUnits}',
      );
    }

    //500 + 325
    List<SalesViewModel> beer500 = salesData
        .where(
          (element) =>
              (element.size == '500 ml' || element.size == '325 ml') &&
              element.group == "BEER",
        )
        .toList();
    int total500Bottles = beer500.fold(
      0,
      (sum, element) => sum + element.totalSalesRetailUnits,
    );

    debugPrint('beer500 $beer500');
    debugPrint('total500Bottles $total500Bottles');

    // sales cases
    int imflSalesCase =
        total180Bottles +
        (total375Bottles * 2) +
        (total750Bottles * 4) +
        (total1000Bottles * 5);

    debugPrint('imflSalesCase $imflSalesCase');

    int customRound(double number) {
      if (number - number.floor() < 0.5) {
        return number.floor();
      } else {
        return number.ceil();
      }
    }

    //round off value
    int imflCumulativeCases = customRound(imflSalesCase / 48);

    debugPrint('imflCumulativeCases $imflCumulativeCases');
    //beer cases
    int beerCumulativeCases = customRound(
      ((total650Bottles * 2) + total500Bottles) / 24,
    );

    debugPrint('beerCumulativeCases $beerCumulativeCases');

    //
    int totalCumulativeValue = 0;
    for (SalesViewModel data in salesData) {
      totalCumulativeValue += data.totalPriceSales;
    }

    // int totalCumulativeValue = salesData.fold(0,
    //     (previousValue, element) => previousValue + element.totalPrice);

    debugPrint('totalCumulativeValue $totalCumulativeValue');
    debugPrint('salesData.first.date ${salesData.first.date}');

    SalesCumulativeModel salesCumulativeModel = SalesCumulativeModel(
      date: salesData.first.date,
      imflCumulativeCases: imflCumulativeCases,
      beerCumulativeCases: beerCumulativeCases,
      totalCumulative: totalCumulativeValue,
      isSynced: 1,
    );
    debugPrint('salesCumulativeModel 333 $salesCumulativeModel');

    debugPrint('af sales cumulative update func');
    return salesCumulativeModel;
  }
}

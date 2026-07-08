import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/services/firestore_service.dart';
import 'package:stock_app_web/core/services/firestore_service_items.dart';
import 'package:stock_app_web/models/authentication_model.dart';
import 'package:stock_app_web/models/inward_table_model.dart';
import 'package:stock_app_web/models/items_table_model.dart';
import 'package:stock_app_web/models/pos_table_model.dart';
import 'package:stock_app_web/models/sales_table_model.dart';

class UserRepository {
  final _service = getIt<FirestoreService>();
  final _itemsService = getIt<FirestoreServiceItems>();

  static const collection = "authentication";
  static const userCollection = "users";
  static const officeCollection = "office";
  static const itemsCollection = "items";
  static const cumulativeCollection = "cumulative";
  static const settingsCollection = "settings";
  static const masterCollection = "master";
  static const inwardCollection = "inward";
  static const salesCollection = "sales";
  static const dateCollection = "date";
  static const posCollection = "pos";

  Future<AuthenticationModel?> checkUserPresent(String docId) async {
    final doc = await _service.getDocument(
      collection: collection,
      docId: docId,
    );

    if (!doc.exists) {
      return null;
    }

    final data = doc.data() as Map<String, dynamic>;

    return AuthenticationModel.fromJson(data);
  }

  Future<void> createAuthUser(Map<String, dynamic> user) async {
    await _service.add(
      collection: collection,
      docId: user['mobileNumber'],
      data: user,
    );
  }

  Future<void> createUser(Map<String, dynamic> user) async {
    await _service.add(
      collection: userCollection,
      docId: user['mobileNumber'],
      data: user,
    );
  }

  Future<void> createOffice(Map<String, dynamic> office) async {
    await _service.add(
      collection: officeCollection,
      docId: office['shopId'],
      data: office,
    );
  }

  Future<void> salesAdjustment(Map<String, dynamic> data) async {
    await _service.addSalesAdjustment(
      mainCollection: itemsCollection,
      mainDocId: data['shopId'],
      subCollection: cumulativeCollection,
      subDocId: cumulativeCollection,
      data: data,
    );
  }

  Future<void> createSettings(Map<String, dynamic> data) async {
    await _service.add(
      collection: settingsCollection,
      docId: data['shopId'],
      data: data,
    );
  }

  Future<void> createMaster(Map<String, dynamic> data) async {
    await _service.add(
      collection: masterCollection,
      docId: data['shopId'],
      data: data,
    );
  }

  Future<bool> createMastersBrands(String shopId, String brandFormat) async {
    bool isCompleted = await _service.createMastersDefaultBrands(
      shopId,
      brandFormat,
    );
    return isCompleted;
  }

  Future<void> createLastUpdateDates(
    String shopId,
    Map<String, dynamic> itemData,
    Map<String, dynamic> inwardData,
    Map<String, dynamic> salesData,
    Map<String, dynamic> posData,
  ) async {
    await _service.add(
      collection: itemsCollection,
      docId: shopId,
      data: itemData,
    );
    await _service.add(
      collection: inwardCollection,
      docId: shopId,
      data: inwardData,
    );
    await _service.add(
      collection: salesCollection,
      docId: shopId,
      data: salesData,
    );
    await _service.add(collection: posCollection, docId: shopId, data: posData);
  }

  Future<void> createSampleData(String shopId, String date) async {
    // ========== items data ===========
    String itemString = await rootBundle.loadString(
      "assets/sample_data/items_sample.json",
    );
    List itemJsonData = json.decode(itemString);
    List<ItemsTableModel> itemsModelData = itemJsonData.map((item) {
      ItemsTableModel model = ItemsTableModel.fromMap(item);
      return model;
    }).toList();
    Map<String, dynamic> itemsData = {};
    for (var item in itemsModelData) {
      itemsData[item.productId.toString()] = item.toMap();
    }

    // add items in firebase
    await _itemsService.addSampleDataFirestore(
      mainCollection: itemsCollection,
      mainDocId: shopId,
      subCollection: dateCollection,
      subDocId: date,
      data: itemsData,
    );

    // ========= sales data ===========
    List<SalesTableModel> salesModelData = [];
    for (final items in itemsModelData) {
      SalesTableModel salesModel = SalesTableModel(
        id: items.id,
        productId: items.productId,
        phoneNumber: items.phoneNumber,
        date: items.date,
        time: items.time,
        totalPriceSales: -1,
        totalSalesRetailUnits: -1,
        salesBundle: -1,
        salesRetail: -1,
        isSynced: 1,
      );
      salesModelData.add(salesModel);
    }
    Map<String, dynamic> salesData = {};
    for (var sales in salesModelData) {
      salesData[sales.productId.toString()] = sales.toMap();
    }

    // add sales in firebase
    await _itemsService.addSampleDataFirestore(
      mainCollection: salesCollection,
      mainDocId: shopId,
      subCollection: dateCollection,
      subDocId: date,
      data: salesData,
    );

    // ============ inward ============
    String inwardString = await rootBundle.loadString(
      "assets/sample_data/inward_sample.json",
    );
    List inwardDataJson = json.decode(inwardString);
    List<InwardTableModel> inwardModelData = inwardDataJson.map((item) {
      InwardTableModel model = InwardTableModel.fromMap(item);
      return model;
    }).toList();
    Map<String, dynamic> inwardData = {};
    for (var inward in inwardModelData) {
      inwardData['${inward.productId} ${inward.invoiceNo}'] = inward.toMap();
    }

    // add inward in firebase
    await _itemsService.addSampleDataFirestore(
      mainCollection: inwardCollection,
      mainDocId: shopId,
      subCollection: dateCollection,
      subDocId: date,
      data: inwardData,
    );

    // =========== pos ==============\
    String yesterday = DateTime.now()
        .subtract(Duration(days: 1))
        .toString()
        .substring(0, 10);

    PosTableModel posModelData = PosTableModel(
      id: 1,
      posValue: 150000,
      posDate: yesterday,
      posNumberOfBills: 0,
      posNumberOfBottles: 0,
      posImflSalesValue: 0,
      posBeerSalesValue: 0,
      posImflBottles: 0,
      posBeerBottles: 0,
      posCumulative: 150000,
      isSynced: 1,
      posShopCardPos: 0,
      posShopUpiPos: 0,
      posBarCardPos: 0,
      posBarUpiPos: 0,
    );
    Map<String, dynamic> posData = posModelData.toMap();

    // add pos in firebase
    await _itemsService.addSampleDataFirestore(
      mainCollection: posCollection,
      mainDocId: shopId,
      subCollection: dateCollection,
      subDocId: date,
      data: posData,
    );
  }
}

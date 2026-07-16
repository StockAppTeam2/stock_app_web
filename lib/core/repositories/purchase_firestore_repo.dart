import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/brand_firestore_repo.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';
import 'package:stock_app_web/core/repositories/opening_firestore_repo.dart';
import 'package:stock_app_web/core/services/firestore_service.dart';
import 'package:stock_app_web/models/brand_model.dart';
import 'package:stock_app_web/models/inward_table_model.dart';
import 'package:stock_app_web/models/items_table_model.dart';

class PurchaseFirestoreRepo {
  final firestoreService = getIt<FirestoreService>();
  final brandFirestoreRepo = getIt<BrandFirestoreRepo>();
  final cacheRepository = getIt<CacheRepository>();
  final openingFireRepo = getIt<OpeningFirestoreRepo>();

  static const inwardCollection = "inward";
  static const itemsCollection = "items";
  static const dateSubCollection = "date";

  Future<List<InwardViewModel>> getInwardDoc(String date, String shopId) async {
    try {
      List<InwardViewModel> valuesList = [];

      DocumentSnapshot documentSnapshot = await firestoreService
          .getSubCollectionDocument(
            collection: inwardCollection,
            shopId: shopId,
            subCollection: dateSubCollection,
            docId: date,
          );

      if (!documentSnapshot.exists) return [];

      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      if (data.isEmpty) return [];

      List<BrandModel> brandData = await brandFirestoreRepo.getBrandCollection(
        shopId,
      );
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
        inwardMap['date'] = value['date'];
        valuesList.add(InwardViewModel.fromMap(inwardMap));
      });

      return valuesList;
    } catch (e) {
      print('receipt error $e');
    }
    return [];
  }

  Future<void> addNewReceipt({
    required InwardTableModel inward,
    required ItemsTableModel item,
    required String docId,
    required String shopId,
  }) async {
    DocumentReference itemReference = FirebaseFirestore.instance
        .collection(itemsCollection)
        .doc(shopId)
        .collection(dateSubCollection)
        .doc(docId);

    DocumentReference inwardReference = FirebaseFirestore.instance
        .collection(inwardCollection)
        .doc(shopId)
        .collection(dateSubCollection)
        .doc(docId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      print('transaction called');
      Map<String, dynamic> inwardData = createInwardDataMap(inward);
      Map<String, dynamic> itemData = createItemsDataMap(item);
      transaction.set(inwardReference, inwardData, SetOptions(merge: true));
      transaction.set(itemReference, itemData, SetOptions(merge: true));
    });
  }

  Future<void> deleteReceipt({
    required InwardViewModel inward,
    required ItemsTableModel item,
    required String docId,
    required String shopId,
  }) async {
    DocumentReference itemReference = FirebaseFirestore.instance
        .collection(itemsCollection)
        .doc(shopId)
        .collection(dateSubCollection)
        .doc(docId);

    DocumentReference inwardReference = FirebaseFirestore.instance
        .collection(inwardCollection)
        .doc(shopId)
        .collection(dateSubCollection)
        .doc(docId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      print('transaction called');
      Map<String, dynamic> itemData = createItemsDataMap(item);
      transaction.set(itemReference, itemData, SetOptions(merge: true));

      transaction.set(inwardReference, {
        '${inward.productId.toString()} ${inward.invoiceNo}':
            FieldValue.delete(),
      }, SetOptions(merge: true));
    });
  }

  Map<String, dynamic> createInwardDataMap(InwardTableModel data) {
    Map<String, dynamic> inwardData = {};

    inwardData['${data.productId.toString()} ${data.invoiceNo}'] = data.toMap();

    return inwardData;
  }

  Map<String, dynamic> createItemsDataMap(ItemsTableModel data) {
    Map<String, dynamic> itemsData = {};

    itemsData[data.productId.toString()] = data.toMap();

    return itemsData;
  }

  Future<bool> checkProductExist({
    required String docId,
    required String shopId,
    required String productId,
  }) async {
    DocumentSnapshot inwardDoc = await FirebaseFirestore.instance
        .collection(inwardCollection)
        .doc(shopId)
        .collection(dateSubCollection)
        .doc(docId)
        .get();

    if (!inwardDoc.exists) return false;
    Map<String, dynamic> data = inwardDoc.data() as Map<String, dynamic>;
    if (data.isEmpty) return false;

    bool isProductExist = false;

    data.forEach((k, v) {
      String product = v['productId'].toString();
      if (product == productId) {
        isProductExist = true;
      }
    });
    return isProductExist;
  }

  Future<String> checkTodayExistingInvoiceNumber({
    required String docId,
    required String shopId,
  }) async {
    DocumentSnapshot inwardDoc = await FirebaseFirestore.instance
        .collection(inwardCollection)
        .doc(shopId)
        .collection(dateSubCollection)
        .doc(docId)
        .get();

    if (!inwardDoc.exists) return '';
    Map<String, dynamic> data = inwardDoc.data() as Map<String, dynamic>;
    if (data.isEmpty) return '';

    final firstEntry = data.entries.first;
    String invoiceNumber = firstEntry.value['invoiceNo'] ?? '';
    print(invoiceNumber);

    return invoiceNumber;
  }

  Future<List<InwardDailyFolderModel>> loadFirstPageViewDate({
    String? lastDate,
    int limit = 10,
    required String shopId,
  }) async {
    List<InwardDailyFolderModel> result = [];

    final snapshot = await firestoreService.getPaginatedDataUsingLastDateInward(
      collection: 'inward',
      subCollection: 'date',
      shopId: shopId,
      lastDate: lastDate,
      limit: limit,
    );

    List<BrandModel> brandData = await brandFirestoreRepo.getBrandCollection(
      shopId,
    );
    for (final doc in snapshot.docs) {
      int imflTotal = 0;
      int beerTotal = 0;
      int total = 0;
      String invoiceNo = "";
      List<InwardViewModel> valuesList = [];

      if (!doc.exists) return [];

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data.isEmpty) return [];

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
        inwardMap['date'] = value['date'];
        inwardMap['id'] = value['id'];
        valuesList.add(InwardViewModel.fromMap(inwardMap));
      });

      if (valuesList.isNotEmpty) {
        for (final item in valuesList) {
          total += item.totalPriceInward;
          print('price: ${item.totalPriceInward}');

          if (item.inwardGroup == "IMFL") {
            imflTotal += item.totalPriceInward;
          } else if (item.inwardGroup == "BEER") {
            beerTotal += item.totalPriceInward;
          }
          invoiceNo = item.invoiceNo;
        }
        print(' total $total imflTotal $imflTotal beerTotal $beerTotal');

        result.add(
          InwardDailyFolderModel(
            invoiceNo: invoiceNo,
            date: doc.id,
            imfTotalPrice: imflTotal,
            beerTotalPrice: beerTotal,
            imflAndBeerTotal: total,
          ),
        );
      }
    }

    return result;
  }

  Future<List<InwardDailyFolderModel>> getInwardDailyDetails({
    required String shopId,
    required String month,
  }) async {
    final parts = month.split('-');
    final year = int.parse(parts[0]);
    final monthNumber = int.parse(parts[1]);

    final firstDate = DateTime(year, monthNumber, 1);
    final lastDate = DateTime(year, monthNumber + 1, 0);

    List<InwardDailyFolderModel> result = [];

    for (
      DateTime date = firstDate;
      !date.isAfter(lastDate);
      date = date.add(const Duration(days: 1))
    ) {
      String docId =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      print('docId: $docId');

      int imflTotal = 0;
      int beerTotal = 0;
      int total = 0;
      String invoiceNo = "";

      List<InwardViewModel> inward = await getInwardDoc(docId, shopId);
      if (inward.isNotEmpty) {
        for (final item in inward) {
          total += item.totalPriceInward;
          print('price: ${item.totalPriceInward}');

          if (item.inwardGroup == "IMFL") {
            imflTotal += item.totalPriceInward;
          } else if (item.inwardGroup == "BEER") {
            beerTotal += item.totalPriceInward;
          }
        }
        print(' total $total imflTotal $imflTotal beerTotal $beerTotal');
        result.add(
          InwardDailyFolderModel(
            invoiceNo: invoiceNo,
            date: docId,
            imfTotalPrice: imflTotal,
            beerTotalPrice: beerTotal,
            imflAndBeerTotal: total,
          ),
        );
      }
    }

    return result;
  }

  Future<bool> enableEdit({
    required String shopId,
    required String date,
  }) async {
    DocumentSnapshot documentSnapshot = await firestoreService
        .getSubCollectionDocument(
          collection: itemsCollection,
          shopId: shopId,
          subCollection: dateSubCollection,
          docId: date,
        );

    if (documentSnapshot.exists) {
      final Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      if (data.isNotEmpty) {
        final Map<String, dynamic> firstItem =
            data.values.first as Map<String, dynamic>;

        final int closingBundle = firstItem['closingBundle'] ?? -1;
        final int closingRetail = firstItem['closingRetail'] ?? -1;

        if (closingBundle == -1 || closingRetail == -1) {
          print('First item not has closing value.');
          return true;
        } else {
          print('First item has closing value');
          return false;
        }
      }
    }
    return false;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/brand_firestore_repo.dart';
import 'package:stock_app_web/core/repositories/firestore_repo.dart';
import 'package:stock_app_web/models/brand_model.dart';
import 'package:stock_app_web/models/return_model.dart';

class ReturnStockController {
  final _fireRepo = getIt<FirestoreRepo>();
  final _brandFirestoreRepo = getIt<BrandFirestoreRepo>();

  Future<List<ReturnViewModel>> getAllReturnStock(
    String shopId,
    String date,
  ) async {
    List<ReturnViewModel> valuesList = [];

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('return_stock')
        .doc(shopId)
        .collection('date')
        .doc(date)
        .get();

    if (!documentSnapshot.exists) return [];

    Map<String, dynamic> maps = documentSnapshot.data() as Map<String, dynamic>;
    if (maps.isEmpty) return [];

    print('returnStock map $maps, date $date');

    List<BrandModel> brandData = await _brandFirestoreRepo.getBrandCollection(
      shopId,
    );

    try {
      maps.forEach((key, value) {
        Map<String, dynamic> returnMap = Map<String, dynamic>.from(value);

        // Find matching brand
        BrandModel? brand;
        try {
          brand = brandData.firstWhere(
            (e) => e.productId == returnMap['productId'],
          );
        } catch (_) {
          brand = null;
        }

        // Merge Brand + Item
        if (brand != null) {
          returnMap.addAll(brand.toMap());
        }

        valuesList.add(ReturnViewModel.fromMap(returnMap));
      });
    } catch (e) {
      print('error: $e');
    }

    return valuesList;
  }

  Future<void> addReturnStock(ReturnModel returnModel) async {
    String shopId = await getIt<ShopIdController>().getShopId();

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('return_stock')
        .doc(shopId)
        .collection('date')
        .doc(returnModel.date);

    Map<String, dynamic> data = createReturnMapForFirebase(returnModel);

    await documentReference.set({data}, SetOptions(merge: true));
  }

  Map<String, dynamic> createReturnMapForFirebase(ReturnModel data) {
    Map<String, dynamic> itemsData = {};

    itemsData[data.productId.toString()] = data.toMap();

    return itemsData;
  }

  Future<void> deleteReturn(String productId, String date) async {
    String shopId = await getIt<ShopIdController>().getShopId();
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('return_stock')
        .doc(shopId)
        .collection('date')
        .doc(date);

    await documentReference.set({
      productId: FieldValue.delete(),
    }, SetOptions(merge: true));
  }
}

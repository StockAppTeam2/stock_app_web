import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_app_web/models/indent_plan_model.dart';

class IndentController {
  Future<List<IndentPlanModel>> getIndentData(
    String date,
    String shopId,
  ) async {
    final firestore = FirebaseFirestore.instance;

    final results = await Future.wait([
      firestore
          .collection('sales')
          .doc(shopId)
          .collection('date')
          .doc(date)
          .get(),

      firestore
          .collection('items')
          .doc(shopId)
          .collection('date')
          .doc(date)
          .get(),

      firestore
          .collection('web_cache')
          .doc(shopId)
          .collection('brand')
          .doc('brand')
          .get(),
    ]);

    final salesSnapshot = results[0];
    final itemsSnapshot = results[1];
    final brandSnapshot = results[2];

    if (!salesSnapshot.exists ||
        !itemsSnapshot.exists ||
        !brandSnapshot.exists) {
      return [];
    }

    final Map<String, dynamic> salesMap =
        salesSnapshot.data() as Map<String, dynamic>;

    final Map<String, dynamic> itemsMap =
        itemsSnapshot.data() as Map<String, dynamic>;

    final Map<String, dynamic> brandMap =
        brandSnapshot.data() as Map<String, dynamic>;

    final List<IndentPlanModel> result = [];

    for (final entry in salesMap.entries) {
      final saleData = entry.value as Map<String, dynamic>;
      print('saleData: $saleData');

      String productId = saleData['productId'].toString();
      print('productId: $productId');

      final brand = brandMap[productId];
      print('brand: $brand');
      final item = itemsMap[productId];
      print('item: $item');

      if (brand == null || item == null) continue;

      final brandData = brand as Map<String, dynamic>;
      print('brandData: $brandData');
      final itemData = item as Map<String, dynamic>;
      print('itemData: $itemData');

      if ((itemData['totalActualRetailUnits'] ?? 0) <= 0) {
        continue;
      }

      result.add(
        IndentPlanModel.fromMap({
          'brand_brand': brandData['brand'],
          'brand_range': brandData['range'],
          'brand_size': brandData['size'],
          'brand_price': brandData['price'],
          'brand_groups': brandData['groups'],
          'brand_category': brandData['category'],

          'sales_id': int.parse(entry.key),
          'sales_productId': saleData['productId'],
          'sales_totalPriceSales': saleData['totalPriceSales'],
          'sales_totalSalesRetailUnits': saleData['totalSalesRetailUnits'],

          'items_totalActualRetailUnits': itemData['totalActualRetailUnits'],
          'items_totalCloseRetailUnits': itemData['totalCloseRetailUnits'],
        }),
      );
    }

    result.sort((a, b) {
      int groupOrder(String g) {
        switch (g) {
          case 'IMFL':
            return 1;
          case 'BEER':
            return 2;
          default:
            return 3;
        }
      }

      int rangeOrder(String r) {
        switch (r) {
          case 'ORDINARY':
            return 1;
          case 'MEDIUM':
            return 2;
          case 'PREMIUM':
            return 3;
          default:
            return 4;
        }
      }

      int categoryOrder(String c) {
        switch (c) {
          case 'BRANDY':
            return 1;
          case 'WHISKY':
            return 2;
          case 'RUM':
            return 3;
          case 'GIN':
            return 4;
          case 'VODKA':
            return 5;
          case 'WINE':
            return 6;
          case 'BEER':
            return 7;
          default:
            return 8;
        }
      }

      int compare = groupOrder(
        a.brandGroups,
      ).compareTo(groupOrder(b.brandGroups));

      if (compare != 0) return compare;

      compare = rangeOrder(a.range).compareTo(rangeOrder(b.range));

      if (compare != 0) return compare;

      compare = categoryOrder(
        a.brandCategory,
      ).compareTo(categoryOrder(b.brandCategory));

      if (compare != 0) return compare;

      return a.productId.compareTo(b.productId);
    });

    return result;
  }
}

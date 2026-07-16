import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';

class PreviousDayCumulativeController {
  Future<List<dynamic>> getAdjustmentValues() async {
    String shopId = await getIt<ShopIdController>().getShopId();

    DocumentSnapshot getAdjustmentValue = await FirebaseFirestore.instance
        .collection('items')
        .doc(shopId)
        .collection('cumulative')
        .doc('cumulative')
        .get();

    Map<String, dynamic> adjustData =
        getAdjustmentValue.data() as Map<String, dynamic>;

    final salesCumulative = (adjustData['salesAdjustment'] ?? 0).toString();
    final imflSalesCumulativeCase =
        (adjustData['imflSalesCumulativeCaseAdjustment'] ?? 0).toString();
    final beerSalesCumulativeCase =
        (adjustData['beerSalesCumulativeCaseAdjustment'] ?? 0).toString();
    final firstOpDate = (adjustData['firstOpDate'] ?? '').toString();
    final opValue = (adjustData['openingAdjustment'] ?? 0).toString();
    final receiptCumulative = (adjustData['receiptAdjustment'] ?? 0).toString();
    final cbValue = (adjustData['closingAdjustment'] ?? 0).toString();
    final lastDateOfMonth = adjustData['lastDateOfMonth'] ?? '';

    return [
      firstOpDate,
      opValue,
      salesCumulative,
      imflSalesCumulativeCase,
      beerSalesCumulativeCase,
      receiptCumulative,
      cbValue,
      lastDateOfMonth,
    ];
  }

  Future<void> createAdjustmentValues(
    firstOpDate,
    opValue,
    salesCumulative,
    receiptCumulative,
    cbValue,
    imflCase,
    beerCase,
  ) async {
    String shopId = await getIt<ShopIdController>().getShopId();

    DocumentReference getAdjustmentValue = FirebaseFirestore.instance
        .collection('items')
        .doc(shopId)
        .collection('cumulative')
        .doc('cumulative');

    getAdjustmentValue.set({
      'salesAdjustment': int.parse(salesCumulative),
      'imflSalesCumulativeCaseAdjustment': int.parse(imflCase),
      'beerSalesCumulativeCaseAdjustment': int.parse(beerCase),
      'firstOpDate': firstOpDate,
      'openingAdjustment': int.parse(opValue),
      'receiptAdjustment': int.parse(receiptCumulative),
      'closingAdjustment': int.parse(cbValue),
    }, SetOptions(merge: true));
  }
}

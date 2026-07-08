import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_app_web/models/previous_year_sales_cumulative.dart';

class PreviousYearSalesCumulativeController {
  Future<PreviousYearSalesCumulativeModel?>
  readPreviousYearSalesCumulativeUsingDate(String shopId, String date) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('sales')
        .doc(shopId)
        .collection('PreviousYearSalesCumulative')
        .doc(date)
        .get();
    if (!documentSnapshot.exists) return null;
    Map<String, dynamic> map = documentSnapshot.data() as Map<String, dynamic>;

    if (map.isNotEmpty) {
      return PreviousYearSalesCumulativeModel.fromMap(map);
    } else {
      return null;
    }
  }
}

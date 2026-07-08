import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/firestore_repo.dart';
import 'package:stock_app_web/models/sales_table_model.dart';

class SalesPageController {
  final _fireRepo = getIt<FirestoreRepo>();

  Future<List<SalesViewModel>> getSalesData(String date, String shopId) async {
    List<SalesViewModel> data = await _fireRepo.getSalesDoc(date, shopId);
    return data;
  }
}

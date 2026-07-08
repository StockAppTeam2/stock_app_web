import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/firestore_repo.dart';
import 'package:stock_app_web/models/items_table_model.dart';

class PvReportController {
  final _fireRepo = getIt<FirestoreRepo>();

  Future<List<ItemsViewModel>> getOpeningData(
    String date,
    String shopId,
  ) async {
    List<ItemsViewModel> data = await _fireRepo.getOpeningDoc(date, shopId);
    return data;
  }
}

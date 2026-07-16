import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/firestore_repo.dart';
import 'package:stock_app_web/core/repositories/opening_firestore_repo.dart';
import 'package:stock_app_web/models/items_table_model.dart';

class PvReportController {
  final _fireRepo = getIt<FirestoreRepo>();
  final _openingFirestoreRepo = getIt<OpeningFirestoreRepo>();

  Future<List<ItemsViewModel>> getOpeningData(
    String date,
    String shopId,
  ) async {
    List<ItemsViewModel> data = await _openingFirestoreRepo.getOpeningDoc(
      date,
      shopId,
    );
    return data;
  }
}

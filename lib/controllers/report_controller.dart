import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/firestore_repo.dart';

class ReportController {
  final _fireRepo = getIt<FirestoreRepo>();

  Future<Map<String, dynamic>> getReportsData({
    required String shopId,
    required String docId,
  }) async {
    Map<String, dynamic> data = await _fireRepo.getReportsData(
      shopId: shopId,
      docId: docId,
    );
    return data;
  }
}

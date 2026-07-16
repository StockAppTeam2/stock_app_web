import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/opening_firestore_repo.dart';

class HomePageController {
  final _openingFireRepo = getIt<OpeningFirestoreRepo>();

  Future<bool> checkFirstOpening() async {
    return await _openingFireRepo.checkFirstOpening();
  }
}

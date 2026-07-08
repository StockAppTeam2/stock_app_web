import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/user_repository.dart';

class ShopCreationController {
  final _userRepo = getIt<UserRepository>();

  Future<void> createShop() async {}
}

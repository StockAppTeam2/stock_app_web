import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionRepo {
  Future<bool> checkInternetConnection() async {
    Connectivity connectivity = Connectivity();
    List<ConnectivityResult> result = await connectivity.checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      return false;
    }
    return await InternetConnection().hasInternetAccess;
  }
}

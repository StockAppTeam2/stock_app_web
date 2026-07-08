import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkHelper {
  static Future<bool> hasInternet() async {
    final hasInternet = await InternetConnection().hasInternetAccess;
    return hasInternet;
  }
}

// if (!await NetworkHelper.hasInternet()) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(
//       content: Text('No Internet Connection'),
//     ),
//   );
//   return;
// }

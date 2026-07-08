import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/firebase_options.dart';
import 'package:stock_app_web/stock_app_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await setupLocator();

  usePathUrlStrategy();

  runApp(const StockAppWeb());
}

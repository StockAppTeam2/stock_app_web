import 'package:flutter/material.dart';
import 'package:stock_app_web/core/routes/app_router.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/widgets/global_internet_wrapper.dart';
import 'package:stock_app_web/pages/home/home_page.dart';
import 'package:stock_app_web/pages/login/login_page.dart';
import 'package:stock_app_web/pages/opening/opening_stock_page.dart';

class StockAppWeb extends StatelessWidget {
  const StockAppWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      builder: (context, child) {
        return GlobalInternetWrapper(child: child ?? const SizedBox());
      },
    );
  }
}

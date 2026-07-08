import 'package:flutter/material.dart';
import 'package:stock_app_web/core/utils/responsive.dart';
import 'package:stock_app_web/core/widgets/app_drawer.dart';
import 'package:stock_app_web/core/widgets/app_sidebar.dart';

class AppNavigatorWrapper extends StatelessWidget {
  final Widget child;

  const AppNavigatorWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Responsive.isDesktop(context) ? null : const AppDrawer(),
      body: Row(
        children: [
          if (Responsive.isDesktop(context)) const AppSidebar(),

          Expanded(
            child: Padding(padding: const EdgeInsets.all(8.0), child: child),
          ),
        ],
      ),
    );
  }
}

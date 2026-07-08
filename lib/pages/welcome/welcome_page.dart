import 'package:flutter/material.dart';
import 'package:stock_app_web/core/constants/app_assets.dart';
import 'package:stock_app_web/core/constants/app_constants.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/utils/responsive.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Responsive.isDesktop(context)
            ? _desktopView(context)
            : _mobileView(context),
      ),
    );
  }

  Column _welcome(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/welcome.jpg'),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              // Navigator.pushReplacementNamed(context, AppRoutes.shopCreation);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.login, size: 20),
                SizedBox(width: 8),
                Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _desktopView(BuildContext context) {
    return Row(
      children: [
        /// LEFT SIDE
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.blue,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset(AppAssets.appIcon),
                  ),

                  SizedBox(height: 20),

                  Text(
                    AppConstants.appName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Manage your business anywhere",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),

        /// RIGHT SIDE LOGIN
        Expanded(
          flex: 5,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: 450,
                padding: const EdgeInsets.all(40),
                child: _welcome(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _mobileView(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: Responsive.loginWidth(context),
          child: _welcome(context),
        ),
      ),
    );
  }
}

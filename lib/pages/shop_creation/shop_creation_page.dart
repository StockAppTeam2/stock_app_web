import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_app_web/controllers/login_page_controller.dart';
import 'package:stock_app_web/core/constants/app_assets.dart';
import 'package:stock_app_web/core/constants/app_constants.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/utils/dialog_helper.dart';
import 'package:stock_app_web/core/utils/network_helper.dart';
import 'package:stock_app_web/core/utils/responsive.dart';

class ShopCreationPage extends StatefulWidget {
  const ShopCreationPage({super.key});

  @override
  State<ShopCreationPage> createState() => _ShopCreationPageState();
}

class _ShopCreationPageState extends State<ShopCreationPage> {
  final loginPageController = getIt<LoginPageController>();
  final _cache = getIt<CacheRepository>();

  final _formKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();
  final shopNumberController = TextEditingController();
  final placeController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    mobileController.dispose();
    shopNumberController.dispose();
    placeController.dispose();
    super.dispose();
  }

  Future<void> createShop(BuildContext context) async {
    try {
      if (!await NetworkHelper.hasInternet()) {
        if (!context.mounted) return;
        DialogHelper.showNoInternetDialog(context);
        return;
      }

      if (!_formKey.currentState!.validate()) {
        return;
      }
      setState(() {
        loading = true;
      });

      String mobile = "+91${mobileController.text}";
      String shopNumber = shopNumberController.text;
      String place = placeController.text;

      // check user exist
      final result = await loginPageController.verifyUser(mobile);
      if (result) {
        if (!context.mounted) return;
        DialogHelper.showError(context, 'User already exist, Please login');
        setState(() {
          loading = false;
        });
        return;
      }

      String currentDate = DateTime.now().toString().substring(0, 10);
      await _cache.addStringCacheLocalAndFirebase('viewDateUi', currentDate);
      await _cache.addStringCacheLocalAndFirebase('shopId', shopNumber);
      await _cache.addStringCacheLocalAndFirebase('mobile_number', shopNumber);
      await loginPageController.addNewUser(mobile, shopNumber, place);
      setState(() {
        loading = false;
      });

      if (!context.mounted) return;
      context.go('/$shopNumber/${AppRoutes.home}');
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      if (!context.mounted) return;
      DialogHelper.showError(context, 'Something went wrong.\n$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive.isDesktop(context)
          ? _desktopView()
          : _mobileView(context),
    );
  }

  Widget _desktopView() {
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
                child: _loginCard(),
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
          child: _loginCard(),
        ),
      ),
    );
  }

  Widget _loginCard() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Shop Creation",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: mobileController,
              maxLength: 10,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter mobile number';
                }

                if (value.length != 10) {
                  return 'Enter valid mobile number';
                }

                return null;
              },
              decoration: InputDecoration(
                labelText: "Mobile Number",
                prefixIcon: const Icon(Icons.phone),
                prefixText: '+91 ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: shopNumberController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Shop Number';
                }

                return null;
              },
              decoration: InputDecoration(
                labelText: "Shop Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),

            TextFormField(
              controller: placeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Place';
                }

                return null;
              },
              decoration: InputDecoration(
                labelText: "Enter Place",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        await createShop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  loading ? "CREATING..." : "SUBMIT",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

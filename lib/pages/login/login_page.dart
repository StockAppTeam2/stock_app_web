import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_app_web/controllers/login_page_controller.dart';
import 'package:stock_app_web/core/constants/app_assets.dart';
import 'package:stock_app_web/core/constants/app_constants.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/utils/dialog_helper.dart';
import 'package:stock_app_web/core/utils/network_helper.dart';
import 'package:stock_app_web/core/utils/responsive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginPageController loginPageController = getIt<LoginPageController>();

  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool hidePassword = true;
  bool authenticating = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login(BuildContext context) async {
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
        authenticating = true;
      });

      String mobile = "+91${mobileController.text}";
      String password = passwordController.text;

      // check user exist
      final result = await loginPageController.login(mobile, password);

      switch (result) {
        case LoginStatus.success:
          print('Login Success');
          if (!context.mounted) return;
          // Navigator.pushReplacementNamed(context, AppRoutes.home);
          break;
        case LoginStatus.userNotFound:
          print('User Not Found');
          setState(() {
            authenticating = false;
          });
          DialogHelper.showError(context, 'User not found');
          break;
        case LoginStatus.invalidPassword:
          print('Invalid Password');
          setState(() {
            authenticating = false;
          });
          DialogHelper.showError(context, 'Invalid password');
          break;
      }
    } catch (e) {
      if (!context.mounted) return;
      DialogHelper.showError(context, 'Something went wrong.\n$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: SafeArea(
        child: Responsive.isDesktop(context)
            ? _desktopView()
            : _mobileView(context),
      ),
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
              "Login",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

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
              controller: passwordController,
              obscureText: hidePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter password';
                }

                if (value.length < 6) {
                  return 'Minimum 6 characters';
                }

                return null;
              },
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  icon: Icon(
                    hidePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: authenticating
                    ? null
                    : () async {
                        await login(context);
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
                      authenticating ? 'VERIFYING...' : 'LOGIN',
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

            const SizedBox(height: 20),

            Text('புதிய பயனாளராக இருந்தால் கீழே உள்ள பட்டனை கிளிக் செய்யவும்'),

            SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () {
                // Navigator.pushReplacementNamed(context, AppRoutes.welcome);
              },
              icon: const Icon(Icons.storefront_outlined),
              label: const Text(
                'New Shop',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(180, 50),
                backgroundColor: const Color(0xFF16A34A),
                foregroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 20),

            Wrap(
              children: [
                TextButton.icon(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(
                    Icons.play_circle_fill_rounded,
                    size: 30,
                    color: Colors.red,
                  ),
                  label: const Text(
                    "Installation Video",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),

                OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2563EB),
                    side: const BorderSide(
                      color: Color(0xFF2563EB),
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.support_agent_rounded, size: 28),
                  label: const Text(
                    "Support",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

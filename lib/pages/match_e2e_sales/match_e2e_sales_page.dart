import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_app_web/controllers/match_e2e_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/Internet_connection_repo.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class MatchE2eSalesPage extends StatefulWidget {
  const MatchE2eSalesPage({super.key});

  @override
  State<MatchE2eSalesPage> createState() => _MatchE2eSalesPageState();
}

class _MatchE2eSalesPageState extends State<MatchE2eSalesPage> {
  final _internetConnectionRepo = getIt<InternetConnectionRepo>();
  final _matchE2eController = getIt<MatchE2eController>();

  bool enterSales = false;

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Column(
        children: [
          RadioListTile<bool>(
            title: const Text('Enter Sales'),
            value: true,
            groupValue: enterSales,
            onChanged: (value) {
              print('enterSales $enterSales');
              setState(() {
                enterSales = value!;
              });
            },
          ),
          RadioListTile<bool>(
            title: const Text('Enter CB'),
            value: false,
            groupValue: enterSales,
            onChanged: (value) {
              print('enterSales $enterSales');
              setState(() {
                enterSales = value!;
              });
            },
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () async {
              bool isConnected = await _internetConnectionRepo
                  .checkInternetConnection();
              if (isConnected) {
                bool checkClosingCount = await _matchE2eController
                    .allowChangeTheEntryType();

                if (checkClosingCount == false) {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          content: const Text(
                            "Today’s Sales or CB has already started."
                            "User not allowed to change this setting.",
                            style: TextStyle(fontSize: 20),
                          ),
                          actionsPadding: const EdgeInsets.only(
                            right: 16,
                            bottom: 12,
                          ),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  //A new Sales Entry option is now available.
                  String shopId = await getIt<ShopIdController>().getShopId();
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  await pref.setBool('EnterSales', enterSales);
                  DocumentReference salesOrCb = FirebaseFirestore.instance
                      .collection('items')
                      .doc(shopId);
                  await salesOrCb.set({
                    'EnterSales': enterSales,
                  }, SetOptions(merge: true));
                  //today sales or cb started user not allowed for change this settings
                  Fluttertoast.showToast(
                    msg: enterSales
                        ? 'Sales Entry Option Enabled'
                        : 'Closing Entry Option Enabled',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );

                  await Future.delayed(const Duration(milliseconds: 10));

                  if (!context.mounted) return;
                  context.go('/$shopId/${AppRoutes.home}');
                }
              } else {
                showErrorToast('No Internet Connection');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

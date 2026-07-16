import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/services/firestore_service.dart';

void logOutPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: EdgeInsets.only(top: 0, bottom: 0)),
            Icon(Icons.logout, color: Colors.grey, size: 70),
            SizedBox(height: 10),
            Text(
              'Are you sure, Do you want to logout.',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              final firestoreService = getIt<FirestoreService>();
              final shopIdController = getIt<ShopIdController>();
              String shopId = await shopIdController.getShopId();
              await firestoreService.add(
                collection: 'web_cache',
                docId: shopId,
                data: {'is_logged_in': false},
              );

              await shopIdController.setShopId('');

              await Future.delayed(Duration(milliseconds: 500));
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}

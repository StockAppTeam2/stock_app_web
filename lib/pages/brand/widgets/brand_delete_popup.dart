import 'package:flutter/material.dart';
import 'package:stock_app_web/controllers/brand_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';

Future<bool> showDeleteDialog(BuildContext context, String productId) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
            contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

            title: Row(
              children: const [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 32),
                SizedBox(width: 12),
                Text(
                  'Delete Brand',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            content: const Text(
              'Are you sure you want to delete this brand?\n\n'
              'This action cannot be undone.',
              style: TextStyle(fontSize: 16),
            ),

            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                icon: const Icon(Icons.close),
                label: const Text('Cancel'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
              ),

              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
                onPressed: () async {
                  final brandController = getIt<BrandController>();

                  await brandController.deleteBrand(productId);

                  if (context.mounted) {
                    Navigator.pop(context, true);
                  }
                },
                icon: const Icon(Icons.delete_forever),
                label: const Text('Delete'),
              ),
            ],
          );
        },
      ) ??
      false;
}

// Future<bool> showPopupDelete(BuildContext context, String productId) async {
//   final result = await showDialog<bool>(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Do you want to Delete?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context, false);
//             },
//             child: const Text('No'),
//           ),
//           TextButton(
//             onPressed: () async {
//               final brandController = getIt<BrandController>();
//               await brandController.deleteBrand(productId);
//
//               if (context.mounted) {
//                 Navigator.pop(context, true);
//               }
//             },
//             child: const Text('Yes'),
//           ),
//         ],
//       );
//     },
//   );
//
//   return result ?? false;
// }

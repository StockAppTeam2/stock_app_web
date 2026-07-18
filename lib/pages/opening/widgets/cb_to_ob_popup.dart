import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:stock_app_web/controllers/opening_page_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/Internet_connection_repo.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

Future<bool?> cbToObPopup(
  BuildContext context,
  List<String> targetDates,
  String lastDataExistDate,
) {
  final internetConnectionRepo = getIt<InternetConnectionRepo>();
  final openingController = getIt<OpeningPageController>();
  final cache = getIt<CacheRepository>();

  bool isProcessStart = false;
  int? selectedIndex;
  String refreshButtonCheckBoxDate = '';

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420, maxHeight: 420),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: isProcessStart
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                            "assets/animation/sand_clock_animation.json",
                            width: 120,
                            height: 120,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Processing...",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Consider my Last Day Closing Stock is Selected Date opening Stock",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          const Text(
                            "Select a date:",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),

                          const SizedBox(height: 8),

                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: targetDates.length,
                              itemBuilder: (context, index) {
                                final date = targetDates[index];

                                return RadioListTile<int>(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  value: index,
                                  groupValue: selectedIndex,
                                  title: Text(
                                    DateFormat(
                                      "dd MMM yyyy",
                                    ).format(DateTime.parse(date)),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedIndex = value;
                                      refreshButtonCheckBoxDate = date;
                                    });
                                  },
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 15),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: selectedIndex == null
                                    ? null
                                    : () async {
                                        bool isConnected =
                                            await internetConnectionRepo
                                                .checkInternetConnection();
                                        if (isConnected) {
                                          setState(() {
                                            isProcessStart = true;
                                          });

                                          await cache
                                              .addStringCacheLocalAndFirebase(
                                                'viewDateUi',
                                                refreshButtonCheckBoxDate,
                                              );

                                          await openingController.cbToOb(
                                            lastDataExistDate,
                                            refreshButtonCheckBoxDate,
                                          );

                                          print(
                                            'refreshButtonCheckBoxDate $refreshButtonCheckBoxDate',
                                          );

                                          if (context.mounted) {
                                            Navigator.pop(context, true);
                                          }
                                        } else {
                                          showErrorToast(
                                            'No Internet Connection',
                                          );
                                        }
                                      },
                                child: const Text("Continue"),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      );
    },
  );
}

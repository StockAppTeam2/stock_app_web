import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/Internet_connection_repo.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _cacheRepository = getIt<CacheRepository>();
  final _internetConnectionRepo = getIt<InternetConnectionRepo>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController excelHeaderController = TextEditingController();
  TextEditingController excelDistrictController = TextEditingController();

  bool isLoading = false;
  bool samplePresent = false;

  @override
  void initState() {
    super.initState();
    checkSampleDataPresent();
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Column(
        children: [
          Card(
            elevation: 5.0,
            child: ListTile(
              title: const Text('PV Report Settings'),
              leading: SizedBox(
                height: 30,
                width: 30,
                child: Image.asset(
                  'assets/home_page_Icons/pv.png',
                  color: Colors.black,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('PV Report Excel details'),
                      content: SizedBox(
                        height: 270,
                        width: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Excel Header:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  maxLines: 2,
                                  controller: excelHeaderController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Excel Header Con\'t Be Empty';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'District Name :',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: excelDistrictController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'District Con\'t Be Empty';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _cacheRepository
                                  .addStringCacheLocalAndFirebase(
                                    'excelHeader',
                                    excelHeaderController.text.trim(),
                                  );
                              await _cacheRepository
                                  .addStringCacheLocalAndFirebase(
                                    'excelDistrict',
                                    excelDistrictController.text.trim(),
                                  );

                              showSuccessToast('Details Updated Successfully');
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            }
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Card(
            elevation: 5.0,
            child: ListTile(
              leading: const Icon(Icons.settings_suggest_sharp),
              title: const Text('Add Previous Days Cumulative'),
              onTap: () async {
                bool isConnected = await _internetConnectionRepo
                    .checkInternetConnection();
                if (isConnected) {
                  String shopId = await getIt<ShopIdController>().getShopId();
                  if (!context.mounted) return;
                  context.go('/$shopId/${AppRoutes.previousDayCumulative}');
                } else {
                  showErrorToast('No Internet Connection');
                }
              },
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),
          Card(
            elevation: 5.0,
            child: ListTile(
              leading: const Icon(Icons.settings_suggest_sharp),
              title: const Text('Match E2E Sales'),
              onTap: () async {
                bool isConnected = await _internetConnectionRepo
                    .checkInternetConnection();
                if (isConnected) {
                  String shopId = await getIt<ShopIdController>().getShopId();
                  if (!context.mounted) return;
                  context.go('/$shopId/${AppRoutes.matchE2ESalesPage}');
                } else {
                  showErrorToast('No Internet Connection');
                }
              },
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),
          // language not delete
          // Card(
          //   elevation: 5.0,
          //   child: ListTile(
          //     leading: const Icon(Icons.settings_suggest_sharp),
          //     title: const Text('Language'),
          //     onTap: () async {
          //       bool isDemoExpired = await demoExpireCheck();
          //       if (isDemoExpired) {
          //         String title = 'Demo Expired';
          //         String msg =
          //             'Your free demo was expired. Please contact for a support.';
          //         await popUpController.infoPopup(context, msg, title);
          //       } else {
          //         showDialog(
          //           context: context,
          //           builder: (BuildContext context) {
          //             return StatefulBuilder(
          //               builder: (context, setState) {
          //                 return AlertDialog(
          //                   title: Text(AppLocalizations.of(context).language),
          //                   content: Column(
          //                     mainAxisSize: MainAxisSize.min,
          //                     children: [
          //                       CheckboxListTile(
          //                         title: const Text('தமிழ்'),
          //                         value: _isTamilSelected,
          //                         onChanged: (onChanged) {
          //                           setState(() {
          //                             _isTamilSelected = onChanged!;
          //                             _language = 'ta';
          //
          //                             if (_isTamilSelected) {
          //                               _isEnglishSelected = false;
          //                             }
          //                           });
          //                         },
          //                       ),
          //                       CheckboxListTile(
          //                         title: const Text('English'),
          //                         value: _isEnglishSelected,
          //                         onChanged: (onChanged) {
          //                           setState(() {
          //                             _isEnglishSelected = onChanged!;
          //                             _language = 'en';
          //
          //                             if (_isEnglishSelected) {
          //                               _isTamilSelected = false;
          //                             }
          //                           });
          //                         },
          //                       ),
          //                       ElevatedButton(
          //                         onPressed: () async {
          //                           try {
          //                             SharedPreferences pref =
          //                                 await SharedPreferences.getInstance();
          //                             pref.setString('language', _language);
          //
          //                             Navigator.pushAndRemoveUntil(
          //                               context,
          //                               MaterialPageRoute(
          //                                 builder: (context) =>
          //                                     const StockApp(),
          //                               ),
          //                               (route) => false,
          //                             );
          //                           } catch (exception, stacktrace) {
          //                             firebaseCrashlyticsController
          //                                 .getCrashAndException(
          //                                   AppLocalizations.of(
          //                                     context,
          //                                   ).language,
          //                                   'Language OK Button',
          //                                   exception,
          //                                   stacktrace,
          //                                   false,
          //                                 );
          //                             Navigator.of(context).pop();
          //                             ScaffoldMessenger.of(
          //                               context,
          //                             ).showSnackBar(
          //                               SnackBar(
          //                                 content: Text(
          //                                   'Something went wrong try again later..!', // Or a more informative message
          //                                   style: TextStyle(
          //                                     color: Colors.white,
          //                                   ), // Set text color to white
          //                                 ),
          //                                 duration: const Duration(seconds: 4),
          //                                 backgroundColor: Colors
          //                                     .red, // Or any other desired color
          //                               ),
          //                             );
          //                           }
          //                         },
          //                         child: const Text('OK'),
          //                       ),
          //                     ],
          //                   ),
          //                 );
          //               },
          //             );
          //           },
          //         );
          //       }
          //     },
          //     trailing: const Icon(Icons.arrow_forward_ios),
          //   ),
          // ),
          samplePresent
              ? Card(
                  elevation: 5.0,
                  child: ListTile(
                    leading: const Icon(
                      Icons.settings_suggest_sharp,
                      color: Colors.blue,
                    ),
                    title: const Text(
                      'Delete Sample Data',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: Text(
                                  'Do You Want To Delete Sample Data',
                                ),
                                actionsAlignment:
                                    MainAxisAlignment.spaceBetween,
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      bool isConnected =
                                          await _internetConnectionRepo
                                              .checkInternetConnection();
                                      String shopId =
                                          await getIt<ShopIdController>()
                                              .getShopId();

                                      if (isConnected) {
                                        DocumentReference sampleData =
                                            FirebaseFirestore.instance
                                                .collection('settings')
                                                .doc(shopId);
                                        DocumentSnapshot snapshot =
                                            await sampleData.get();
                                        if (snapshot.exists) {
                                          Map<String, dynamic> data =
                                              snapshot.data()
                                                  as Map<String, dynamic>;
                                          if (data.containsKey(
                                                'sampleDataPresent',
                                              ) &&
                                              data['sampleDataPresent'] ==
                                                  true) {
                                            //
                                            List<String> tables = [
                                              'items',
                                              'inward',
                                              'sales',
                                              'pos',
                                              'salesCumulative',
                                            ];

                                            print(
                                              'tablestablestablestablestables',
                                            );
                                            for (final table in tables) {
                                              CollectionReference collection;

                                              if (table == 'salesCumulative') {
                                                collection = FirebaseFirestore
                                                    .instance
                                                    .collection('sales')
                                                    .doc(shopId)
                                                    .collection(
                                                      'salesCumulative',
                                                    );
                                              } else {
                                                collection = FirebaseFirestore
                                                    .instance
                                                    .collection(table)
                                                    .doc(shopId)
                                                    .collection('date');
                                              }

                                              final snapshot = await collection
                                                  .get();

                                              for (final doc in snapshot.docs) {
                                                print(
                                                  'Deleting $table/${doc.id}',
                                                );
                                                await doc.reference.delete();
                                              }
                                            }
                                            print(
                                              'tablestablestablestablestables',
                                            );

                                            await sampleData.set({
                                              'sampleDataPresent': false,
                                            }, SetOptions(merge: true));
                                            print(
                                              'tablestablestablestablestables1',
                                            );

                                            //
                                          }
                                        }
                                      } else {
                                        showErrorToast(
                                          'No Internet Connection',
                                        );
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }

                                      setState(() {
                                        isLoading = false;
                                      });

                                      showSuccessToast('Sample Data Deleted');

                                      if (!context.mounted) return;
                                      context.go('/$shopId/${AppRoutes.home}');
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: isLoading
                                        ? CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text(' Ok '),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  void checkSampleDataPresent() async {
    String shopId = await getIt<ShopIdController>().getShopId();

    DocumentSnapshot sampleData = await FirebaseFirestore.instance
        .collection('settings')
        .doc(shopId)
        .get();

    if (sampleData.exists) {
      Map<String, dynamic> data = sampleData.data() as Map<String, dynamic>;
      if (data.containsKey('sampleDataPresent')) {
        print('checkSampleDataPresent2: ${data['sampleDataPresent']}');

        setState(() {
          samplePresent = data['sampleDataPresent'];
        });
      }
    }

    print('checkSampleDataPresent: $samplePresent');
  }
}

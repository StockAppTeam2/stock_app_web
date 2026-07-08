import 'package:flutter/material.dart';
import 'package:stock_app_web/controllers/return_stock_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';
import 'package:stock_app_web/models/return_model.dart';

class ReturnStockPage extends StatefulWidget {
  const ReturnStockPage({super.key});

  @override
  State<ReturnStockPage> createState() => _ReturnStockPageState();
}

class _ReturnStockPageState extends State<ReturnStockPage> {
  final _viewDateController = getIt<ViewDateController>();
  final returnStockController = getIt<ReturnStockController>();

  // List<ReturnViewModel> returnStock = [];

  String viewDate = '';

  @override
  void initState() {
    super.initState();
    getViewDate();
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            PageHeader(
              title: 'RETURN STOCK',
              viewDate: viewDate,
              query: (String p1) {},
              videoLink: 's',
              page: 'opening_stock',
              invoiceNo: '',
              showReport: true,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<List<ReturnViewModel>>(
                future: getReturnStock(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  final products = snapshot.data ?? [];

                  if (products.isEmpty) {
                    return const Center(child: Text("No Data Found"));
                  }

                  return Expanded(
                    child: GridView.builder(
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 500,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 2.3,
                      ),
                      itemBuilder: (_, index) {
                        final product = products[index];

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 10,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text('${index + 1}. '),
                                              Text(
                                                '${product.productId.toString()},',
                                                style: const TextStyle(
                                                  color: Colors.purpleAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            product.brand,
                                            style: const TextStyle(
                                              color: Colors.purpleAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${product.category} - ${product.size},',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            'RS.${product.price} - ${product.range}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text('Case'),
                                              Text(
                                                "${product.returnBundle == -1 ? '' : product.returnBundle}",
                                                style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Spacer(),

                                              // isSalesEntered
                                              //     ? SizedBox()
                                              //     : PopupMenuButton(
                                              //   child: const Icon(
                                              //     Icons.more_vert,
                                              //     color: Colors.blue,
                                              //   ),
                                              //   onSelected: (value) async {
                                              //     ItemsViewModel?
                                              //     item = currentStock
                                              //         .where(
                                              //           (e) =>
                                              //       e.productId ==
                                              //           product
                                              //               .productId,
                                              //     )
                                              //         .firstOrNull;
                                              //     if (value == 'Edit') {
                                              //       setState(() {
                                              //         returnStockOld =
                                              //         product;
                                              //         textControllers
                                              //             .bundleController
                                              //             .text =
                                              //             product
                                              //                 .returnBundle
                                              //                 .toString();
                                              //         textControllers
                                              //             .retailController
                                              //             .text =
                                              //             product
                                              //                 .returnRetail
                                              //                 .toString();
                                              //
                                              //         selectedData = item;
                                              //         enableEdit = true;
                                              //       });
                                              //     } else if (value ==
                                              //         'Delete') {
                                              //       showDialog(
                                              //         context: context,
                                              //         builder: (context) {
                                              //           return AlertDialog(
                                              //             title: Text(
                                              //               'Do You Want to Delete',
                                              //             ),
                                              //             actionsAlignment:
                                              //             MainAxisAlignment
                                              //                 .spaceBetween,
                                              //             actions: [
                                              //               TextButton(
                                              //                 onPressed: () {
                                              //                   Navigator.of(
                                              //                     context,
                                              //                   ).pop();
                                              //                 },
                                              //                 style: TextButton.styleFrom(
                                              //                   backgroundColor:
                                              //                   Colors.blue,
                                              //                   foregroundColor:
                                              //                   Colors
                                              //                       .white,
                                              //                 ),
                                              //                 child: Text(
                                              //                   'Cancel',
                                              //                 ),
                                              //               ),
                                              //               TextButton(
                                              //                 onPressed: () async {
                                              //                   bool
                                              //                   isConnected =
                                              //                   await itemsController
                                              //                       .checkConnection();
                                              //                   if (isConnected) {
                                              //                     String
                                              //                     checkCurrentSqlDataIsUpToDate =
                                              //                     await databaseHelper
                                              //                         .upToDateDataCheck1();
                                              //                     if (checkCurrentSqlDataIsUpToDate ==
                                              //                         '') {
                                              //                       await returnStockDatabaseHelper
                                              //                           .deleteReturnStock(
                                              //                         product
                                              //                             .id!,
                                              //                       );
                                              //
                                              //                       await firebaseServicesReturnStock.deleteReturnStock(
                                              //                         product
                                              //                             .date,
                                              //                         product
                                              //                             .productId
                                              //                             .toString(),
                                              //                       );
                                              //                       setState(() {
                                              //                         returnStockOld =
                                              //                         product;
                                              //                         textControllers
                                              //                             .bundleController
                                              //                             .text =
                                              //                         '';
                                              //                         textControllers
                                              //                             .retailController
                                              //                             .text =
                                              //                         '';
                                              //
                                              //                         selectedData =
                                              //                         null;
                                              //                         enableEdit =
                                              //                         false;
                                              //                       });
                                              //                       loadReturnStockData();
                                              //                       loadActualData();
                                              //
                                              //                       Navigator.of(
                                              //                         context,
                                              //                       ).pop();
                                              //                     } else {
                                              //                       popUpController
                                              //                           .dataUpToDateInfoPopup1(
                                              //                         context,
                                              //                         checkCurrentSqlDataIsUpToDate,
                                              //                       );
                                              //                     }
                                              //                   } else {
                                              //                     popUpController
                                              //                         .showConnectivityDialog(
                                              //                       context,
                                              //                     );
                                              //                   }
                                              //                 },
                                              //                 style: TextButton.styleFrom(
                                              //                   backgroundColor:
                                              //                   Colors.red,
                                              //                   foregroundColor:
                                              //                   Colors
                                              //                       .white,
                                              //                 ),
                                              //                 child: Text('Ok'),
                                              //               ),
                                              //             ],
                                              //           );
                                              //         },
                                              //       );
                                              //     }
                                              //   },
                                              //   itemBuilder:
                                              //       (
                                              //       BuildContext context,
                                              //       ) => <PopupMenuEntry>[
                                              //     PopupMenuItem(
                                              //       value: 'Edit',
                                              //       child: Row(
                                              //         children: [
                                              //           const Expanded(
                                              //             child: Icon(
                                              //               Icons.edit,
                                              //               color: Colors
                                              //                   .green,
                                              //             ),
                                              //           ),
                                              //           Expanded(
                                              //             child: Text(
                                              //               'Edit',
                                              //             ),
                                              //           ),
                                              //         ],
                                              //       ),
                                              //     ),
                                              //     PopupMenuItem(
                                              //       value: 'Delete',
                                              //       child: Row(
                                              //         children: [
                                              //           const Expanded(
                                              //             child: Icon(
                                              //               Icons.delete,
                                              //               color:
                                              //               Colors.red,
                                              //             ),
                                              //           ),
                                              //           Expanded(
                                              //             child: Text(
                                              //               'Delete',
                                              //             ),
                                              //           ),
                                              //         ],
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('Bottle: '),
                                              Text(
                                                '${product.returnRetail == -1 ? '' : product.returnRetail}',
                                                style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text('Tot Bottles:'),
                                              Text(
                                                "${product.totalReturnRetailUnits == -1 ? '' : product.totalReturnRetailUnits}",
                                                style: const TextStyle(
                                                  color: Colors.purpleAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                          Row(
                                            children: [
                                              Text('Rs.'),
                                              Text(
                                                '${product.totalPriceReturn == -1 ? '' : product.totalPriceReturn}',
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getViewDate() async {
    String value = await _viewDateController.getViewDateForUi();
    debugPrint('viewdate: $value');
    if (mounted) {
      setState(() => viewDate = value);
    }
  }

  Future<List<ReturnViewModel>> getReturnStock() async {
    String value = await _viewDateController.getViewDateForUi();
    List<ReturnViewModel> returnStock = await returnStockController
        .getAllReturnStock('3810', value);
    print('returnStock: $returnStock');
    return returnStock;
  }
}

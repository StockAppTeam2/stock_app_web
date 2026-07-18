import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_app_web/controllers/opening_page_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/utils/guid_video_links.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';
import 'package:stock_app_web/models/items_table_model.dart';
import 'package:stock_app_web/pages/opening/opening_products_cards.dart';
import 'package:stock_app_web/pages/opening/widgets/cb_to_ob_popup.dart';
import 'package:stock_app_web/pages/opening/widgets/previous_day_closing_exist.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';
import 'package:stock_app_web/pages/widgets/total_cases_widget.dart';

enum ObViewType { obCases, obBottles, obCasesBottles, obCasesBottlesTotal }

class OpeningStockPage extends StatefulWidget {
  const OpeningStockPage({super.key});

  @override
  State<OpeningStockPage> createState() => _OpeningStockPageState();
}

class _OpeningStockPageState extends State<OpeningStockPage> {
  final _viewDateController = getIt<ViewDateController>();
  final _openingController = getIt<OpeningPageController>();

  String viewDate = '';
  String viewType = '';
  String query = '';
  String title = '';
  bool isFirstDate = false;

  late Future<List<ItemsViewModel>> _future;
  List<ItemsViewModel> filterData = [];

  @override
  void initState() {
    super.initState();
    getViewDate();

    checkFirstDay();
    _future = loadOpeningData();
  }

  @override
  void dispose() {
    disposeDataInFuture();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            PageHeader(
              title: title,
              viewDate: viewDate,
              query: (String p1) {
                print('p1 $p1');
                setState(() {
                  query = p1;
                  updateFuture();
                });
              },
              videoLink: openingStockVideoLink,
              page: 'opening_stock',
              invoiceNo: '',
              showReport: true,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<List<ItemsViewModel>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  final products = snapshot.data ?? [];

                  if (products.isEmpty) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          // view date
                          List<String> viewDates = await _openingController
                              .getDates(null, 2);

                          bool isPreviousDayClosingExist =
                              await _openingController.checkClosingExist(
                                viewDates.first,
                              );
                          print(
                            'isPreviousDayClosingExist $isPreviousDayClosingExist',
                          );

                          if (isPreviousDayClosingExist) {
                            // check last today and yesterday have data
                            List<String> isLastTowDaysDataExist =
                                await _openingController
                                    .checkTodayYesterdayDataExist();

                            if (!context.mounted) return;

                            final bool? isDone = await cbToObPopup(
                              context,
                              isLastTowDaysDataExist,
                              viewDates.first,
                            );
                            if (isDone == true) {
                              print('isDone working');
                              await checkFirstDay();
                              setState(() {
                                _future = loadOpeningData();
                              });
                            }
                          } else {
                            showPreviousDayClosingIsMissing(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          minimumSize: Size(140, 50),
                        ),
                        child: Text('CB TO OB'),
                      ),
                    );
                  }

                  if (products.isEmpty) {
                    return const Center(child: Text("No Data Found"));
                  }

                  return Column(
                    children: [
                      TotalCasesWidget(modelData: products),

                      const SizedBox(height: 10),

                      Expanded(
                        child: GridView.builder(
                          itemCount: products.length,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
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
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '${index + 1}.',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              Text(
                                                ' ${product.productId.toString()},',
                                                style: const TextStyle(
                                                  color: Colors.purpleAccent,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            product.brand,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.purpleAccent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            '${product.category} - ${product.size},',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            'Rs. ${product.price} - ${product.range}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        children: [
                                          if (viewType ==
                                              ObViewType.obCases.name)
                                            buildOpeningCard(
                                              title: 'CASES',
                                              value:
                                                  "${product.openingBundle == -1 ? '' : product.openingBundle}",
                                              checked:
                                                  product.checkOpeningCase != 0,
                                              onChanged: (v) {
                                                updateOpening(
                                                  index: index,
                                                  value: v,
                                                  column: 'checkOpeningCase',
                                                  product: product,
                                                );
                                              },
                                            ),
                                          if (viewType ==
                                              ObViewType.obBottles.name)
                                            buildOpeningCard(
                                              title: 'BOTTLES',
                                              value:
                                                  "${product.openingRetail == -1 ? '' : product.openingRetail}",
                                              checked:
                                                  product.checkOpeningBottle !=
                                                  0,
                                              onChanged: (v) {
                                                updateOpening(
                                                  index: index,
                                                  value: v,
                                                  column: 'checkOpeningBottle',
                                                  product: product,
                                                );
                                              },
                                            ),
                                          if (viewType ==
                                              ObViewType.obCasesBottles.name)
                                            buildCaseBottleCard(
                                              context: context,
                                              item: product,
                                              onChanged: (value) async {
                                                await updateOpening(
                                                  index: index,
                                                  value: value,
                                                  column:
                                                      "checkOpeningCaseBottle",
                                                  product: product,
                                                );
                                              },
                                              checked:
                                                  product
                                                      .checkOpeningCaseBottle !=
                                                  0,
                                            ),
                                          if (viewType ==
                                              ObViewType
                                                  .obCasesBottlesTotal
                                                  .name)
                                            buildTotalCard(
                                              context: context,
                                              item: product,
                                              width: 100,
                                              showMenu: isFirstDate,
                                              onEdit: () async {
                                                String shopId =
                                                    await getIt<
                                                          ShopIdController
                                                        >()
                                                        .getShopId();
                                                await _openingController
                                                    .addViewType(
                                                      'obViewType',
                                                      viewType,
                                                    );
                                                if (!context.mounted) return;
                                                context.go(
                                                  '/$shopId/${AppRoutes.editOpeningStock}',
                                                  extra: {'data': product},
                                                );
                                              },
                                              onDelete: () {
                                                deletePopup(context, product);
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateOpening({
    required int index,
    required bool value,
    required String column,
    required ItemsViewModel product,
  }) async {
    switch (column) {
      case 'checkOpeningCase':
        product.checkOpeningCase = value ? 1 : 0;
        break;

      case 'checkOpeningBottle':
        product.checkOpeningBottle = value ? 1 : 0;
        break;

      case 'checkOpeningCaseBottle':
        product.checkOpeningCaseBottle = value ? 1 : 0;
        break;
    }

    setState(() {});
  }

  void disposeDataInFuture() {
    _future = Future.value([]);
  }

  void updateFuture() {
    if (query != '') {
      _future = loadFilteredOpeningData(query);
    } else {
      _future = loadOpeningData();
    }
    setState(() {});
  }

  void getViewDate() async {
    String value = await _viewDateController.getViewDateForUi();
    print('viewdate: $value');
    if (mounted) {
      setState(() => viewDate = value);
    }
  }

  Future<List<ItemsViewModel>> loadFilteredOpeningData(String query) async {
    List<ItemsViewModel> data = [];
    print('filtered data1 $filterData');
    data = filterData
        .where(
          (card) =>
              card.productId.toString().toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              card.brand.toString().toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    print('filtered data2 $filterData');
    return data;
  }

  Future<List<ItemsViewModel>> loadOpeningData() async {
    String value = await _viewDateController.getViewDateForUi();
    String shopId = await getIt<ShopIdController>().getShopId();
    List<ItemsViewModel> itemsData = [];

    List<ItemsViewModel> data = await _openingController.getOpeningData(
      value,
      shopId,
    );
    String type = await _openingController.getViewType('obViewType');
    setState(() {
      viewType = type;
    });

    if (type != '') {
      print('viewType OB : $viewType');
      if (viewType == ObViewType.obCases.name) {
        title = 'OB CASES';
        itemsData.addAll(
          data.where((item) {
            return item.actualBundle != 0;
          }),
        );
      } else if (viewType == ObViewType.obBottles.name) {
        title = 'OB BOTTLES';
        itemsData.addAll(
          data.where((item) {
            return item.actualRetail != 0;
          }),
        );
      } else if (viewType == ObViewType.obCasesBottles.name) {
        title = 'OB CASES + BOTTLES';
        itemsData.addAll(
          data.where((item) {
            return item.totalActualRetailUnits != 0;
          }),
        );
      } else if (viewType == ObViewType.obCasesBottlesTotal.name) {
        setState(() {
          title = 'OB CASE BTL TOTAL ';
        });
        itemsData = data;
      }
    }

    filterData = itemsData;
    print('loadOpeningData ${data.length}');

    return itemsData;
  }

  Future<void> checkFirstDay() async {
    bool isFirstDay = await _openingController.checkFirstDay();
    setState(() {
      isFirstDate = isFirstDay;
    });
  }

  void deletePopup(BuildContext context, ItemsViewModel product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Do You Want To Delete The Product?'),
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
                await _openingController.deleteOpening(product);
                if (!context.mounted) return;
                Navigator.pop(context);

                showSuccessToast('Item Deleted Successfully');
                updateFuture();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}

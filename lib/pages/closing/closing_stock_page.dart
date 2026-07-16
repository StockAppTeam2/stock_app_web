import 'package:flutter/material.dart';
import 'package:stock_app_web/controllers/opening_page_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/utils/guid_video_links.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';
import 'package:stock_app_web/models/items_table_model.dart';
import 'package:stock_app_web/pages/widgets/total_cases_widget.dart';
import 'package:stock_app_web/pages/closing/closing_product_cards.dart';

enum CbViewType { cbCases, cbBottles, cbCasesBottles, cbCasesBottlesTotal }

class ClosingStockPage extends StatefulWidget {
  const ClosingStockPage({super.key});

  @override
  State<ClosingStockPage> createState() => _ClosingStockPageState();
}

class _ClosingStockPageState extends State<ClosingStockPage> {
  final _viewDateController = getIt<ViewDateController>();
  final _openingController = getIt<OpeningPageController>();

  String viewDate = '';
  String viewType = '';
  String query = '';
  String title = '';

  late Future<List<ItemsViewModel>> _future;
  List<ItemsViewModel> filterData = [];

  @override
  void initState() {
    super.initState();
    getViewDate();
    getViewType();
    _future = loadClosingData();
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
              videoLink: closingStockE2EVideoLink,
              page: 'closing_stock',
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
                                              CbViewType.cbCases.name)
                                            buildOpeningCard(
                                              title: 'CASES',
                                              value:
                                                  "${product.closingBundle == -1 ? '' : product.closingBundle}",
                                              checked:
                                                  product.checkClosingCase != 0,
                                              onChanged: (v) {
                                                updateClosing(
                                                  index: index,
                                                  value: v,
                                                  column: 'checkClosingCase',
                                                  product: product,
                                                );
                                              },
                                            ),
                                          if (viewType ==
                                              CbViewType.cbBottles.name)
                                            buildOpeningCard(
                                              title: 'BOTTLES',
                                              value:
                                                  "${product.closingRetail == -1 ? '' : product.closingRetail}",
                                              checked:
                                                  product.checkClosingBottle !=
                                                  0,
                                              onChanged: (v) {
                                                updateClosing(
                                                  index: index,
                                                  value: v,
                                                  column: 'checkClosingBottle',
                                                  product: product,
                                                );
                                              },
                                            ),
                                          if (viewType ==
                                              CbViewType.cbCasesBottles.name)
                                            buildCaseBottleCard(
                                              context: context,
                                              item: product,
                                              checked:
                                                  product
                                                      .checkClosingCaseBottle !=
                                                  0,
                                              onChanged: (value) async {
                                                await updateClosing(
                                                  index: index,
                                                  value: value,
                                                  column:
                                                      "checkClosingCaseBottle",
                                                  product: product,
                                                );
                                              },
                                            ),
                                          if (viewType ==
                                              CbViewType
                                                  .cbCasesBottlesTotal
                                                  .name)
                                            buildTotalCard(
                                              context: context,
                                              item: product,
                                              width: 100,
                                              showMenu: false,
                                              onEdit: () {},
                                              onDelete: () {},
                                              // showMenu:
                                              //     userController.isManager ||
                                              //     userController.isInCharge,
                                              // onEdit: () {
                                              //   _editItem(data[index], context);
                                              // },
                                              // onDelete: () {
                                              //   _deleteItem(
                                              //     data[index].id,
                                              //     context,
                                              //     data[index].productId,
                                              //     data[index].date,
                                              //   );
                                              // },
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

  Future<void> updateClosing({
    required int index,
    required bool value,
    required String column,
    required ItemsViewModel product,
  }) async {
    switch (column) {
      case 'checkClosingCase':
        product.checkClosingCase = value ? 1 : 0;
        break;

      case 'checkClosingBottle':
        product.checkClosingBottle = value ? 1 : 0;
        break;

      case 'checkClosingCaseBottle':
        product.checkClosingCaseBottle = value ? 1 : 0;
        break;
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

  void getViewType() async {
    String type = await _openingController.getViewType('cbViewType');
    setState(() {
      viewType = type;
    });

    if (type != '') {
      print('viewType CB : $viewType');
      if (viewType == CbViewType.cbCases.name) {
        setState(() {
          title = 'CB CASES';
        });
      } else if (viewType == CbViewType.cbBottles.name) {
        setState(() {
          title = 'CB BOTTLES';
        });
      } else if (viewType == CbViewType.cbCasesBottles.name) {
        setState(() {
          title = 'CB CASES + BOTTLES';
        });
      } else if (viewType == CbViewType.cbCasesBottlesTotal.name) {
        setState(() {
          title = 'CB CASE BTL TOTAL';
        });
      }
    }
  }

  Future<List<ItemsViewModel>> loadClosingData() async {
    String value = await _viewDateController.getViewDateForUi();
    String shopId = await getIt<ShopIdController>().getShopId();

    List<ItemsViewModel> data = await _openingController.getOpeningData(
      value,
      shopId,
    );
    filterData = data;
    print('loadClosingData ${data.length}');

    return data;
  }

  Future<List<ItemsViewModel>> loadFilteredClosingData(String query) async {
    List<ItemsViewModel> data = [];

    data = filterData
        .where(
          (card) =>
              card.productId.toString().toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              card.brand.toString().toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return data;
  }

  void updateFuture() {
    if (query != '') {
      _future = loadFilteredClosingData(query);
    } else {
      _future = loadClosingData();
    }
  }

  void disposeDataInFuture() {
    _future = Future.value([]);
  }
}

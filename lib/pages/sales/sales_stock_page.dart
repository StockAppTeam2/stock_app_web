import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_app_web/controllers/indent_controller.dart';
import 'package:stock_app_web/controllers/sales_page_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/Internet_connection_repo.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/utils/guid_video_links.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';
import 'package:stock_app_web/models/indent_plan_model.dart';
import 'package:stock_app_web/models/sales_table_model.dart';
import 'package:stock_app_web/pages/sales/sales_products_cards.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class SalesStockPage extends StatefulWidget {
  const SalesStockPage({super.key});

  @override
  State<SalesStockPage> createState() => _SalesStockPageState();
}

class _SalesStockPageState extends State<SalesStockPage> {
  final _viewDateController = getIt<ViewDateController>();
  final indentController = getIt<IndentController>();

  String viewDate = '';
  String query = '';
  bool allowSalesEntry = false;

  late Future<List<IndentPlanModel>> _future;
  List<IndentPlanModel> filterData = [];

  @override
  void initState() {
    super.initState();
    getViewDate();
    _future = loadSalesData();
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
              title: 'Sales Page',
              viewDate: viewDate,
              query: (String p1) {
                setState(() {
                  query = p1;
                  updateFuture();
                });
              },
              videoLink: '',
              page: 'sales_stock',
              invoiceNo: '',
              showReport: true,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<List<IndentPlanModel>>(
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
                      Expanded(
                        child: GridView.builder(
                          itemCount: products.length,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 500,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1.9,
                              ),
                          itemBuilder: (_, index) {
                            final data = products[index];

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${index + 1}.',
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '${data.productId.toString()} - ',
                                          style: const TextStyle(
                                            color: Colors.purpleAccent,
                                            // fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            data.brand,
                                            style: const TextStyle(
                                              color: Colors.purpleAccent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 19,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${data.range} - ',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            "${data.size} - ",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            'Rs.${data.price.toString()}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: InputDecorator(
                                            decoration: InputDecoration(
                                              labelText: 'OB',

                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            child: Text(
                                              data.totalActualRetailUnits
                                                  .toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,

                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Icon(Icons.minimize),
                                        Expanded(
                                          flex: 3,
                                          child: InputDecorator(
                                            decoration: InputDecoration(
                                              labelText: 'SALES',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            child: Text(
                                              '${data.totalSalesRetailUnits != -1 ? data.totalSalesRetailUnits : ''} '
                                                  .toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,

                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Icon(Icons.drag_handle),
                                        Expanded(
                                          flex: 3,
                                          child: InputDecorator(
                                            decoration: InputDecoration(
                                              labelText: 'CB',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            child: Text(
                                              '${data.totalCloseRetailUnits != -1 ? data.totalCloseRetailUnits : ''}'
                                                  .toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                // fontSize: 22,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 20),
                                    if (data.totalCloseRetailUnits != -1)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '(${data.totalSalesRetailUnits != -1 ? data.totalSalesRetailUnits : ' '} × Rs.${data.price.toString()} = Rs.${data.totalPriceSales != -1 ? data.totalPriceSales : ' '})',
                                            style: TextStyle(
                                              color: Colors.indigo[800],
                                              fontWeight: FontWeight.bold,
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

  void getViewDate() async {
    String value = await _viewDateController.getViewDateForUi();

    if (mounted) {
      setState(() => viewDate = value);
    }
  }

  Future<List<IndentPlanModel>> loadSalesData() async {
    String value = await _viewDateController.getViewDateForUi();
    String shopId = await getIt<ShopIdController>().getShopId();
    try {
      List<IndentPlanModel> indentData = await indentController.getIndentData(
        value,
        shopId,
      );
      filterData = indentData;
      return indentData;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<IndentPlanModel>> loadFilteredSalesData(String query) async {
    List<IndentPlanModel> data = [];

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
      _future = loadFilteredSalesData(query);
    } else {
      _future = loadSalesData();
    }
  }

  void disposeDataInFuture() {
    _future = Future.value([]);
  }
}

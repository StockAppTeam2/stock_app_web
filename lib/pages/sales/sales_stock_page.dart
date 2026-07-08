import 'package:flutter/material.dart';
import 'package:stock_app_web/controllers/sales_page_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/utils/guid_video_links.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';
import 'package:stock_app_web/models/sales_table_model.dart';
import 'package:stock_app_web/pages/sales/sales_products_cards.dart';

class SalesStockPage extends StatefulWidget {
  const SalesStockPage({super.key});

  @override
  State<SalesStockPage> createState() => _SalesStockPageState();
}

class _SalesStockPageState extends State<SalesStockPage> {
  final _viewDateController = getIt<ViewDateController>();
  final _salesController = getIt<SalesPageController>();

  String viewDate = '';
  String query = '';

  late Future<List<SalesViewModel>> _future;
  List<SalesViewModel> filterData = [];

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
              title: 'Sales Entry',
              viewDate: viewDate,
              query: (String p1) {
                setState(() {
                  query = p1;
                  updateFuture();
                });
              },
              videoLink: salesVideoLink,
              page: 'sales_stock',
              invoiceNo: '',
              showReport: true,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<List<SalesViewModel>>(
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

  void getViewDate() async {
    String value = await _viewDateController.getViewDateForUi();

    if (mounted) {
      setState(() => viewDate = value);
    }
  }

  Future<List<SalesViewModel>> loadSalesData() async {
    String value = await _viewDateController.getViewDateForUi();

    List<SalesViewModel> data = await _salesController.getSalesData(
      value,
      '3810',
    );
    filterData = data;
    print('loadSalesData ${data.length}');

    return data;
  }

  Future<List<SalesViewModel>> loadFilteredSalesData(String query) async {
    List<SalesViewModel> data = [];

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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_app_web/controllers/receipt_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';
import 'package:stock_app_web/models/inward_table_model.dart';
import 'package:stock_app_web/pages/receipt/receipt_product_cards.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class ReceiptStockPage extends StatefulWidget {
  final String date;

  const ReceiptStockPage({super.key, required this.date});

  @override
  State<ReceiptStockPage> createState() => _ReceiptStockPageState();
}

class _ReceiptStockPageState extends State<ReceiptStockPage> {
  final _receiptController = getIt<ReceiptController>();

  String invoiceNo = '';
  String query = '';

  bool allowEdit = false;

  late Future<List<InwardViewModel>> _future;
  List<InwardViewModel> filterData = [];

  @override
  void initState() {
    super.initState();
    enableEdit();
    _future = loadInwardData();
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            PageHeader(
              title: 'Receipt',
              viewDate: widget.date,
              query: (String p1) {
                print('p1 $p1');
                setState(() {
                  query = p1;
                  updateFuture();
                });
              },
              videoLink: '',
              page: 'receipt_stock',
              invoiceNo: invoiceNo,
              showReport: true,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<List<InwardViewModel>>(
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
                                            showMenu: allowEdit,
                                            onEdit: () async {
                                              String shopId =
                                                  await getIt<
                                                        ShopIdController
                                                      >()
                                                      .getShopId();
                                              if (context.mounted) {
                                                context.go(
                                                  '/$shopId/${AppRoutes.editReceiptStock}',
                                                  extra: {'product': product},
                                                );
                                              }
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

  Future<List<InwardViewModel>> loadInwardData() async {
    String shopId = await getIt<ShopIdController>().getShopId();
    List<InwardViewModel> data = await _receiptController.getInwardData(
      widget.date,
      shopId,
    );
    filterData = data;
    if (data.isNotEmpty) {
      setState(() {
        invoiceNo = data.first.invoiceNo;
      });
    }
    print('loadInwardData ${data.length}');

    return data;
  }

  Future<List<InwardViewModel>> loadFilteredInwardData(String query) async {
    List<InwardViewModel> data = [];

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
      _future = loadFilteredInwardData(query);
    } else {
      _future = loadInwardData();
    }
  }

  void disposeDataInFuture() {
    _future = Future.value([]);
  }

  void enableEdit() async {
    bool allow = await _receiptController.enableEdit(date: widget.date);
    setState(() {
      allowEdit = allow;
    });
  }

  void deletePopup(BuildContext context, InwardViewModel product) {
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
                await _receiptController.deleteReceipt(product);
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

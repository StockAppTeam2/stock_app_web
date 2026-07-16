import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_app_web/controllers/sales_page_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';
import 'package:stock_app_web/models/sales_table_model.dart';
import 'package:stock_app_web/pages/sales/sales_products_cards.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class AddSalesPage extends StatefulWidget {
  const AddSalesPage({super.key});

  @override
  State<AddSalesPage> createState() => _AddSalesPageState();
}

class _AddSalesPageState extends State<AddSalesPage> {
  final _viewDateController = getIt<ViewDateController>();
  final _salesController = getIt<SalesPageController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController retailController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  String viewDate = '';
  String query = '';
  bool _isSaveLoading = false;

  bool _isLoading = true;

  List<SalesViewModel> products = [];
  List<SalesViewModel> filterData = [];

  SalesViewModel? currentItem;

  @override
  void initState() {
    super.initState();
    getViewDate();
    loadSalesData();
  }

  @override
  void dispose() {
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
              videoLink: '',
              page: 'add_sales_stock',
              invoiceNo: '',
              showReport: true,
            ),

            const SizedBox(height: 20),

            if (_isLoading) const Center(child: CircularProgressIndicator()),

            if (products.isEmpty && _isLoading == false)
              const Center(child: Text("No Data Found")),

            if (products.isNotEmpty)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${currentItem!.productId} - '
                      '${currentItem!.brand} - '
                      '${currentItem!.range} - '
                      '${currentItem!.size} '
                      '(Rs.${currentItem!.price})',

                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: getColorForSize(currentItem!.size),
                      ),
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        focusNode: _focusNode,
                        controller: retailController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !isNumeric(value)) {
                            return 'Bottles Con\'t Be Empty';
                          }
                          return null;
                        },

                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Enter Bottles',
                          labelText: 'Bottles',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 5.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        fixedSize: Size(160, 40),
                      ),
                      onPressed: _isSaveLoading
                          ? null
                          : () async {
                              await addSales();
                            },
                      child: _isSaveLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Save'),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
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
                                          onEdit: () {
                                            currentItem = product;

                                            retailController.text =
                                                product.totalSalesRetailUnits !=
                                                    -1
                                                ? product.totalSalesRetailUnits
                                                      .toString()
                                                : '';

                                            _focusNode.requestFocus();

                                            setState(() {});
                                          },
                                          onDelete: () {},
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

  Future<void> loadSalesData() async {
    String value = await _viewDateController.getViewDateForUi();
    String shopId = await getIt<ShopIdController>().getShopId();

    List<SalesViewModel> data = await _salesController.getSalesData(
      value,
      shopId,
    );
    products = data;
    filterData = data;
    if (data.isNotEmpty) {
      currentItem = products.first;
    }
    print('loadSalesData ${data.length}');

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> loadFilteredSalesData(String query) async {
    setState(() {
      if (query.isEmpty) {
        products = List.from(filterData);
      } else {
        products = filterData.where((item) {
          return item.productId.toString().toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              item.brand.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void updateFuture() {
    if (query != '') {
      loadFilteredSalesData(query);
    } else {
      loadSalesData();
    }
  }

  bool isNumeric(String value) {
    return int.tryParse(value) != null;
  }

  Future<void> addSales() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaveLoading = true;
      });

      int inputBottle = int.parse(retailController.text);
      int mobileNumber = int.parse(await _viewDateController.getMobileNumber());
      String currentDate = await _viewDateController.getViewDateForUi();

      await _salesController.addNewSales(
        inputBottle: inputBottle,
        currentItem: currentItem!,
        mobileNumber: mobileNumber,
        currentDate: currentDate,
      );

      showSuccessToast('Sales Added Successfully');

      final index = products.indexWhere((e) => e.id == currentItem!.id);

      if (index != -1) {
        products[index].salesRetail =
            inputBottle % currentItem!.bottlePerBundle;
        products[index].salesBundle =
            inputBottle ~/ currentItem!.bottlePerBundle;
        products[index].totalSalesRetailUnits = inputBottle;
        products[index].totalPriceSales = inputBottle * currentItem!.price;

        setState(() {});
      }

      if (index < products.length - 1) {
        currentItem = products[index + 1];
        retailController.text = products[index + 1].totalSalesRetailUnits != -1
            ? products[index + 1].totalSalesRetailUnits.toString()
            : '';
      }

      _focusNode.requestFocus();

      setState(() {});

      setState(() {
        _isSaveLoading = false;
      });
    }
  }

  Color getColorForSize(String size) {
    if (size == '180 ml') {
      return Colors.blue;
    } else if (size == '375 ml') {
      return Colors.green;
    } else if (size == '750 ml') {
      return Colors.purpleAccent;
    } else if (size == '1000 ml') {
      return Colors.pink;
    } else if (size == '500 ml') {
      return Colors.orange;
    } else if (size == '325 ml') {
      return Colors.deepOrange;
    } else if (size == '650 ml') {
      return Colors.teal;
    } else {
      return Colors.blue;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_app_web/controllers/sales_page_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/utils/guid_video_links.dart';
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

  List<SalesEntryViewModel> products = [];
  List<SalesEntryViewModel> filterData = [];

  SalesEntryViewModel? currentItem;

  bool startEntry = false;

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
              videoLink: salesVideoLink,
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
                    startEntry
                        ? Column(
                            children: [
                              Row(
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
                                  Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5),

                                        color: Colors.black54,

                                        child: RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: [
                                              const TextSpan(
                                                text: 'OB : ',
                                                style: TextStyle(
                                                  color: Colors.greenAccent,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${currentItem!.totalActualRetailUnits}',
                                                style: TextStyle(
                                                  color:
                                                      currentItem!
                                                              .totalActualRetailUnits ==
                                                          0
                                                      ? Colors.greenAccent
                                                      : Colors.yellowAccent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Form(
                                key: _formKey,
                                child: TextFormField(
                                  focusNode: _focusNode,
                                  controller: retailController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],

                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),

                                  validator: (val) {
                                    final number = int.tryParse(val ?? '');

                                    if (number == null || number.isNegative) {
                                      return 'Please Check value';
                                    }

                                    if (number >
                                        currentItem!.totalActualRetailUnits) {
                                      return 'Please Check OB';
                                    }

                                    return null;
                                  },

                                  onChanged: (value) {
                                    if (value.length > 1 &&
                                        value.startsWith('0')) {
                                      retailController.text = value.substring(
                                        1,
                                      );
                                      retailController
                                          .selection = TextSelection.collapsed(
                                        offset: retailController.text.length,
                                      );
                                    }
                                    if (value.isEmpty) {
                                      retailController.text = '0';
                                      retailController.selection =
                                          const TextSelection.collapsed(
                                            offset: 1,
                                          );
                                    }
                                  },

                                  onFieldSubmitted: (_) async {
                                    setState(() {
                                      _isSaveLoading = true;
                                    });

                                    await addSales();

                                    setState(() {
                                      _isSaveLoading = false;
                                    });
                                  },

                                  decoration: InputDecoration(
                                    labelText: 'Bottle',
                                    hintText: 'Enter Bottles',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      fixedSize: Size(160, 40),
                                    ),
                                    onPressed: _isSaveLoading
                                        ? null
                                        : () {
                                            previousItem();
                                          },
                                    child: const Text('Back'),
                                  ),

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
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : const Text('Save & Next'),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Center(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  startEntry = true;
                                });
                                _focusNode.requestFocus();
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(140, 50),
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green,
                              ),
                              child: Text('Start'),
                            ),
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
                                        buildSalesEntryTotalCard(
                                          context: context,
                                          item: product,
                                          width: 100,
                                          onEdit: () {
                                            setState(() {
                                              startEntry = true;
                                            });
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

    List<SalesEntryViewModel> data = await _salesController
        .getSalesEntryModelData(value, shopId);
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
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaveLoading = true;
    });

    try {
      final int inputBottle = int.parse(retailController.text);
      final int mobileNumber = int.parse(
        await _viewDateController.getMobileNumber(),
      );
      final String currentDate = await _viewDateController.getViewDateForUi();

      final product = currentItem!;

      await _salesController.addNewSales(
        inputBottle: inputBottle,
        currentItem: product,
        mobileNumber: mobileNumber,
        currentDate: currentDate,
      );

      showSuccessToast('Sales Added Successfully');

      final index = products.indexWhere((e) => e.id == product.id);

      if (index == -1) return;

      // Update current product
      products[index].salesRetail = inputBottle % product.bottlePerBundle;
      products[index].salesBundle = inputBottle ~/ product.bottlePerBundle;
      products[index].totalSalesRetailUnits = inputBottle;
      products[index].totalPriceSales = inputBottle * product.price;

      // Move to next product
      if (index < products.length - 1) {
        setState(() {
          currentItem = products[index + 1];

          retailController.text = currentItem!.totalSalesRetailUnits != -1
              ? currentItem!.totalSalesRetailUnits.toString()
              : '';
        });

        Future.delayed(Duration.zero, () {
          _focusNode.requestFocus();
        });
      } else {
        retailController.clear();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaveLoading = false;
        });
      }
    }
  }
  // Future<void> addSales() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _isSaveLoading = true;
  //     });
  //
  //     int inputBottle = int.parse(retailController.text);
  //     int mobileNumber = int.parse(await _viewDateController.getMobileNumber());
  //     String currentDate = await _viewDateController.getViewDateForUi();
  //
  //     await _salesController.addNewSales(
  //       inputBottle: inputBottle,
  //       currentItem: currentItem!,
  //       mobileNumber: mobileNumber,
  //       currentDate: currentDate,
  //     );
  //
  //     showSuccessToast('Sales Added Successfully');
  //
  //     final index = products.indexWhere((e) => e.id == currentItem!.id);
  //
  //     if (index != -1) {
  //       products[index].salesRetail =
  //           inputBottle % currentItem!.bottlePerBundle;
  //       products[index].salesBundle =
  //           inputBottle ~/ currentItem!.bottlePerBundle;
  //       products[index].totalSalesRetailUnits = inputBottle;
  //       products[index].totalPriceSales = inputBottle * currentItem!.price;
  //
  //       setState(() {});
  //     }
  //
  //     if (index < products.length - 1) {
  //       currentItem = products[index + 1];
  //       retailController.text = products[index + 1].totalSalesRetailUnits != -1
  //           ? products[index + 1].totalSalesRetailUnits.toString()
  //           : '';
  //     }
  //
  //     _focusNode.requestFocus();
  //
  //     setState(() {});
  //
  //     setState(() {
  //       _isSaveLoading = false;
  //     });
  //   }
  // }

  void previousItem() {
    final index = products.indexWhere((e) => e.id == currentItem!.id);

    if (index > 0) {
      currentItem = products[index - 1];

      retailController.text = currentItem!.totalSalesRetailUnits != -1
          ? currentItem!.totalSalesRetailUnits.toString()
          : '';

      setState(() {});
      _focusNode.requestFocus();
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

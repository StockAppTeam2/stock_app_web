import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_app_web/controllers/closing_page_controller.dart';
import 'package:stock_app_web/controllers/opening_page_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/utils/guid_video_links.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';
import 'package:stock_app_web/models/items_table_model.dart';
import 'package:stock_app_web/pages/closing/closing_product_cards.dart';

import '../widgets/toast_popup.dart';

class AddClosingPage extends StatefulWidget {
  const AddClosingPage({super.key});

  @override
  State<AddClosingPage> createState() => _AddClosingPageState();
}

class _AddClosingPageState extends State<AddClosingPage> {
  final _viewDateController = getIt<ViewDateController>();
  final _openingController = getIt<OpeningPageController>();
  final _closingPageController = getIt<ClosingPageController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController bundleController = TextEditingController();
  TextEditingController retailController = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  final FocusNode _bottleFocusNode = FocusNode();

  String viewDate = '';
  String query = '';
  bool _isSaveLoading = false;

  bool _isLoading = true;

  bool startEntry = false;

  List<ItemsViewModel> products = [];
  List<ItemsViewModel> filterData = [];

  ItemsViewModel? currentItem;

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
              title: 'Closing Entry',
              viewDate: viewDate,
              query: (String p1) {
                setState(() {
                  query = p1;
                  updateFuture();
                });
              },
              videoLink: closingVideoLink,
              page: 'add_closing_stock',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '${currentItem!.productId} - ',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${currentItem!.brand} - ',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${currentItem!.range} - ',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${currentItem!.size} - ",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "Rs.${currentItem!.price.toString()}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    color: Colors.black54,
                                    child: Row(
                                      children: [
                                        const Text(
                                          ' Case: ',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.greenAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (currentItem != null)
                                          SizedBox(
                                            width: 40,
                                            child: Text(
                                              '${(currentItem?.actualBundle ?? 0) != -1 ? currentItem!.actualBundle : ''}',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.yellowAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          'Btl: ',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.greenAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (currentItem != null)
                                          SizedBox(
                                            width: 40,
                                            child: Text(
                                              '${(currentItem?.actualRetail ?? 0) != -1 ? currentItem?.actualRetail : ''}',

                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.yellowAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        const Text(
                                          '( ',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.greenAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (currentItem != null)
                                          Text(
                                            '${(currentItem?.totalActualRetailUnits ?? 0) != -1 ? currentItem!.totalActualRetailUnits : ''}',

                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.yellowAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        const Text(
                                          ' )',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.greenAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Form(
                                key: _formKey,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextFormField(
                                        focusNode: _focusNode,
                                        controller: bundleController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]'),
                                          ),
                                        ],
                                        validator: (value) {
                                          final number = int.tryParse(
                                            value ?? '',
                                          );

                                          if (number == null ||
                                              number.isNegative) {
                                            return 'Please Check value';
                                          }

                                          if (number >
                                              currentItem!.actualBundle) {
                                            return 'Please Check Case';
                                          }

                                          return null;
                                        },

                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        decoration: const InputDecoration(
                                          hintText: 'Enter Case',
                                          labelText: 'Case',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                              width: 5.0,
                                            ),
                                          ),
                                        ),
                                        onFieldSubmitted: (_) {
                                          FocusScope.of(
                                            context,
                                          ).requestFocus(_bottleFocusNode);
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        focusNode: _bottleFocusNode,
                                        controller: retailController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]'),
                                          ),
                                        ],
                                        onFieldSubmitted: (v) async {
                                          await addClosing();
                                        },
                                        validator: (value) {
                                          final number = int.tryParse(
                                            value ?? '',
                                          );

                                          if (number == null ||
                                              number.isNegative) {
                                            return 'Please Check value';
                                          }

                                          if (number >
                                              currentItem!
                                                  .totalActualRetailUnits) {
                                            return 'Please Check Bottles';
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
                                  ],
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
                                            await addClosing();
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
                                retailController.text =
                                    currentItem!.closingRetail != -1
                                    ? currentItem!.closingRetail.toString()
                                    : '';
                                bundleController.text =
                                    currentItem!.closingBundle != -1
                                    ? currentItem!.closingBundle.toString()
                                    : '';

                                _focusNode.requestFocus();
                                setState(() {
                                  startEntry = true;
                                });
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
                                        buildTotalCard(
                                          context: context,
                                          item: product,
                                          width: 100,
                                          onEdit: () {
                                            setState(() {
                                              startEntry = true;
                                            });
                                            currentItem = product;

                                            retailController.text =
                                                product.closingRetail != -1
                                                ? product.closingRetail
                                                      .toString()
                                                : '';
                                            bundleController.text =
                                                product.closingBundle != -1
                                                ? product.closingBundle
                                                      .toString()
                                                : '';

                                            _focusNode.requestFocus();

                                            setState(() {});
                                          },
                                          onDelete: () {},
                                          showMenu: true,
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
    // List<ItemsViewModel> data = [];
    // List<ItemsViewModel> data = await _salesController.getSalesData(
    //   value,
    //   shopId,
    // );

    List<ItemsViewModel> data = await _openingController.getOpeningData(
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

  Future<void> addClosing() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaveLoading = true;
      });

      int inputCase = int.parse(bundleController.text);
      int inputBottle = int.parse(retailController.text);
      int mobileNumber = int.parse(await _viewDateController.getMobileNumber());
      String currentDate = await _viewDateController.getViewDateForUi();

      await _closingPageController.addNewClosing(
        inputCase: inputCase,
        inputBottle: inputBottle,
        currentItem: currentItem!,
        mobileNumber: mobileNumber,
        currentDate: currentDate,
      );

      showSuccessToast('Closing Added Successfully');

      final index = products.indexWhere((e) => e.id == currentItem!.id);

      if (index != -1) {
        products[index].closingRetail =
            inputBottle % currentItem!.bottlePerBundle;
        products[index].closingBundle =
            inputBottle ~/ currentItem!.bottlePerBundle;
        products[index].totalCloseRetailUnits = inputBottle;
        products[index].totalPriceClosing = inputBottle * currentItem!.price;

        setState(() {});
      }

      if (index < products.length - 1) {
        currentItem = products[index + 1];
        bundleController.text = products[index + 1].closingBundle != -1
            ? products[index + 1].closingBundle.toString()
            : '';
        retailController.text = products[index + 1].closingRetail != -1
            ? products[index + 1].closingRetail.toString()
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

  void nextField() {
    FocusScope.of(context).requestFocus(_bottleFocusNode);
  }

  void previousItem() {
    final index = products.indexWhere((e) => e.id == currentItem!.id);

    if (index > 0) {
      currentItem = products[index - 1];

      retailController.text = currentItem!.totalCloseRetailUnits != -1
          ? currentItem!.totalCloseRetailUnits.toString()
          : '';

      setState(() {});
      _focusNode.requestFocus();
    }
  }
}

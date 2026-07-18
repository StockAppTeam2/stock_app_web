import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_app_web/controllers/opening_page_controller.dart';
import 'package:stock_app_web/controllers/receipt_controller.dart';
import 'package:stock_app_web/controllers/return_stock_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/Internet_connection_repo.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';
import 'package:stock_app_web/models/items_table_model.dart';
import 'package:stock_app_web/models/return_model.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class ReturnStockPage extends StatefulWidget {
  const ReturnStockPage({super.key});

  @override
  State<ReturnStockPage> createState() => _ReturnStockPageState();
}

class _ReturnStockPageState extends State<ReturnStockPage> {
  final _viewDateController = getIt<ViewDateController>();
  final returnStockController = getIt<ReturnStockController>();
  final _receiptController = getIt<ReceiptController>();
  final _internetConnectionRepo = getIt<InternetConnectionRepo>();
  final _openingController = getIt<OpeningPageController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<DropdownSearchState<ItemsViewModel>> _dropdownKey =
      GlobalKey<DropdownSearchState<ItemsViewModel>>();
  final FocusNode _caseFocusNode = FocusNode();

  TextEditingController bundleController = TextEditingController();
  TextEditingController retailController = TextEditingController();

  ItemsViewModel? selectedData;
  ReturnViewModel? returnStockOld;

  bool enableEdit = false;
  bool saveLoading = false;

  List<ItemsViewModel> currentStock = [];

  // List<ReturnViewModel> returnStock = [];

  String viewDate = '';
  bool isSalesEntered = false;

  @override
  void initState() {
    super.initState();
    getViewDate();
    loadActualData();
    checkSalesEntered();
  }

  void checkSalesEntered() async {
    bool checkTodayClosingExist = await _receiptController.checkClosingNotExist(
      viewDate,
    );

    if (!checkTodayClosingExist) {
      setState(() {
        isSalesEntered = true;
      });
    } else {
      setState(() {
        isSalesEntered = false;
      });
    }
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
              videoLink: '',
              page: 'return_stock',
              invoiceNo: '',
              showReport: true,
            ),

            const SizedBox(height: 20),

            Column(
              children: [
                isSalesEntered
                    ? SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
                          buildDropdownSearch(),
                          const SizedBox(height: 10),
                          selectedData != null
                              ? RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '${selectedData!.productId} - ',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${selectedData!.brand} - ',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${selectedData!.range} - ',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${selectedData!.size} - ",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "Rs.${selectedData!.price.toString()}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Row(
                                  children: [
                                    Text(
                                      'Search The Product Above',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 20),
                          Form(
                            key: _formKey,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextFormField(
                                    focusNode: _caseFocusNode,
                                    controller: bundleController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter(
                                        RegExp(r'[0-9]'),
                                        allow: true,
                                      ),
                                    ],
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          !isNumeric(value)) {
                                        return 'Case Can not BeEmpty';
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (_) async {
                                      // await submit();
                                    },
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Enter Case',
                                      labelText: 'Case',
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          width: 5.0,
                                        ),
                                      ),
                                    ),
                                    onEditingComplete: nextField,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: retailController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter(
                                        RegExp(r'[0-9]'),
                                        allow: true,
                                      ),
                                    ],
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          !isNumeric(value)) {
                                        return 'Bottle Can not Be Empty';
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (_) async {
                                      // await submit();
                                    },
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Enter Bottles',
                                      labelText: 'Bottle',
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          width: 5.0,
                                        ),
                                      ),
                                    ),
                                    onEditingComplete: nextField,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    print('sunbmit clicked start');
                    await submit();
                    print('sunbmit clicked end');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    minimumSize: Size(140, 50),
                  ),
                  child: saveLoading
                      ? CircularProgressIndicator()
                      : Text('Submit'),
                ),
              ],
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
                                              isSalesEntered
                                                  ? SizedBox()
                                                  : PopupMenuButton(
                                                      child: const Icon(
                                                        Icons.more_vert,
                                                        color: Colors.blue,
                                                      ),
                                                      onSelected: (value) async {
                                                        ItemsViewModel?
                                                        item = currentStock
                                                            .where(
                                                              (e) =>
                                                                  e.productId ==
                                                                  product
                                                                      .productId,
                                                            )
                                                            .firstOrNull;
                                                        if (value == 'Edit') {
                                                          setState(() {
                                                            returnStockOld =
                                                                product;

                                                            bundleController
                                                                .text = product
                                                                .returnBundle
                                                                .toString();
                                                            retailController
                                                                .text = product
                                                                .returnRetail
                                                                .toString();

                                                            selectedData = item;
                                                            enableEdit = true;
                                                          });

                                                          await submit();
                                                        } else if (value ==
                                                            'Delete') {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                  'Do You Want to Delete',
                                                                ),
                                                                actionsAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      Navigator.of(
                                                                        context,
                                                                      ).pop();
                                                                    },
                                                                    style: TextButton.styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .blue,
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                    child: Text(
                                                                      'Cancel',
                                                                    ),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed: () async {
                                                                      bool
                                                                      isConnected =
                                                                          await _internetConnectionRepo
                                                                              .checkInternetConnection();

                                                                      if (isConnected) {
                                                                        await returnStockController.deleteReturn(
                                                                          product
                                                                              .productId
                                                                              .toString(),
                                                                          product
                                                                              .date,
                                                                        );
                                                                        setState(() {
                                                                          returnStockOld =
                                                                              product;
                                                                          bundleController.text =
                                                                              '';
                                                                          retailController.text =
                                                                              '';

                                                                          selectedData =
                                                                              null;
                                                                          enableEdit =
                                                                              false;
                                                                        });
                                                                        getReturnStock();

                                                                        loadActualData();

                                                                        setState(
                                                                          () {},
                                                                        );
                                                                        Navigator.of(
                                                                          context,
                                                                        ).pop();
                                                                      } else {
                                                                        showErrorToast(
                                                                          'No Internet Connection',
                                                                        );
                                                                      }
                                                                    },
                                                                    style: TextButton.styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                    child: Text(
                                                                      'Ok',
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        }
                                                      },
                                                      itemBuilder:
                                                          (
                                                            BuildContext
                                                            context,
                                                          ) => <PopupMenuEntry>[
                                                            PopupMenuItem(
                                                              value: 'Edit',
                                                              child: Row(
                                                                children: [
                                                                  const Expanded(
                                                                    child: Icon(
                                                                      Icons
                                                                          .edit,
                                                                      color: Colors
                                                                          .green,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      'Edit',
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            PopupMenuItem(
                                                              value: 'Delete',
                                                              child: Row(
                                                                children: [
                                                                  const Expanded(
                                                                    child: Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      'Delete',
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                    ),
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
    String shopId = await getIt<ShopIdController>().getShopId();

    List<ReturnViewModel> returnStock = await returnStockController
        .getAllReturnStock(shopId, value);
    print('returnStock: $returnStock');
    return returnStock;
  }

  DropdownSearch<ItemsViewModel> buildDropdownSearch() {
    return DropdownSearch<ItemsViewModel>(
      key: _dropdownKey,
      items: currentStock,
      popupProps: PopupProps.dialog(
        showSelectedItems: false,
        showSearchBox: true,
        searchFieldProps: const TextFieldProps(
          autofocus: true,
          keyboardType: TextInputType.text,
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Select a Item'),
        ),
      ),
      itemAsString: (ItemsViewModel product) =>
          "${product.productId} - ${product.brand} - ${product.size} - Rs.${product.price}",
      onChanged: (ItemsViewModel? product) async {
        setState(() {
          // bundleController.text = isAlreadyExist.returnBundle.toString();
          // retailController.text = isAlreadyExist.returnRetail.toString();
          selectedData = product;
          enableEdit = true;
        });
        FocusScope.of(context).requestFocus(_caseFocusNode);
      },
      selectedItem: selectedData,
      dropdownButtonProps: const DropdownButtonProps(icon: Icon(Icons.search)),
    );
  }

  bool isNumeric(String value) {
    return int.tryParse(value) != null;
  }

  void nextField() {
    FocusScope.of(context).nextFocus();
  }

  Future<void> loadActualData() async {
    String value = await _viewDateController.getViewDateForUi();
    String shopId = await getIt<ShopIdController>().getShopId();

    List<ItemsViewModel> itemData = await _openingController.getOpeningData(
      value,
      shopId,
    );

    setState(() {
      currentStock = itemData;
    });
  }

  Future<void> submit() async {
    if (_formKey.currentState!.validate()) {
      int returnBundle = int.parse(bundleController.text);
      int returnRetail = int.parse(retailController.text);
      int totalReturnRetailUnits =
          (returnBundle * selectedData!.bottlePerBundle) + returnRetail;
      int totalPriceReturn = totalReturnRetailUnits * selectedData!.price;

      ReturnModel returnModel = ReturnModel(
        productId: selectedData!.productId,
        phoneNumber: selectedData!.phoneNumber,
        date: selectedData!.date,
        time: selectedData!.time,
        returnBundle: returnBundle,
        returnRetail: returnRetail,
        totalReturnRetailUnits: totalReturnRetailUnits,
        totalPriceReturn: totalPriceReturn,
        isSynced: 1,
      );

      await returnStockController.addReturnStock(returnModel);
    }
  }
}

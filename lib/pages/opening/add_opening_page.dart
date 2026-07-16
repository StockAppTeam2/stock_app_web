import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_app_web/controllers/opening_page_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';
import 'package:stock_app_web/models/brand_model.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class AddOpeningPage extends StatefulWidget {
  const AddOpeningPage({super.key});

  @override
  State<AddOpeningPage> createState() => _AddOpeningPageState();
}

class _AddOpeningPageState extends State<AddOpeningPage> {
  final _viewDateController = getIt<ViewDateController>();
  final _openingController = getIt<OpeningPageController>();

  TextEditingController bundleController = TextEditingController();
  TextEditingController retailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<DropdownSearchState<BrandModel>> _dropdownKey =
      GlobalKey<DropdownSearchState<BrandModel>>();
  final FocusNode _bottleFocusNode = FocusNode();

  late Future<List<BrandModel>> _future;

  BrandModel? selectedDropdownProduct;
  String viewDate = '';
  bool _isSaveLoading = false;

  @override
  void initState() {
    super.initState();
    getViewDate();
    _future = getActiveBrands();
  }

  @override
  void dispose() {
    bundleController.clear();
    retailController.clear();
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
              title: 'FIRST OPENING',
              viewDate: viewDate,
              query: (String p1) {},
              videoLink: '',
              page: 'add_opening_stock',
              invoiceNo: '',
              showReport: false,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<List<BrandModel>>(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownSearch<BrandModel>(
                        key: _dropdownKey,
                        items: products,
                        popupProps: const PopupProps.dialog(
                          showSelectedItems: false,
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            autofocus: true,
                            keyboardType: TextInputType.text,
                          ),
                          title: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Select A Item'),
                          ),
                        ),
                        itemAsString: (BrandModel product) =>
                            "${product.productId} - ${product.brand} - ${product.size} - Rs.${product.price}",
                        onChanged: (BrandModel? product) async {
                          setState(() {
                            selectedDropdownProduct = product;
                          });

                          debugPrint(
                            'selectedDropdownProduct ${selectedDropdownProduct!.toMap()}',
                          );
                          bundleController.text = '0';
                          retailController.text = '';
                          if (context.mounted) {
                            FocusScope.of(
                              context,
                            ).requestFocus(_bottleFocusNode);
                          }
                        },
                        selectedItem: selectedDropdownProduct,
                        dropdownButtonProps: const DropdownButtonProps(
                          icon: Icon(Icons.search),
                        ),
                      ),
                      const SizedBox(height: 10),
                      selectedDropdownProduct != null
                          ? RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        '${selectedDropdownProduct!.productId} - ',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '${selectedDropdownProduct!.brand} - ',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '${selectedDropdownProduct!.range} - ',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${selectedDropdownProduct!.size} - ",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "Rs.${selectedDropdownProduct!.price.toString()}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const Text(
                              'Search the product above',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                      const SizedBox(height: 10),
                      Form(
                        key: _formKey,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: bundleController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]'),
                                  ),
                                ],
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      !isNumeric(value)) {
                                    return 'Case Con\'t Be Empty';
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
                                onEditingComplete: nextField,
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
                                  await addProduct();
                                },
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            fixedSize: Size(160, 40),
                          ),
                          onPressed: _isSaveLoading
                              ? null
                              : () async {
                                  await addProduct();
                                },
                          child: _isSaveLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('Save'),
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

  Future<List<BrandModel>> getActiveBrands() async {
    List<BrandModel> brandProduct = await _openingController.getActiveBrands();
    print('brandProduct: ${brandProduct.length}');
    return brandProduct;
  }

  bool isNumeric(String value) {
    return int.tryParse(value) != null;
  }

  void nextField() {
    FocusScope.of(context).nextFocus();
  }

  Future<void> addProduct() async {
    if (selectedDropdownProduct != null) {
      setState(() {
        _isSaveLoading = true;
      });

      if (_formKey.currentState!.validate()) {
        int inputCase = int.parse(bundleController.text);
        int inputBottle = int.parse(retailController.text);
        int bottlePerBundle = selectedDropdownProduct!.bottlePerBundle;
        int price = selectedDropdownProduct!.price;
        int productId = selectedDropdownProduct!.productId;

        int mobileNumber = int.parse(
          await _viewDateController.getMobileNumber(),
        );

        //add opening and sales
        await _openingController.addNewOpening(
          inputCase: inputCase,
          inputBottle: inputBottle,
          bottlePerBundle: bottlePerBundle,
          price: price,
          productId: productId,
          mobileNumber: mobileNumber,
        );

        //set first opening status
        showSuccessToast('Item Added Successfully');
        _dropdownKey.currentState?.openDropDownSearch();
      }
      setState(() {
        selectedDropdownProduct = null;
        bundleController.clear();
        retailController.clear();
        _isSaveLoading = false;
      });
    } else {
      showErrorToast('Please Select a Item');
      setState(() {
        _isSaveLoading = false;
      });
    }
  }
}

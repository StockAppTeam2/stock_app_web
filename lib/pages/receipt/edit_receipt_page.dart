import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_app_web/controllers/receipt_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';
import 'package:stock_app_web/models/brand_model.dart';
import 'package:stock_app_web/models/inward_table_model.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class EditReceiptPage extends StatefulWidget {
  final InwardViewModel product;

  const EditReceiptPage({super.key, required this.product});

  @override
  State<EditReceiptPage> createState() => _EditReceiptPageState();
}

class _EditReceiptPageState extends State<EditReceiptPage> {
  final _receiptController = getIt<ReceiptController>();

  TextEditingController bundleController = TextEditingController();
  TextEditingController retailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<DropdownSearchState<BrandModel>> _dropdownKey =
      GlobalKey<DropdownSearchState<BrandModel>>();
  final FocusNode _bottleFocusNode = FocusNode();

  bool _isSaveLoading = false;

  @override
  void initState() {
    super.initState();

    bundleController.text = widget.product.inwardBundle.toString();
    retailController.text = widget.product.inwardRetail.toString();
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
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              PageHeader(
                title: 'EDIT PURCHASE',
                viewDate: '',
                query: (String p1) {},
                videoLink: '',
                page: 'edit_purchase_stock',
                invoiceNo: '',
                showReport: false,
              ),

              const SizedBox(height: 10),

              Column(
                children: [
                  buildInfoRow(
                    title: 'Invoice No',
                    child: buildValueBox(widget.product.invoiceNo),
                  ),

                  buildInfoRow(
                    title: 'Invoice Date',
                    child: buildValueBox(
                      widget.product.date,
                      trailing: const Icon(Icons.calendar_today),
                    ),
                  ),

                  buildInfoRow(
                    title: 'Brand',
                    child: buildValueBox(
                      "${widget.product.productId} - ${widget.product.brand} - Rs.${widget.product.price}",
                    ),
                  ),

                  buildInfoRow(
                    title: 'Group',
                    child: buildValueBox(widget.product.inwardGroup),
                  ),

                  buildInfoRow(
                    title: 'Range',
                    child: buildValueBox(widget.product.range),
                  ),

                  buildInfoRow(
                    title: 'Size',
                    child: buildValueBox(widget.product.size),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: bundleController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                    ],
                  ),

                  SizedBox(height: 30),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      fixedSize: Size(160, 40),
                    ),
                    onPressed: _isSaveLoading
                        ? null
                        : () async {
                            await editProduct();
                          },
                    child: _isSaveLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Edit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> editProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaveLoading = true;
      });
      int inputCase = int.parse(bundleController.text);
      int inputBottle = int.parse(retailController.text);

      await _receiptController.editReceipt(
        inputCase: inputCase,
        inputBottle: inputBottle,
        model: widget.product,
      );
      showSuccessToast('Item Edited Successfully');
      setState(() {
        _isSaveLoading = false;
      });
    }
  }

  bool isNumeric(String value) {
    return int.tryParse(value) != null;
  }

  void nextField() {
    FocusScope.of(context).nextFocus();
  }

  Widget buildInfoRow({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text(title, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 16),
          Expanded(flex: 6, child: child),
        ],
      ),
    );
  }

  Widget buildValueBox(String value, {Widget? trailing}) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(child: Text(value, style: const TextStyle(fontSize: 18))),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  // getViewDate();
  // selectedItem();
  // _future = getActiveBrands();
  // late Future<List<BrandModel>> _future;

  // BrandModel? selectedDropdownProduct;
  // String viewDate = '';

  // Expanded(
  //   child: FutureBuilder<List<BrandModel>>(
  //     future: _future,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       }
  //
  //       if (snapshot.hasError) {
  //         return Center(child: Text(snapshot.error.toString()));
  //       }
  //
  //       final products = snapshot.data ?? [];
  //
  //       if (products.isEmpty) {
  //         return const Center(child: Text("No Data Found"));
  //       }
  //
  //       return Column(
  //         children: [
  //           buildInfoRow(
  //             title: 'Invoice No',
  //             child: buildValueBox(widget.product.invoiceNo),
  //           ),
  //
  //           buildInfoRow(
  //             title: 'Invoice Date',
  //             child: buildValueBox(
  //               widget.product.date,
  //               trailing: const Icon(Icons.calendar_today),
  //             ),
  //           ),
  //
  //           buildInfoRow(
  //             title: 'Brand',
  //             child: buildDropdownSearch(products, context),
  //           ),
  //
  //           buildInfoRow(
  //             title: 'Group',
  //             child: buildValueBox(widget.product.inwardGroup),
  //           ),
  //
  //           buildInfoRow(
  //             title: 'Range',
  //             child: buildValueBox(widget.product.range),
  //           ),
  //
  //           buildInfoRow(
  //             title: 'Size',
  //             child: buildValueBox(widget.product.size),
  //           ),
  //
  //           const SizedBox(height: 20),
  //
  //           Row(
  //             children: <Widget>[
  //               Expanded(
  //                 child: TextFormField(
  //                   controller: bundleController,
  //                   keyboardType: TextInputType.number,
  //                   inputFormatters: [
  //                     FilteringTextInputFormatter.allow(
  //                       RegExp(r'[0-9]'),
  //                     ),
  //                   ],
  //                   validator: (value) {
  //                     if (value == null ||
  //                         value.isEmpty ||
  //                         !isNumeric(value)) {
  //                       return 'Case Con\'t Be Empty';
  //                     }
  //                     return null;
  //                   },
  //
  //                   style: const TextStyle(
  //                     color: Colors.red,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                   decoration: const InputDecoration(
  //                     hintText: 'Enter Case',
  //                     labelText: 'Case',
  //                     border: OutlineInputBorder(
  //                       borderSide: BorderSide(
  //                         color: Colors.red,
  //                         width: 5.0,
  //                       ),
  //                     ),
  //                   ),
  //                   onEditingComplete: nextField,
  //                 ),
  //               ),
  //               const SizedBox(width: 10),
  //               Expanded(
  //                 child: TextFormField(
  //                   focusNode: _bottleFocusNode,
  //                   controller: retailController,
  //                   keyboardType: TextInputType.number,
  //                   inputFormatters: [
  //                     FilteringTextInputFormatter.allow(
  //                       RegExp(r'[0-9]'),
  //                     ),
  //                   ],
  //                   validator: (value) {
  //                     if (value == null ||
  //                         value.isEmpty ||
  //                         !isNumeric(value)) {
  //                       return 'Bottles Con\'t Be Empty';
  //                     }
  //                     return null;
  //                   },
  //
  //                   style: const TextStyle(
  //                     color: Colors.red,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                   decoration: const InputDecoration(
  //                     hintText: 'Enter Bottles',
  //                     labelText: 'Bottles',
  //                     border: OutlineInputBorder(
  //                       borderSide: BorderSide(
  //                         color: Colors.red,
  //                         width: 5.0,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //
  //           SizedBox(height: 30),
  //
  //           ElevatedButton(
  //             onPressed: editProduct,
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.green,
  //               foregroundColor: Colors.white,
  //               fixedSize: Size(160, 40),
  //             ),
  //             child: Text('Edit'),
  //           ),
  //         ],
  //       );
  //     },
  //   ),
  // ),

  // void getViewDate() async {
  //   String value = await _viewDateController.getViewDateForUi();
  //   if (mounted) {
  //     setState(() => viewDate = value);
  //   }
  // }

  // Future<List<BrandModel>> getActiveBrands() async {
  //   List<BrandModel> brandProduct = await _receiptController.getActiveBrands();
  //   print('brandProduct: ${brandProduct.length}');
  //   return brandProduct;
  // }

  // void selectedItem() {
  //   BrandModel brandModel = BrandModel(
  //     date: widget.product.date,
  //     time: widget.product.time,
  //     productId: widget.product.productId,
  //     brand: widget.product.brand,
  //     category: widget.product.category,
  //     size: widget.product.size,
  //     groups: widget.product.inwardGroup,
  //     range: widget.product.range,
  //     price: widget.product.price,
  //     bottlePerBundle: widget.product.bottlePerBundle,
  //     isSynced: widget.product.isSynced,
  //     isActive: 0,
  //     buyingPrice: 0,
  //   );
  //   setState(() {
  //     selectedDropdownProduct = brandModel;
  //   });
  // }

  // Future<void> editProduct() async {
  //   // check product exist
  //   if (selectedDropdownProduct != null) {
  //     String currentDate = await _viewDateController.getViewDateForUi();
  //
  //     if (_formKey.currentState!.validate()) {
  //       setState(() {
  //         _isSaveLoading = true;
  //       });
  //       int inputCase = int.parse(bundleController.text);
  //       int inputBottle = int.parse(retailController.text);
  //       int bottlePerBundle = selectedDropdownProduct!.bottlePerBundle;
  //       int price = selectedDropdownProduct!.price;
  //       int produceId = selectedDropdownProduct!.productId;
  //
  //       int mobileNumber = int.parse(
  //         await _viewDateController.getMobileNumber(),
  //       );
  //
  //       //add opening and sales
  //       await _receiptController.addNewReceipt(
  //         inputCase: inputCase,
  //         inputBottle: inputBottle,
  //       );
  //
  //       //set first opening status
  //       showSuccessToast('Item Added Successfully');
  //       _dropdownKey.currentState?.openDropDownSearch();
  //       setState(() {
  //         selectedDropdownProduct = null;
  //         bundleController.clear();
  //         retailController.clear();
  //         _isSaveLoading = false;
  //       });
  //     }
  //   } else {
  //     showErrorToast('Please Select a Item');
  //     setState(() {
  //       _isSaveLoading = false;
  //     });
  //   }
  // }

  // DropdownSearch<BrandModel> buildDropdownSearch(
  //   List<BrandModel> products,
  //   BuildContext context,
  // ) {
  //   return DropdownSearch<BrandModel>(
  //     key: _dropdownKey,
  //     items: products,
  //     popupProps: const PopupProps.dialog(
  //       showSelectedItems: false,
  //       showSearchBox: true,
  //       searchFieldProps: TextFieldProps(
  //         autofocus: true,
  //         keyboardType: TextInputType.text,
  //       ),
  //     ),
  //     itemAsString: (BrandModel product) =>
  //         "${product.productId} - ${product.brand} - ${product.size} - Rs.${product.price}",
  //     onChanged: (BrandModel? product) async {
  //       setState(() {
  //         selectedDropdownProduct = product;
  //       });
  //
  //       debugPrint(
  //         'selectedDropdownProduct ${selectedDropdownProduct!.toMap()}',
  //       );
  //       bundleController.text = '';
  //       retailController.text = '';
  //       if (context.mounted) {
  //         FocusScope.of(context).requestFocus(_bottleFocusNode);
  //       }
  //     },
  //
  //     selectedItem: selectedDropdownProduct,
  //     dropdownButtonProps: const DropdownButtonProps(icon: Icon(Icons.search)),
  //   );
  // }
}

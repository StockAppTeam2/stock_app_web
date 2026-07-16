import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stock_app_web/controllers/brand_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';
import 'package:stock_app_web/models/brand_model.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class EditBrandPage extends StatefulWidget {
  final BrandModel brandModel;
  const EditBrandPage({super.key, required this.brandModel});

  @override
  State<EditBrandPage> createState() => _EditBrandPageState();
}

class _EditBrandPageState extends State<EditBrandPage> {
  final _brandController = getIt<BrandController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController productIdController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController bundleUnitController = TextEditingController();

  List<BrandModel> allBrands = [];

  List<String> allRange = [];
  List<String> allSize = [];
  List<String> allCategory = [];
  List<String> allGroup = [];

  String selectedRangeValue = '';
  String selectedSizeValue = '';
  String selectedCategoryValue = '';
  String selectedGroupValue = '';

  String? rangeError;
  String? sizeError;
  String? categoryError;
  String? groupError;

  int brandLength = 0;

  bool _isSaveLoading = false;

  @override
  void initState() {
    super.initState();
    loadBrandData();
    setState(() {
      productIdController.text = widget.brandModel.productId.toString();
      brandController.text = widget.brandModel.brand;
      priceController.text = widget.brandModel.price.toString();
      bundleUnitController.text = widget.brandModel.bottlePerBundle.toString();
      selectedRangeValue = widget.brandModel.range;
      selectedSizeValue = widget.brandModel.size;
      selectedCategoryValue = widget.brandModel.category;
      selectedGroupValue = widget.brandModel.groups;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            PageHeader(
              title: 'EDIT BRAND',
              viewDate: '',
              query: (String query) {},
              videoLink: '',
              page: 'edit_brand_stock',
              invoiceNo: '',
              showReport: false,
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 3),

                    Table(
                      columnWidths: const {
                        0: IntrinsicColumnWidth(),
                        1: FixedColumnWidth(15),
                        2: FlexColumnWidth(),
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        _tableRow(
                          title: 'Product ID',
                          child: TextFormField(
                            controller: productIdController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                        _tableRow(
                          title: 'Brand',
                          child: TextFormField(
                            controller: brandController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9 ]'),
                              ),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Brand Can\'t Be Empty';
                              }
                              return null;
                            },
                            onEditingComplete: nextField,
                            decoration: const InputDecoration(
                              hintText: 'Enter Brand',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                        _tableRow(
                          title: 'Group',
                          child: _buildDropdown(
                            value: selectedGroupValue,
                            items: allGroup,
                            error: groupError,
                            onChanged: (value) {
                              setState(() {
                                selectedGroupValue = value ?? '';
                                groupError = null;
                              });
                            },
                          ),
                        ),
                        _tableRow(
                          title: 'Range',
                          child: _buildDropdown(
                            value: selectedRangeValue,
                            items: allRange,
                            error: rangeError,
                            onChanged: (value) {
                              setState(() {
                                selectedRangeValue = value ?? '';
                                rangeError = null;
                              });
                            },
                          ),
                        ),
                        _tableRow(
                          title: 'Category',
                          child: _buildDropdown(
                            value: selectedCategoryValue,
                            items: allCategory,
                            error: categoryError,
                            onChanged: (value) {
                              setState(() {
                                selectedCategoryValue = value ?? '';
                                categoryError = null;
                              });
                            },
                          ),
                        ),
                        _tableRow(
                          title: 'Size',
                          child: _buildDropdown(
                            value: selectedSizeValue,
                            items: allSize,
                            error: sizeError,
                            onChanged: (value) {
                              setState(() {
                                selectedSizeValue = value ?? '';
                                sizeError = null;
                              });
                            },
                          ),
                        ),
                        _tableRow(
                          title: 'Price',
                          child: TextFormField(
                            controller: priceController,
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
                                return 'Enter a Number';
                              }
                              return null;
                            },
                            onEditingComplete: nextField,
                            decoration: const InputDecoration(
                              hintText: 'Enter Price',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                        _tableRow(
                          title: 'Bottle / Case',
                          child: TextFormField(
                            readOnly: true,
                            controller: bundleUnitController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _isSaveLoading
                              ? null
                              : () async {
                                  await editBrand(context);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            fixedSize: Size(160, 40),
                          ),
                          child: _isSaveLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text('EDIT'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> editBrand(BuildContext context) async {
    if (_formKey.currentState!.validate() && validateDropdowns()) {
      setState(() {
        _isSaveLoading = true;
      });
      int productId = int.tryParse(productIdController.text) ?? 0;
      String brand = brandController.text.trim();
      int price = int.tryParse(priceController.text) ?? 0;
      int bottlePerBundle = int.tryParse(bundleUnitController.text) ?? 0;

      String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      String currentDate = DateTime.now().toString().substring(0, 10);

      BrandModel brandModel = BrandModel(
        id: brandLength + 1,
        date: currentDate,
        time: currentTime,
        productId: productId,
        brand: brand,
        category: selectedCategoryValue,
        size: selectedSizeValue,
        groups: selectedGroupValue,
        range: selectedRangeValue,
        price: price,
        bottlePerBundle: bottlePerBundle,
        isSynced: 1,
        isActive: 0,
        buyingPrice: 0,
      );

      if (price != widget.brandModel.price) {
        print('price changed');
        try {
          // update price all tables also brand
          await _brandController.editAllTableData(
            productId.toString(),
            brandModel,
          );
        } catch (e, stack) {
          debugPrint('ERROR: $e');
          debugPrintStack(stackTrace: stack);
          setState(() {
            _isSaveLoading = false;
          });
        }
      } else {
        // update and add same code
        await _brandController.addNewBrand(productId.toString(), brandModel);
      }
      setState(() {
        _isSaveLoading = false;
      });

      showSuccessToast('Item Edited Successfully');

      String shopId = await getIt<ShopIdController>().getShopId();
      if (context.mounted) {
        context.go('/$shopId/${AppRoutes.brandStock}');
      }
    }
  }

  bool isProductIdExists(String productId) {
    return allBrands.any((brand) => brand.productId.toString() == productId);
  }

  Future<void> loadBrandData() async {
    List<BrandModel> brandData = await _brandController.loadBrands();

    allBrands = brandData;
    brandLength = brandData.length;

    allGroup =
        brandData
            .map((e) => e.groups.toString())
            .where((e) => e.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    allRange =
        brandData
            .map((e) => e.range.toString())
            .where((e) => e.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    allCategory =
        brandData
            .map((e) => e.category.toString())
            .where((e) => e.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    allSize =
        brandData
            .map((e) => e.size.toString())
            .where((e) => e.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    setState(() {});
  }

  bool isNumeric(String value) {
    return int.tryParse(value) != null;
  }

  void nextField() {
    FocusScope.of(context).nextFocus();
  }

  bool isGreaterThenZero(String value) {
    int? input = int.tryParse(value);
    return input! > 0;
  }

  TableRow _tableRow({required String title, required Widget child}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            ':',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: child),
      ],
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? error,
  }) {
    return DropdownButtonFormField<String>(
      value: value.isEmpty ? null : value,
      decoration: InputDecoration(
        hintText: 'Select an item',
        errorText: error,
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: error == null ? Colors.grey : Colors.red,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: error == null ? Colors.blue : Colors.red,
            width: 2,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }

  bool validateDropdowns() {
    setState(() {
      groupError = selectedGroupValue.isEmpty ? 'Please select Group' : null;

      rangeError = selectedRangeValue.isEmpty ? 'Please select Range' : null;

      categoryError = selectedCategoryValue.isEmpty
          ? 'Please select Category'
          : null;

      sizeError = selectedSizeValue.isEmpty ? 'Please select Size' : null;
    });

    return groupError == null &&
        rangeError == null &&
        categoryError == null &&
        sizeError == null;
  }
}

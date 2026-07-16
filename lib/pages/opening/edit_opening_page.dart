import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_app_web/controllers/opening_page_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/models/items_table_model.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class EditOpeningPage extends StatefulWidget {
  final ItemsViewModel editItem;

  const EditOpeningPage({super.key, required this.editItem});

  @override
  State<EditOpeningPage> createState() => _EditOpeningPageState();
}

class _EditOpeningPageState extends State<EditOpeningPage> {
  final _viewDateController = getIt<ViewDateController>();
  final _openingController = getIt<OpeningPageController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController bundleController = TextEditingController();
  TextEditingController retailController = TextEditingController();

  bool _isSaveLoading = false;

  @override
  void initState() {
    super.initState();

    bundleController.text = widget.editItem.openingBundle.toString();
    retailController.text = widget.editItem.openingRetail.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    'Brand Code No',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        '${widget.editItem.productId}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    'Brand',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        widget.editItem.brand,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    'Group',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        widget.editItem.itemsGroup,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    'Range',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        widget.editItem.range,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    'Size',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        widget.editItem.size,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    'Price',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Rs.${widget.editItem.price}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Expanded(
                  child: Text(
                    'Case',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Bottle',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Row(
                children: [
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
                          return 'Case Can not Be Empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Case',
                        labelText: 'Case',
                        border: const OutlineInputBorder(),
                      ),
                      onEditingComplete: nextField,
                    ),
                  ),
                  const SizedBox(width: 8),
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
                          return 'bottle';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Bottles',
                        labelText: 'Bottle',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    fixedSize: Size(160, 40),
                  ),
                  onPressed: _isSaveLoading
                      ? null
                      : () async {
                          await _editProduct(context);
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
    );
  }

  bool isNumeric(String value) {
    return int.tryParse(value) != null;
  }

  void nextField() {
    FocusScope.of(context).nextFocus();
  }

  Future<void> _editProduct(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaveLoading = true;
      });
      int inputCase = int.parse(bundleController.text);
      int inputBottle = int.parse(retailController.text);

      int mobileNumber = int.parse(await _viewDateController.getMobileNumber());

      //add opening and sales
      await _openingController.editOpening(
        inputCase: inputCase,
        inputBottle: inputBottle,
        mobileNumber: mobileNumber,
        product: widget.editItem,
      );

      //set first opening status
      showSuccessToast('Item Edited Successfully');
    }
    setState(() {
      bundleController.clear();
      retailController.clear();
      _isSaveLoading = false;
    });

    String shopId = await getIt<ShopIdController>().getShopId();
    if (!context.mounted) return;
    context.go('/$shopId/${AppRoutes.openingStock}');
  }
}

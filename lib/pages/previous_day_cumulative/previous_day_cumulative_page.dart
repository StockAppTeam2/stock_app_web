import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stock_app_web/controllers/previous_day_cumulative_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/core/repositories/Internet_connection_repo.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

import '../../core/locator/service_locator.dart';

class PreviousDayCumulativePage extends StatefulWidget {
  const PreviousDayCumulativePage({super.key});

  @override
  State<PreviousDayCumulativePage> createState() =>
      _PreviousDayCumulativePageState();
}

class _PreviousDayCumulativePageState extends State<PreviousDayCumulativePage> {
  final _internetConnectionRepo = getIt<InternetConnectionRepo>();
  final _previousDayCumulativeController =
      getIt<PreviousDayCumulativeController>();
  final _cacheRepository = getIt<CacheRepository>();

  final _formKey = GlobalKey<FormState>();

  final _dateController = TextEditingController();
  final _openingController = TextEditingController();
  final _salesController = TextEditingController();
  final _salesImflController = TextEditingController();
  final _salesBeerController = TextEditingController();
  final _receiptController = TextEditingController();
  final _closingController = TextEditingController();

  bool? isManager;

  String? _openingHelperText;
  String? _salesHelperText;
  String? _receiptHelperText;
  String? _closingHelperText;

  bool enableStatus = true;

  @override
  void initState() {
    super.initState();

    getCumulativeValues();
  }

  Future<void> getCumulativeValues() async {
    List<dynamic> data = await _previousDayCumulativeController
        .getAdjustmentValues();

    setState(() {
      _dateController.text = data[0];
      _openingController.text = data[1];
      _salesController.text = data[2];
      _salesImflController.text = data[3];
      _salesBeerController.text = data[4];
      _receiptController.text = data[5];
      _closingController.text = data[6];
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: ListView(
        children: [
          SizedBox(height: 20),
          Text(
            "NOTE : If your 'FIRST OPENING' is not on the 1st of the month, fill out this form.",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'First Opening Date',
                      helperText: 'Choose the first opening date.',
                      labelStyle: const TextStyle(
                        color: Colors.blue,
                        fontSize: 17,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000), // Start date
                            lastDate: DateTime(2100), // End date
                          );
                          if (pickedDate != null) {
                            // Format the picked date in the desired format (DD/MM/YYYY)
                            String formattedDate = DateFormat(
                              'dd/MM/yyyy',
                            ).format(pickedDate);

                            // Update the date field and other logic
                            setState(() {
                              _dateController.text = formattedDate;

                              // Update the helper text for the Opening Value field
                              if (pickedDate.day == 1) {
                                // Clear helper texts if it's the first day of the month
                                _openingHelperText = "";
                                _salesHelperText = "";
                                _receiptHelperText = "";
                                _closingHelperText = "";
                                _openingController.text = '0';
                                _salesController.text = '0';
                                _salesImflController.text = '0';
                                _salesBeerController.text = '0';
                                _receiptController.text = '0';
                                _closingController.text = '0';
                                enableStatus = false;
                              } else {
                                // Field enable
                                enableStatus = true;

                                _openingController.text = '0';
                                _salesController.text = '0';
                                _salesImflController.text = '0';
                                _salesBeerController.text = '0';
                                _receiptController.text = '0';
                                _closingController.text = '0';

                                // Format the first day of the month as DD/MM/YYYY
                                String firstDayOfMonth =
                                    DateFormat('dd/MM/yyyy').format(
                                      DateTime(
                                        pickedDate.year,
                                        pickedDate.month,
                                        1,
                                      ),
                                    );

                                // Format the day before the picked date as DD/MM/YYYY
                                String previousDay = DateFormat('dd/MM/yyyy')
                                    .format(
                                      pickedDate.subtract(Duration(days: 1)),
                                    );

                                // Update the helper text for other dates
                                _openingHelperText =
                                    "Enter $firstDayOfMonth Date OPENING VALUE";
                                _salesHelperText =
                                    "Enter $firstDayOfMonth to $previousDay Date SALES CUMULATIVE";
                                _receiptHelperText =
                                    "Enter $firstDayOfMonth to $previousDay Date RECEIPT CUMULATIVE";
                                _closingHelperText =
                                    "Enter $previousDay Date CLOSING VALUE";
                              }
                            });
                          }
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please choose first opening date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Opening Cumulative Field
                  TextFormField(
                    controller: _openingController,
                    enabled: enableStatus,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Opening Value',
                      helperText: _openingHelperText,
                      labelStyle: const TextStyle(
                        color: Colors.blue,
                        fontSize: 17,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      // border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the opening value';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  // Receipt Cumulative Field
                  TextFormField(
                    controller: _receiptController,
                    enabled: enableStatus,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Receipt Cumulative',
                      helperText: _receiptHelperText,
                      labelStyle: const TextStyle(
                        color: Colors.blue,
                        fontSize: 17,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the receipt cumulative value';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  // Closing Values Field
                  TextFormField(
                    controller: _closingController,
                    enabled: enableStatus,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Closing Values',
                      helperText: _closingHelperText,
                      labelStyle: const TextStyle(
                        color: Colors.blue,
                        fontSize: 17,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the closing values';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  // Sales Cumulative Imfl cases
                  TextFormField(
                    controller: _salesImflController,
                    enabled: enableStatus,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Sales Cumulative IMFL Cases',
                      helperText: _salesHelperText,
                      labelStyle: const TextStyle(
                        color: Colors.blue,
                        fontSize: 17,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the sales cumulative IMFL Cases';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  // Sales Cumulative beer cases
                  TextFormField(
                    controller: _salesBeerController,
                    enabled: enableStatus,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Sales Cumulative BEER Cases',
                      helperText: _salesHelperText,
                      labelStyle: const TextStyle(
                        color: Colors.blue,
                        fontSize: 17,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the sales cumulative BEER Cases';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  // Sales Cumulative Field
                  TextFormField(
                    controller: _salesController,
                    enabled: enableStatus,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Sales Cumulative Value',
                      helperText: _salesHelperText,
                      labelStyle: const TextStyle(
                        color: Colors.blue,
                        fontSize: 17,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the sales cumulative value';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  // Submit Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          bool isConnected = await _internetConnectionRepo
                              .checkInternetConnection();

                          if (isConnected) {
                            if (_formKey.currentState!.validate()) {
                              await _previousDayCumulativeController
                                  .createAdjustmentValues(
                                    _dateController.text,
                                    _openingController.text,
                                    _salesController.text,
                                    _receiptController.text,
                                    _closingController.text,
                                    _salesImflController.text,
                                    _salesBeerController.text,
                                  );

                              String salesValue = _salesController.text;
                              String salesImflCase = _salesImflController.text;
                              String salesBeerCase = _salesBeerController.text;
                              String firstOpDate = _dateController.text;
                              List<String> salesCumulativeAdjustmentData = [
                                firstOpDate,
                                salesValue,
                                salesImflCase,
                                salesBeerCase,
                              ];

                              // await preferences.setStringList(
                              // 'form49SalesCumulativeAdjustment',
                              // salesCumulativeAdjustmentData,
                              // );

                              await _cacheRepository
                                  .addStringCacheLocalAndFirebase(
                                    'form49SalesCumulativeAdjustment',
                                    jsonEncode(salesCumulativeAdjustmentData),
                                  );
                              showSuccessToast(
                                'Cumulative updated successful.',
                              );

                              String shopId = await getIt<ShopIdController>()
                                  .getShopId();
                              if (!context.mounted) return;
                              context.go('/$shopId/${AppRoutes.form49}');
                            }
                          } else {
                            showErrorToast('No Internet Connection');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue, // Button background color
                          foregroundColor: Colors.white, // Text color
                          shadowColor: Colors.black, // Shadow color
                          elevation: 5, // Shadow elevation
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              15,
                            ), // Rounded corners
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

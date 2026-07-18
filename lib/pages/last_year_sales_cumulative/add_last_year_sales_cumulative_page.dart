import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_app_web/controllers/last_year_sales_cumulative_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/Internet_connection_repo.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/models/previous_year_sales_cumulative.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class AddLastYearSalesCumulativePage extends StatefulWidget {
  const AddLastYearSalesCumulativePage({super.key});

  @override
  State<AddLastYearSalesCumulativePage> createState() =>
      _AddLastYearSalesCumulativePageState();
}

class _AddLastYearSalesCumulativePageState
    extends State<AddLastYearSalesCumulativePage> {
  final _internetConnectionRepo = getIt<InternetConnectionRepo>();
  final _lastYearSalesCumulativeController =
      getIt<LastYearSalesCumulativeController>();
  final _viewDateController = getIt<ViewDateController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController imflCaseController = TextEditingController();
  TextEditingController beerCaseController = TextEditingController();
  TextEditingController totalPriceController = TextEditingController();

  DateTime? _selectedDate;
  String date = '';
  String viewDate = '';

  final FocusNode _imflFocusNode = FocusNode();
  final FocusNode _beerFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getViewDate();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return AppNavigatorWrapper(
      child: Column(
        children: [
          Text('Add Last Year Details', style: TextStyle(fontSize: 20)),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Selected Date : ',
                        style: TextStyle(fontSize: 22),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue[200],
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _selectDate(context);
                        },
                        child: Text(date, style: const TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(width / 2),
                      1: FixedColumnWidth(width / 20),
                      2: FixedColumnWidth(width / 2),
                    },
                    children: [
                      TableRow(
                        children: [
                          nameText('CUMULATIVE IMFL\nSALES IN CASES'),
                          colonText(),
                          TextFormField(
                            focusNode: _imflFocusNode,
                            controller: imflCaseController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !isNumeric(value)) {
                                return 'Enter Valid Number';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Enter Imfl Cases',
                            ),
                            onEditingComplete: () {
                              FocusScope.of(
                                context,
                              ).requestFocus(_beerFocusNode);
                            },
                          ),
                        ],
                      ),
                      spaceRow(),
                      TableRow(
                        children: [
                          nameText('CUMULATIVE BEER\nSALES IN CASES'),
                          colonText(),
                          TextFormField(
                            focusNode: _beerFocusNode,
                            controller: beerCaseController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !isNumeric(value)) {
                                return 'Enter Valid Number';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Enter Beer Cases',
                            ),
                            onEditingComplete: () {
                              FocusScope.of(
                                context,
                              ).requestFocus(_priceFocusNode);
                            },
                          ),
                        ],
                      ),
                      spaceRow(),
                      TableRow(
                        children: [
                          nameText('CUMULATIVE TOTAL\nSALES VALUE RS.'),
                          colonText(),
                          TextFormField(
                            focusNode: _priceFocusNode,
                            controller: totalPriceController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !isNumeric(value)) {
                                return 'Enter Valid Number';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Enter Total Sales Value',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        bool isConnected = await _internetConnectionRepo
                            .checkInternetConnection();
                        if (isConnected) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Processing...'),
                                        SizedBox(width: 20),
                                        CircularProgressIndicator(),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                          if (_formKey.currentState!.validate()) {
                            int? imflCase = int.tryParse(
                              imflCaseController.text,
                            );
                            int? beerCase = int.tryParse(
                              beerCaseController.text,
                            );
                            int? totalPrice = int.tryParse(
                              totalPriceController.text,
                            );
                            if (imflCase != null &&
                                beerCase != null &&
                                totalPrice != null) {
                              PreviousYearSalesCumulativeModel
                              model = PreviousYearSalesCumulativeModel(
                                date: _selectedDate.toString().substring(0, 10),
                                imflCases: imflCase,
                                beerCases: beerCase,
                                totalPreviousYearSalesCumulative: totalPrice,
                                isSynced: 1,
                              );
                              print(
                                'wwwwww ${_selectedDate.toString().substring(0, 10)}',
                              );

                              imflCaseController.clear();
                              beerCaseController.clear();
                              totalPriceController.clear();

                              await _lastYearSalesCumulativeController
                                  .addLastYearSalesCumulative(model);
                              showSuccessToast('Cumulative Added Successfully');

                              Navigator.of(context).pop();

                              //next item
                              DateTime nextDate = _selectedDate!.add(
                                const Duration(days: 1),
                              );
                              DateTime dateSelected = DateTime(
                                nextDate.year,
                                nextDate.month,
                                nextDate.day,
                              );
                              String formatDate = DateFormat(
                                'dd-MM-yyyy',
                              ).format(dateSelected);
                              setState(() {
                                _selectedDate = dateSelected;
                                date = formatDate;
                              });
                              FocusScope.of(
                                context,
                              ).requestFocus(_imflFocusNode);
                            }
                          } else {
                            Navigator.of(context).pop();
                          }
                        } else {
                          showErrorToast('No Internet Connection');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        fixedSize: Size(160, 40),
                      ),
                      child: const Text('Next '),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
    );
    final firstDate = DateTime(
      now.year - 1,
      now.month,
      1,
    ); // Start of the month
    final lastDate = DateTime(
      now.year - 1,
      now.month + 1,
      0,
    ); // End of the month
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      String date = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        this.date = date;
        _selectedDate = pickedDate;
      });
    }
  }

  Text nameText(String text) {
    return Text(text, style: TextStyle(fontSize: 18, color: Colors.black));
  }

  Text colonText() {
    return Text(
      ':',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  TableRow spaceRow() {
    return const TableRow(
      children: [
        SizedBox(height: 16),
        SizedBox(height: 16),
        SizedBox(height: 16),
      ],
    );
  }

  bool isNumeric(String value) {
    if (value == '') {
      return false;
    }
    if (int.tryParse(value) != null) {
      return !int.tryParse(value)!.isNegative;
    }
    return int.tryParse(value) != null;
  }

  void getViewDate() async {
    String value = await _viewDateController.getViewDateForUi();

    DateTime dateTime = DateTime.parse(value);

    DateTime dateSelected = DateTime(
      dateTime.year - 1,
      dateTime.month,
      dateTime.day,
    );
    String formatDate = DateFormat('dd-MM-yyyy').format(dateSelected);

    setState(() {
      _selectedDate = dateSelected;
      date = formatDate;
    });
    print('_selectedDate $_selectedDate');
  }
}

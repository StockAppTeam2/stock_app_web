import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stock_app_web/controllers/pos_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';
import 'package:stock_app_web/models/pos_model.dart';

class EditPosPage extends StatefulWidget {
  final NewPosModel posData;
  const EditPosPage({super.key, required this.posData});

  @override
  State<EditPosPage> createState() => _EditPosPageState();
}

class _EditPosPageState extends State<EditPosPage> {
  final _viewDateController = getIt<ViewDateController>();
  final posController = getIt<PosController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController posValueController = TextEditingController();
  TextEditingController posNumberOfBillsController = TextEditingController();
  TextEditingController posNumberOfBottlesController = TextEditingController();
  TextEditingController posImflSalesValueController = TextEditingController();
  TextEditingController posBeerSalesValueController = TextEditingController();
  TextEditingController posImflBottleController = TextEditingController();
  TextEditingController posBeerBottleController = TextEditingController();
  TextEditingController posShopCardPosController = TextEditingController();
  TextEditingController posShopUpiPosController = TextEditingController();
  TextEditingController posBarCardPosController = TextEditingController();
  TextEditingController posBarUpiPosController = TextEditingController();

  bool showPosValue = false;
  bool showPosCumulative = false;
  bool showPosNumberOfBills = false;
  bool showPosNumberOfBottles = false;
  bool showPosImflSalesValue = false;
  bool showPosBeerSalesValue = false;
  bool showPosImflBottles = false;
  bool showPosBeerBottles = false;

  bool showShopCardPos = false;
  bool showShopUpiPos = false;
  bool showBarCardPos = false;
  bool showBarUpiPos = false;

  String posDate = '';
  bool _isLoading = false;
  bool isFirstPosEntry = false;

  @override
  void initState() {
    super.initState();
    posValueController.text = widget.posData.posValue == -1
        ? widget.posData.posCumulative.toString()
        : widget.posData.posValue.toString();
    posNumberOfBillsController.text = widget.posData.posNumberOfBills
        .toString();
    posNumberOfBottlesController.text = widget.posData.posNumberOfBottles
        .toString();
    posImflSalesValueController.text = widget.posData.posImflSalesValue
        .toString();
    posBeerSalesValueController.text = widget.posData.posBeerSalesValue
        .toString();
    posImflBottleController.text = widget.posData.posImflBottles.toString();
    posBeerBottleController.text = widget.posData.posBeerBottles.toString();
    //
    posShopCardPosController.text = widget.posData.posShopCardPos.toString();
    posShopUpiPosController.text = widget.posData.posShopUpiPos.toString();
    posBarCardPosController.text = widget.posData.posBarCardPos.toString();
    posBarUpiPosController.text = widget.posData.posBarUpiPos.toString();
    getPosType();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return AppNavigatorWrapper(
      child: Column(
        children: [
          PageHeader(
            title: 'Edit POS',
            viewDate: '',
            query: (String p1) {},
            videoLink: '',
            page: 'add_pos_stock',
            invoiceNo: '',
            showReport: false,
          ),

          SizedBox(height: 10),

          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  isFirstPosEntry
                      ? const Text(
                          'Previous Day Cumulative',
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                        )
                      : Row(
                          children: [
                            nameText('Date'),
                            colonText(),
                            Expanded(
                              child: Text(
                                posDate.split('-').reversed.join('-'),
                              ),
                            ),
                          ],
                        ),
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(width / 2),
                      1: FixedColumnWidth(width / 20),
                      2: FixedColumnWidth(width / 2),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      showShopCardPos
                          ? TableRow(
                              children: [
                                nameText('Shop CARD Pos'),
                                colonText(),
                                TextFormField(
                                  controller: posShopCardPosController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]'),
                                    ),
                                  ],
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    return _validator(
                                      value!,
                                      'Shop Card Pos is required',
                                    );
                                  },
                                  decoration: _inputDecoration(
                                    'Shop Card Pos',
                                    'Enter Shop Card Pos',
                                  ),
                                ),
                              ],
                            )
                          : emptyTableRow(),
                      spaceRow(),
                      showShopUpiPos
                          ? TableRow(
                              children: [
                                nameText('Shop UPI Pos'),
                                colonText(),
                                TextFormField(
                                  controller: posShopUpiPosController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]'),
                                    ),
                                  ],
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    return _validator(
                                      value!,
                                      'Shop UPI Pos is required',
                                    );
                                  },
                                  decoration: _inputDecoration(
                                    'Shop UPI Pos',
                                    'Enter Shop UPI Pos',
                                  ),
                                ),
                              ],
                            )
                          : emptyTableRow(),
                      spaceRow(),
                      showBarCardPos
                          ? TableRow(
                              children: [
                                nameText('Bar CARD Pos'),
                                colonText(),
                                TextFormField(
                                  controller: posBarCardPosController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]'),
                                    ),
                                  ],
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    return _validator(
                                      value!,
                                      'Bar CARD Pos is required',
                                    );
                                  },
                                  decoration: _inputDecoration(
                                    'Bar CARD Pos',
                                    'Enter Bar CARD Pos',
                                  ),
                                ),
                              ],
                            )
                          : emptyTableRow(),
                      spaceRow(),
                      showBarUpiPos
                          ? TableRow(
                              children: [
                                nameText('Bar UPI Pos'),
                                colonText(),
                                TextFormField(
                                  controller: posBarUpiPosController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]'),
                                    ),
                                  ],
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    return _validator(
                                      value!,
                                      'Bar UPI Pos is required',
                                    );
                                  },
                                  decoration: _inputDecoration(
                                    'Bar UPI Pos',
                                    'Enter Bar UPI Pos',
                                  ),
                                ),
                              ],
                            )
                          : emptyTableRow(),
                      showPosValue
                          ? TableRow(
                              children: [
                                nameText('POS Value Rs.'),
                                colonText(),
                                TextFormField(
                                  controller: posValueController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]'),
                                    ),
                                  ],
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    return _validator(
                                      value!,
                                      'Pos Value is required',
                                    );
                                  },
                                  decoration: _inputDecoration(
                                    'Pos Value',
                                    'Enter Pos Value',
                                  ),
                                  onEditingComplete: () {
                                    FocusScope.of(context).nextFocus();
                                  },
                                ),
                              ],
                            )
                          : emptyTableRow(),
                      showPosNumberOfBills
                          ? TableRow(
                              children: [
                                nameText('POS Number of Bills'),
                                colonText(),
                                TextFormField(
                                  controller: posNumberOfBillsController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]'),
                                    ),
                                  ],
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    return _validator(
                                      value!,
                                      'Number of Bills is required',
                                    );
                                  },
                                  decoration: _inputDecoration(
                                    'Pos Number of Bills',
                                    'Enter Pos Number of Bills',
                                  ),
                                  onEditingComplete: () {
                                    FocusScope.of(context).nextFocus();
                                  },
                                ),
                              ],
                            )
                          : emptyTableRow(),
                      spaceRow(),
                      showPosNumberOfBottles
                          ? TableRow(
                              children: [
                                nameText('POS Number of Bottles'),
                                colonText(),
                                TextFormField(
                                  controller: posNumberOfBottlesController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]'),
                                    ),
                                  ],
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    return _validator(
                                      value!,
                                      'Number of Bottles is required',
                                    );
                                  },
                                  decoration: _inputDecoration(
                                    'Pos Number of Bottles',
                                    'Enter Pos Number of Bottles',
                                  ),
                                  onEditingComplete: () {
                                    FocusScope.of(context).nextFocus();
                                  },
                                ),
                              ],
                            )
                          : emptyTableRow(),
                      spaceRow(),
                      showPosImflSalesValue
                          ? TableRow(
                              children: [
                                nameText('POS IMFL Sales Value Rs.'),
                                colonText(),
                                TextFormField(
                                  controller: posImflSalesValueController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]'),
                                    ),
                                  ],
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    return _validator(
                                      value!,
                                      'IMFL Sales Value is required',
                                    );
                                  },
                                  decoration: _inputDecoration(
                                    'Pos IMFL Sales Value',
                                    'Enter Pos IMFL Sales Value',
                                  ),
                                  onEditingComplete: () {
                                    FocusScope.of(context).nextFocus();
                                  },
                                ),
                              ],
                            )
                          : emptyTableRow(),
                      spaceRow(),
                      showPosBeerSalesValue
                          ? TableRow(
                              children: [
                                nameText('POS BEER Sales Value Rs.'),
                                colonText(),
                                TextFormField(
                                  controller: posBeerSalesValueController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]'),
                                    ),
                                  ],
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    return _validator(
                                      value!,
                                      'BEER Sales Value is required',
                                    );
                                  },
                                  decoration: _inputDecoration(
                                    'Pos BEER Sales Value',
                                    'Enter Pos BEER Sales Value',
                                  ),
                                  onEditingComplete: () {
                                    FocusScope.of(context).nextFocus();
                                  },
                                ),
                              ],
                            )
                          : emptyTableRow(),
                      spaceRow(),
                      showPosImflBottles
                          ? TableRow(
                              children: [
                                nameText('POS IMFL Bottles'),
                                colonText(),
                                TextFormField(
                                  controller: posImflBottleController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]'),
                                    ),
                                  ],
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    return _validator(
                                      value!,
                                      'IMFL Bottles is required',
                                    );
                                  },
                                  decoration: _inputDecoration(
                                    'Pos IMFL Bottles',
                                    'Enter Pos IMFL Bottles',
                                  ),
                                  onEditingComplete: () {
                                    FocusScope.of(context).nextFocus();
                                  },
                                ),
                              ],
                            )
                          : emptyTableRow(),
                      spaceRow(),
                      showPosBeerBottles
                          ? TableRow(
                              children: [
                                nameText('POS BEER Bottles'),
                                colonText(),
                                TextFormField(
                                  controller: posBeerBottleController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]'),
                                    ),
                                  ],
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    return _validator(
                                      value!,
                                      'BEER Bottles is required',
                                    );
                                  },
                                  decoration: _inputDecoration(
                                    'Pos BEER Bottles',
                                    'Enter Pos BEER Bottles',
                                  ),
                                ),
                              ],
                            )
                          : emptyTableRow(),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String shopId = await getIt<ShopIdController>()
                              .getShopId();
                          setState(() {
                            _isLoading = true;
                          });

                          if (isFirstPosEntry) {
                            DateTime lastDate = DateTime.parse(posDate);
                            String yesterday = DateFormat('yyyy-MM-dd').format(
                              lastDate.subtract(const Duration(days: 1)),
                            );
                            posDate = yesterday;
                          }
                          if (posDate != '') {
                            print('posDate $posDate');
                            int posValue = showPosValue
                                ? int.parse(posValueController.text)
                                : 0;

                            int posNumberOfBills = showPosNumberOfBills
                                ? int.parse(posNumberOfBillsController.text)
                                : 0;
                            int posNumberOfBottles = showPosNumberOfBottles
                                ? int.parse(posNumberOfBottlesController.text)
                                : 0;
                            int posImflSalesValue = showPosImflSalesValue
                                ? int.parse(posImflSalesValueController.text)
                                : 0;
                            int posBeerSalesValue = showPosBeerSalesValue
                                ? int.parse(posBeerSalesValueController.text)
                                : 0;
                            int posImflBottles = showPosImflBottles
                                ? int.parse(posImflBottleController.text)
                                : 0;
                            int posBeerBottles = showPosBeerBottles
                                ? int.parse(posBeerBottleController.text)
                                : 0;
                            int posShopCardPos = showShopCardPos
                                ? int.parse(posShopCardPosController.text)
                                : 0;
                            int posShopUpiPos = showShopUpiPos
                                ? int.parse(posShopUpiPosController.text)
                                : 0;
                            int posBarCardPos = showBarCardPos
                                ? int.parse(posBarCardPosController.text)
                                : 0;
                            int posBarUpiPos = showBarUpiPos
                                ? int.parse(posBarUpiPosController.text)
                                : 0;

                            NewPosModel newData = NewPosModel(
                              posValue:
                                  posValue +
                                  posShopCardPos +
                                  posShopUpiPos +
                                  posBarCardPos +
                                  posBarUpiPos,
                              posDate: posDate,
                              posNumberOfBills: posNumberOfBills,
                              posNumberOfBottles: posNumberOfBottles,
                              posImflSalesValue: posImflSalesValue,
                              posBeerSalesValue: posBeerSalesValue,
                              posImflBottles: posImflBottles,
                              posBeerBottles: posBeerBottles,
                              posCumulative: 0,
                              isSynced: 1,
                              posShopCardPos: posShopCardPos,
                              posShopUpiPos: posShopUpiPos,
                              posBarCardPos: posBarCardPos,
                              posBarUpiPos: posBarUpiPos,
                            );

                            print(
                              'posShopCardPos $posShopCardPos posShopUpiPos $posShopUpiPos posBarCardPos $posBarCardPos posBarUpiPos $posBarUpiPos',
                            );

                            DocumentReference documentReferenceExp =
                                FirebaseFirestore.instance
                                    .collection('expenses')
                                    .doc(shopId)
                                    .collection('date')
                                    .doc(posDate);

                            DocumentSnapshot snapshot =
                                await documentReferenceExp.get();

                            if (snapshot.exists) {
                              Map<String, dynamic> snapData =
                                  snapshot.data() as Map<String, dynamic>;

                              if ((snapData.containsKey('liquorSales') ||
                                      snapData.containsKey('barSales')) &&
                                  (snapData['liquorSales'] != 0 ||
                                      snapData['barSales'] != 0)) {
                                // int totalProfit = snapData['totalProfit'].toInt();
                                int liquorSalesVal =
                                    snapData['liquorSales'].toInt() ?? 0;
                                int barSalesVal =
                                    snapData['barSales'].toInt() ?? 0;

                                int cashSales =
                                    (liquorSalesVal + barSalesVal) -
                                    newData.posValue;

                                await documentReferenceExp.set({
                                  'posSales': newData.posValue,
                                  'cashSales': cashSales,
                                }, SetOptions(merge: true));
                              } else {
                                await documentReferenceExp.set({
                                  'posSales': newData.posValue,
                                }, SetOptions(merge: true));
                              }
                            }

                            await posController.addNewPosData(newData);

                            setState(() {
                              _isLoading = false;
                            });

                            if (!context.mounted) return;
                            context.go(
                              '/$shopId/${AppRoutes.posMonthlyFolder}',
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: Size(140, 50),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : const Text('Edit'),
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

  Text nameText(String text) {
    return Text(text, style: TextStyle(fontSize: 20, color: Colors.black));
  }

  Text colonText() {
    return Text(
      '  :  ',
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

  InputDecoration _inputDecoration(String labelText, String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.0),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 1.0),
      ),
    );
  }

  String? _validator(String? value, String error) {
    if (value == null || value.isEmpty || !isNumeric(value)) {
      return error;
    }
    return null;
  }

  TableRow emptyTableRow() =>
      const TableRow(children: [SizedBox(), SizedBox(), SizedBox()]);

  void getPosType() async {
    posDate = await _viewDateController.getViewDateForUi();

    String shopId = await getIt<ShopIdController>().getShopId();
    DocumentSnapshot settingsDoc = await FirebaseFirestore.instance
        .collection('settings')
        .doc(shopId)
        .get();
    String format = settingsDoc.get('posFormat');

    DocumentSnapshot posDoc = await FirebaseFirestore.instance
        .collection('settings')
        .doc('posFormats')
        .get();

    List<String> posFormat = List<String>.from(posDoc.get(format));

    print('posFormat: $posFormat');
    for (final type in posFormat) {
      if (type == 'posValue') {
        setState(() {
          showPosValue = true;
        });
      } else if (type == 'posCumulative') {
        setState(() {
          showPosCumulative = true;
        });
      } else if (type == 'posNumberOfBills') {
        setState(() {
          showPosNumberOfBills = true;
        });
      } else if (type == 'posNumberOfBottles') {
        setState(() {
          showPosNumberOfBottles = true;
        });
      } else if (type == 'posImflSalesValue') {
        setState(() {
          showPosImflSalesValue = true;
        });
      } else if (type == 'posBeerSalesValue') {
        setState(() {
          showPosBeerSalesValue = true;
        });
      } else if (type == 'posImflBottles') {
        setState(() {
          showPosImflBottles = true;
        });
      } else if (type == 'posBeerBottles') {
        setState(() {
          showPosBeerBottles = true;
        });
      } else if (type == 'shopCardPos') {
        setState(() {
          showShopCardPos = true;
        });
      } else if (type == 'shopUpiPos') {
        setState(() {
          showShopUpiPos = true;
        });
      } else if (type == 'barCardPos') {
        setState(() {
          showBarCardPos = true;
        });
      } else if (type == 'barUpiPos') {
        setState(() {
          showBarUpiPos = true;
        });
      }
    }
  }
}

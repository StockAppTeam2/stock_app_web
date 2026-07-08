import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_app_web/controllers/opening_page_controller.dart';
import 'package:stock_app_web/controllers/pos_controller.dart';
import 'package:stock_app_web/controllers/previous_year_sales_cumulative_controller.dart';
import 'package:stock_app_web/controllers/receipt_controller.dart';
import 'package:stock_app_web/controllers/return_stock_controller.dart';
import 'package:stock_app_web/controllers/sales_cumulative_controller.dart';
import 'package:stock_app_web/controllers/sales_page_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/utils/guid_video_links.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';
import 'package:stock_app_web/models/inward_table_model.dart';
import 'package:stock_app_web/models/items_table_model.dart';
import 'package:stock_app_web/models/pos_model.dart';
import 'package:stock_app_web/models/previous_year_sales_cumulative.dart';
import 'package:stock_app_web/models/return_model.dart';
import 'package:stock_app_web/models/sales_table_model.dart';
import 'package:stock_app_web/pages/form_49/form_49_widgets.dart';

class Form49Page extends StatefulWidget {
  const Form49Page({super.key});

  @override
  State<Form49Page> createState() => _Form49PageState();
}

class _Form49PageState extends State<Form49Page> {
  final _viewDateController = getIt<ViewDateController>();
  final _salesController = getIt<SalesPageController>();
  final posController = getIt<PosController>();
  final openingController = getIt<OpeningPageController>();
  final inwardController = getIt<ReceiptController>();
  final previousYearSalesCumulativeController =
      getIt<PreviousYearSalesCumulativeController>();
  final returnStockController = getIt<ReturnStockController>();
  final salesCumulativeController = getIt<SalesCumulativeController>();

  int? imflDifference;
  int? beerDifference;
  int? salesDifference;

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            PageHeader(
              title: 'Form 49',
              viewDate: '',
              query: (String p1) {},
              videoLink: form49VideoLink,
              page: 'form_49',
              invoiceNo: '',
              showReport: false,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: alignAllData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  final products = snapshot.data ?? {};

                  if (products.isEmpty) {
                    return const Center(child: Text("No Data Found"));
                  }

                  return LayoutBuilder(
                    builder: ((context, constraints) {
                      final width = constraints.maxWidth;
                      return SingleChildScrollView(
                        child: Table(
                          columnWidths: {
                            0: FixedColumnWidth(width * 0.08),
                            1: FixedColumnWidth(width * 0.25),
                            2: FixedColumnWidth(width * 0.05),
                            3: FixedColumnWidth(width * 0.50),
                          },
                          children: [
                            TableRow(
                              children: [
                                sNoText('1'),
                                nameText('SHOP NO'),
                                colonText(),
                                valueText('${snapshot.data![0]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('2'),
                                nameText('SALES DATE'),
                                colonText(),
                                valueTextDate('${snapshot.data![1]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('3'),
                                nameText('CONTACT NO'),
                                colonText(),
                                valueText('${snapshot.data![2]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('4'),
                                nameText('DISTRICT'),
                                colonText(),
                                valueText('${snapshot.data![3]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('5'),
                                nameText('IMFL 1000'),
                                colonText(),
                                valueText('${snapshot.data![4]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('6'),
                                nameText('IMFL 750'),
                                colonText(),
                                valueText('${snapshot.data![5]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('7'),
                                nameText('IMFL 375'),
                                colonText(),
                                valueText('${snapshot.data![6]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('8'),
                                nameText('IMFL 180'),
                                colonText(),
                                valueText('${snapshot.data![7]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('9'),
                                nameText('BEER 650'),
                                colonText(),
                                valueText('${snapshot.data![8]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('10'),
                                nameText('BEER 500'),
                                colonText(),
                                valueText('${snapshot.data![9]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('11'),
                                nameText('BEER 325'),
                                colonText(),
                                valueText('${snapshot.data![49]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('12'),
                                nameText('IMFL SALES CASES'),
                                colonText(),
                                valueText('${snapshot.data![10]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('13'),
                                nameText('BEER SALES CASES'),
                                colonText(),
                                valueText('${snapshot.data![11]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('14'),
                                nameText('IMFL SALES VALUE'),
                                colonText(),
                                valueText('${snapshot.data![12]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('15'),
                                nameText('BEER SALES VALUE'),
                                colonText(),
                                valueText('${snapshot.data![13]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('16'),
                                nameText('TOTAL SALES VALUE IMFL + BEER'),
                                colonText(),
                                valueText('${snapshot.data![14]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('17'),
                                nameText('BANK REMITANCE'),
                                colonText(),
                                valueText('${snapshot.data![15]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('18'),
                                nameText('POS VALUE'),
                                colonText(),
                                valueText('${snapshot.data![16]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('19'),
                                nameText('TOTAL SALES AMOUNT (POS + BANK)'),
                                colonText(),
                                valueText('${snapshot.data![17]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('20'),
                                nameText('ORD.IMFL CB CASES'),
                                colonText(),
                                valueText('${snapshot.data![18]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('21'),
                                nameText('MEDIUM IMFS CB CASES'),
                                colonText(),
                                valueText('${snapshot.data![19]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('22'),
                                nameText('PREMIUM IMFL CB CASES'),
                                colonText(),
                                valueText('${snapshot.data![20]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('23'),
                                nameText('STRONG BEER CASES'),
                                colonText(),
                                valueText('${snapshot.data![21]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('24'),
                                nameText('LAGER BEER CASES'),
                                colonText(),
                                valueText('${snapshot.data![22]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('25'),
                                nameText('IMFL CB VALUE'),
                                colonText(),
                                valueText('${snapshot.data![50]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('26'),
                                nameText('BEER CB VALUE'),
                                colonText(),
                                valueText('${snapshot.data![51]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('27'),
                                nameText('OVERALL CB VALUE (IMFL + BEER)'),
                                colonText(),
                                valueText(
                                  '${snapshot.data![23].isNegative ? 0 : snapshot.data![23]}',
                                ),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('28'),
                                nameText('STOCK RECIEPT IMFL CASES'),
                                colonText(),
                                valueText('${snapshot.data![24]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('29'),
                                nameText('STOCK RECIEPT BEER  CASES'),
                                colonText(),
                                valueText('${snapshot.data![25]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('30'),
                                nameText('TOTAL RECIEPT  (IMFL + BEER)'),
                                colonText(),
                                valueText('${snapshot.data![26]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('31'),
                                nameText('IMFL STOCK RECIEPT IN CASE ORDINARY'),
                                colonText(),
                                valueText('${snapshot.data![27]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('32'),
                                nameText('IMFL STOCK RECIEPT IN CASE MEDIUM'),
                                colonText(),
                                valueText('${snapshot.data![28]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('33'),
                                nameText('IMFL STOCK RECIEPT IN CASE PREMIUM'),
                                colonText(),
                                valueText('${snapshot.data![29]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('34'),
                                nameText('BEER STOCK RECIEPT IN CASES STRONG'),
                                colonText(),
                                valueText('${snapshot.data![30]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('35'),
                                nameText('BEER STOCK RECIEPT IN CASES LAGER'),
                                colonText(),
                                valueText('${snapshot.data![31]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('36'),
                                nameText('STOCK RETURN IMFL CASES'),
                                colonText(),
                                valueText('${snapshot.data![32]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('37'),
                                nameText('STOCK RETURN BEER CASES'),
                                colonText(),
                                valueText('${snapshot.data![33]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('38'),
                                nameText('TOTAL RETURN VALUE (IMFL + BEER)'),
                                colonText(),
                                valueText('${snapshot.data![34]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('39'),
                                nameText('IMFL STOCK RETURN ORDINARY CASES'),
                                colonText(),
                                valueText('${snapshot.data![35]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('40'),
                                nameText('IMFL STOCK RETURN MEDIUM CASES'),
                                colonText(),
                                valueText('${snapshot.data![36]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('41'),
                                nameText('IMFL STOCK RETURN PREMIUM CASES'),
                                colonText(),
                                valueText('${snapshot.data![37]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('42'),
                                nameText('BEER STOCK RETURN STRONG CASES'),
                                colonText(),
                                valueText('${snapshot.data![38]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('43'),
                                nameText('BEER STOCK RETURN LAGER CASES'),
                                colonText(),
                                valueText('${snapshot.data![39]}'),
                              ],
                            ),
                            // spaceRow(),
                            // TableRow(
                            //   children: [
                            //     sNoText('41'),
                            //     nameText('60 DAYS STOCK IN CASES'),
                            //     colonText(),
                            //     valueText('${snapshot.data![40]}'),
                            //   ],
                            // ),
                            // spaceRow(),
                            // TableRow(
                            //   children: [
                            //     sNoText('42'),
                            //     nameText('90 DAYS STOCK IN CASES'),
                            //     colonText(),
                            //     valueText('${snapshot.data![41]}'),
                            //   ],
                            // ),
                            // spaceRow(),
                            // TableRow(
                            //   children: [
                            //     sNoText('43'),
                            //     nameText('90 DAYS STOCK IN VALUES'),
                            //     colonText(),
                            //     valueText('${snapshot.data![42]}'),
                            //   ],
                            // ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('44'),
                                nameText(
                                  'CUMULATIVE IMFL SALES IN CASES UPTO CURRENT DATE OF ${getMonthYear()[1]}',
                                ),
                                colonText(),
                                // valueText('${snapshot.data![43]}'),
                                valueTextPreviousYearCumulative(
                                  '${snapshot.data![43]}',
                                  '$imflDifference',
                                ),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('45'),
                                nameText(
                                  'CUMULATIVE BEER SALES IN CASES UPTO CURRENT DATE OF ${getMonthYear()[1]}',
                                ),
                                colonText(),
                                // valueText('${snapshot.data![44]}')
                                valueTextPreviousYearCumulative(
                                  '${snapshot.data![44]}',
                                  '$beerDifference',
                                ),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('46'),
                                nameText(
                                  'CUMULATIVE TOTAL SALES VALUE UPTO SAME DATE OF ${getMonthYear()[1]}',
                                ),
                                colonText(),
                                // valueText('${snapshot.data![45]}'),
                                valueTextPreviousYearCumulative(
                                  '${snapshot.data![45]}',
                                  '$salesDifference',
                                ),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('47'),
                                nameText(
                                  'CUMULATIVE IMFL SALES IN CASES UPTO SAME DATE OF ${getMonthYear()[0]}',
                                ),
                                colonText(),
                                valueText('${snapshot.data![46]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('48'),
                                nameText(
                                  'CUMULATIVE BEER SALES IN CASES UPTO SAME DATE OF ${getMonthYear()[0]}',
                                ),
                                colonText(),
                                valueText('${snapshot.data![47]}'),
                              ],
                            ),
                            spaceRow(),
                            TableRow(
                              children: [
                                sNoText('49'),
                                nameText(
                                  'CUMULATIVE TOTAL SALES VALUE UPTO SAME DATE OF ${getMonthYear()[0]}',
                                ),
                                colonText(),
                                valueText('${snapshot.data![48]}'),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<dynamic>> alignAllData() async {
    String viewDate = await _viewDateController.getViewDateForUi();
    DateTime? date = DateTime.parse(viewDate);

    List<dynamic> allData = List.filled(52, 0);

    if (date != null) {
      List<int> shopDetails = await shopIdDateContact();
      allData[0] = shopDetails[0];
      String formattedDate = DateFormat('dd-MM-yyyy').format(date);
      allData[1] = formattedDate;

      List<int> salesValues = await salesAllCalculations(viewDate);
      allData[4] = salesValues[0];
      allData[5] = salesValues[1];
      allData[6] = salesValues[2];
      allData[7] = salesValues[3];
      allData[8] = salesValues[4];
      allData[9] = salesValues[5];
      allData[10] = salesValues[6];
      allData[11] = salesValues[7];
      allData[12] = salesValues[8];
      allData[13] = salesValues[9];
      allData[14] = salesValues[10];
      allData[49] = salesValues[11];

      List<int> bankRemittances = await bankRemittance(
        salesValues[10],
        viewDate,
        '3810',
      );
      allData[15] = bankRemittances[0];
      allData[16] = bankRemittances[1];
      allData[17] = bankRemittances[2];

      List<int> closingValues = await closingAllCalculations(viewDate);
      allData[18] = closingValues[0];
      allData[19] = closingValues[1];
      allData[20] = closingValues[2];
      allData[21] = closingValues[3];
      allData[23] = closingValues[5];
      //25,26,27
      allData[50] = closingValues[6];
      allData[51] = closingValues[7];

      List<int> inwardValues = await receiptAllCalculations(viewDate);
      allData[24] = inwardValues[0];
      allData[25] = inwardValues[1];
      allData[26] = inwardValues[2];
      allData[27] = inwardValues[3];
      allData[28] = inwardValues[4];
      allData[29] = inwardValues[5];
      allData[30] = inwardValues[6];

      List cumulatives = await cumulative(date);
      allData[43] = cumulatives[0];
      allData[44] = cumulatives[1];
      allData[45] = cumulatives[2];

      List previousYearSalesCumulativeValues =
          await previousYearSalesCumulative(date);
      if (previousYearSalesCumulativeValues.isNotEmpty) {
        allData[46] = previousYearSalesCumulativeValues[0];
        allData[47] = previousYearSalesCumulativeValues[1];
        allData[48] = previousYearSalesCumulativeValues[2];
        //difference previousYear - currentDay = ?
        imflDifference = cumulatives[0] - previousYearSalesCumulativeValues[0];
        beerDifference = cumulatives[1] - previousYearSalesCumulativeValues[1];
        salesDifference = cumulatives[2] - previousYearSalesCumulativeValues[2];
      } //80141

      //return stock
      List returnValues = await returnAllCalculations(date);
      allData[32] = returnValues[0];
      allData[33] = returnValues[1];
      allData[34] = returnValues[2];
      allData[35] = returnValues[3];
      allData[36] = returnValues[4];
      allData[37] = returnValues[5];
      allData[38] = returnValues[6];
      allData[39] = returnValues[7];
    }

    return allData;
  }

  Future<List<int>> shopIdDateContact() async {
    List<int> shopDetails = List.filled(1, 0);
    shopDetails[0] = 3810;
    return shopDetails;
    // if (shopId != null) {
    //   shopDetails[0] = shopId!;
    //   return shopDetails;
    // } else {
    //   return [0];
    // }
  }

  Future<List<int>> salesAllCalculations(String date) async {
    List<SalesViewModel> salesData = await _salesController.getSalesData(
      date,
      '3810',
    );
    List<int> salesCalc = List.filled(12, 0);

    //1000
    List<SalesViewModel> imfl1000 = salesData
        .where(
          (element) => element.size == '1000 ml' && element.group == "IMFL",
        )
        .toList();
    int total1000Bottles = imfl1000.fold(
      0,
      (sum, element) => sum + element.totalSalesRetailUnits,
    );
    salesCalc[0] = total1000Bottles;

    //750
    List<SalesViewModel> imfl750 = salesData
        .where((element) => element.size == '750 ml' && element.group == "IMFL")
        .toList();
    int total750Bottles = imfl750.fold(
      0,
      (sum, element) => sum + element.totalSalesRetailUnits,
    );
    salesCalc[1] = total750Bottles;

    //375
    List<SalesViewModel> imfl375 = salesData
        .where((element) => element.size == '375 ml' && element.group == "IMFL")
        .toList();
    int total375Bottles = imfl375.fold(
      0,
      (sum, element) => sum + element.totalSalesRetailUnits,
    );
    salesCalc[2] = total375Bottles;

    //180
    List<SalesViewModel> imfl180 = salesData
        .where((element) => element.size == '180 ml' && element.group == "IMFL")
        .toList();
    int total180Bottles = imfl180.fold(
      0,
      (sum, element) => sum + element.totalSalesRetailUnits,
    );
    salesCalc[3] = total180Bottles;

    //650
    List<SalesViewModel> beer650 = salesData
        .where((element) => element.size == '650 ml' && element.group == "BEER")
        .toList();
    int total650Bottles = beer650.fold(
      0,
      (sum, element) => sum + element.totalSalesRetailUnits,
    );
    salesCalc[4] = total650Bottles;

    //500
    List<SalesViewModel> beer500 = salesData
        .where((element) => element.size == '500 ml' && element.group == "BEER")
        .toList();
    int total500Bottles = beer500.fold(
      0,
      (sum, element) => sum + element.totalSalesRetailUnits,
    );
    salesCalc[5] = total500Bottles;

    //325
    List<SalesViewModel> beer325 = salesData
        .where((element) => element.size == '325 ml' && element.group == "BEER")
        .toList();
    int total325Bottles = beer325.fold(
      0,
      (sum, element) => sum + element.totalSalesRetailUnits,
    );
    salesCalc[11] = total325Bottles;

    // sales cases
    int imflSalesCase =
        total180Bottles +
        (total375Bottles * 2) +
        (total750Bottles * 4) +
        (total1000Bottles * 5);

    //round off value
    int imflSalesCases = customRound(imflSalesCase / 48);

    salesCalc[6] = imflSalesCases;

    //beer cases
    int beerSalesCase = customRound(
      ((total650Bottles * 2) + total500Bottles + total325Bottles) / 24,
    );

    salesCalc[7] = beerSalesCase;

    //sales value imfl
    List<SalesViewModel> imflSalesValue = salesData
        .where((element) => element.group == 'IMFL')
        .toList();
    int salesTotalValueImfl = imflSalesValue.fold(
      0,
      (sum, element) => sum + element.totalPriceSales,
    );

    salesCalc[8] = salesTotalValueImfl;

    //sales value Beer
    List<SalesViewModel> beerSalesValue = salesData
        .where((element) => element.group == 'BEER')
        .toList();
    int salesTotalValueBeer = beerSalesValue.fold(
      0,
      (sum, element) => sum + element.totalPriceSales,
    );

    salesCalc[9] = salesTotalValueBeer;

    // sales value mfl + beer
    int totalSalesValue = salesTotalValueImfl + salesTotalValueBeer;
    salesCalc[10] = totalSalesValue;

    return salesCalc;
  }

  Future<List<int>> bankRemittance(
    int totalSales,
    String date,
    String shopId,
  ) async {
    List<int> data = List.filled(3, 0);

    List<int> posData = await posController.getPosDataUsingDateInFirebase(
      date,
      shopId,
    );

    int bankRemittances = 0;
    int pos = 0;
    if (totalSales != null) {
      if (posData[0] != 0) {
        bankRemittances = totalSales - posData[0];
        pos = posData[0];
      } else {
        bankRemittances = totalSales;
      }
    }

    data[0] = bankRemittances;
    data[1] = pos;
    data[2] = totalSales;

    return data;
  }

  Future<List<int>> closingAllCalculations(String date) async {
    List<ItemsViewModel> openCloseActual = await openingController
        .getOpeningData(date, '3810');

    List<int> cbCalc = List.filled(8, 0);
    int ordImflCBCases = await ordinaryImflCBCase(openCloseActual);
    cbCalc[0] = ordImflCBCases;
    int medImflCBCases = await mediumImflCBCase(openCloseActual);
    cbCalc[1] = medImflCBCases;
    int preImflCBCases = await premiumImflCBCase(openCloseActual);
    cbCalc[2] = preImflCBCases;
    int strongBeerCBCases = await strongBeerCBCase(openCloseActual);
    cbCalc[3] = strongBeerCBCases;
    //legar beer not calculated

    //imfl
    List<ItemsViewModel> imflVal = openCloseActual
        .where((element) => element.itemsGroup == "IMFL")
        .toList();
    int imflCbValue = imflVal.fold(
      0,
      (sum, element) => sum + element.totalPriceClosing,
    );
    cbCalc[6] = imflCbValue;

    //beer
    List<ItemsViewModel> beerVal = openCloseActual
        .where((element) => element.itemsGroup == "BEER")
        .toList();
    int beerCbValue = beerVal.fold(
      0,
      (sum, element) =>
          sum +
          (element.totalPriceClosing == -1 ? 0 : element.totalPriceClosing),
    );
    cbCalc[7] = beerCbValue;

    //imfl+beer
    List<int> overAll = openCloseActual
        .map(
          (element) =>
              element.totalPriceClosing == -1 ? 0 : element.totalPriceClosing,
        )
        .toList();
    int overallCbValue = overAll.fold(
      0,
      (previousValue, element) => previousValue + element,
    );
    cbCalc[5] = overallCbValue;

    return cbCalc;
  }

  Future<List<int>> receiptAllCalculations(String date) async {
    List<InwardViewModel> inwardData = await inwardController.getInwardData(
      date,
      '3810',
    );

    List<int> inwardCalc = List.filled(7, 0);

    List<InwardViewModel> imflStockCases = inwardData
        .where((element) => element.inwardGroup == "IMFL")
        .toList();
    List<InwardViewModel> beerStockCases = inwardData
        .where((element) => element.inwardGroup == "BEER")
        .toList();

    int stockReceiptImflCases = await stockReceiptImflCase(imflStockCases);
    inwardCalc[0] = stockReceiptImflCases;

    int stockReceiptBeerCases = await stockReceiptBeerCase(beerStockCases);
    inwardCalc[1] = stockReceiptBeerCases;

    int totalReceiptImflBeer = inwardData.fold(
      0,
      (sum, element) => sum + element.totalPriceInward,
    );
    inwardCalc[2] = totalReceiptImflBeer;

    int ordinaryImflInwardCases = await ordinaryImflInwardCase(inwardData);
    inwardCalc[3] = ordinaryImflInwardCases;

    int mediumImflInwardCases = await mediumImflInwardCase(inwardData);
    inwardCalc[4] = mediumImflInwardCases;

    int premiumImflInwardCases = await premiumImflInwardCase(inwardData);
    inwardCalc[5] = premiumImflInwardCases;

    int strongBeerInwardCases = await strongBeerInwardCase(inwardData);
    inwardCalc[6] = strongBeerInwardCases;

    //legar not calculated
    return inwardCalc;
  }

  Future<List> cumulative(DateTime date) async {
    List cumulative = await salesCumulativeController
        .salesCumulativeCalculation('3810', date);
    print('cumulativessss $cumulative');
    if (cumulative.length == 3) {
      return cumulative;
    } else {
      return [0, 0, 0];
    }
  }

  Future<List> previousYearSalesCumulative(DateTime date) async {
    DateTime dateTime = DateTime(date.year - 1, date.month, date.day);
    PreviousYearSalesCumulativeModel? model =
        await previousYearSalesCumulativeController
            .readPreviousYearSalesCumulativeUsingDate(
              '3810',
              dateTime.toString().substring(0, 10),
            );

    if (model != null) {
      int imflCase = model.imflCases;
      int beerCase = model.beerCases;
      int totalSales = model.totalPreviousYearSalesCumulative;
      return [imflCase, beerCase, totalSales];
    } else {
      return [];
    }
  }

  Future<List> returnAllCalculations(DateTime date) async {
    List<int> returnData = List.filled(8, 0);

    List<ReturnViewModel> returnStock = await returnStockController
        .getAllReturnStock('3810', date.toString().substring(0, 10));

    int imflCases = 0;
    int beerCases = 0;
    int totalImflBeerValue = 0;
    int imflOrdinaryCases = 0;
    int imflMediumCases = 0;
    int imflPremiumCases = 0;
    int beerStrongCases = 0;
    int beerLegerCases = 0;

    for (final item in returnStock) {
      int totalReturnRetail =
          (item.returnBundle * item.bottlePerBundle) + item.returnRetail;
      int bundleReturn = totalReturnRetail ~/ item.bottlePerBundle;
      // int retailReturn = totalReturnRetail % item.bottlePerBundle;
      int totalReturnPrice = totalReturnRetail * item.price;

      if (item.itemsGroup == "IMFL") {
        imflCases += bundleReturn;

        if (item.range == 'ORDINARY') {
          imflOrdinaryCases += bundleReturn;
        } else if (item.range == 'MEDIUM') {
          imflMediumCases += bundleReturn;
        } else if (item.range == 'PREMIUM') {
          imflPremiumCases += bundleReturn;
        }
      }
      if (item.itemsGroup == "BEER") {
        beerCases += bundleReturn;
        beerStrongCases += bundleReturn;
      }
      totalImflBeerValue += totalReturnPrice;
    }

    returnData[0] = imflCases;
    returnData[1] = beerCases;
    returnData[2] = totalImflBeerValue;
    returnData[3] = imflOrdinaryCases;
    returnData[4] = imflMediumCases;
    returnData[5] = imflPremiumCases;
    returnData[6] = beerStrongCases;
    returnData[7] = beerLegerCases;

    return returnData;
  }
}

import 'package:flutter/material.dart';
import 'package:stock_app_web/controllers/pv_report_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';
import 'package:stock_app_web/models/items_table_model.dart';

class PvReportPage extends StatefulWidget {
  const PvReportPage({super.key});

  @override
  State<PvReportPage> createState() => _PvReportPageState();
}

class _PvReportPageState extends State<PvReportPage> {
  final pvReportController = getIt<PvReportController>();
  final _viewDateController = getIt<ViewDateController>();

  String viewDate = '';
  List<int> cumulativeList = [];

  @override
  void initState() {
    super.initState();
    getViewDate();
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            PageHeader(
              title: 'PV Report',
              viewDate: viewDate,
              query: (String p1) {},
              videoLink: '',
              page: 'pv_report',
              invoiceNo: '',
              showReport: true,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<List<ItemsViewModel>>(
                future: getPvReportData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  final pv = snapshot.data ?? [];

                  if (pv.isEmpty) {
                    return const Center(child: Text("No Data Found"));
                  }

                  return Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            Colors.blue[300],
                          ),
                          headingTextStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                'S.NO',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'SHOP NO',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'CODE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'QTY',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'VALUE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'BRAND NAME',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'MRP',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'ML',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'CUMULATIVE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                          rows: List.generate(pv.length, (item) {
                            ItemsViewModel data = pv[item];

                            return DataRow(
                              color: WidgetStateColor.resolveWith(
                                (states) => item % 2 == 0
                                    ? Colors.white
                                    : Colors.grey[350]!,
                              ),
                              cells: <DataCell>[
                                DataCell(Text('${item + 1}')),
                                DataCell(Text('shopId')),
                                DataCell(Text('${data.productId}')),
                                DataCell(Text("${data.totalCloseRetailUnits}")),
                                DataCell(Text("${data.totalPriceClosing}")),
                                DataCell(Text(data.brand)),
                                DataCell(Text("${data.price}")),
                                DataCell(Text(data.size)),
                                DataCell(Text('${cumulativeList[item]}')),
                              ],
                            );
                          }),
                        ),
                      ),
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
    debugPrint('view date: $value');
    if (mounted) {
      setState(() => viewDate = value);
    }
  }

  Future<List<ItemsViewModel>> getPvReportData() async {
    String value = await _viewDateController.getViewDateForUi();

    List<ItemsViewModel> data = await pvReportController.getOpeningData(
      value,
      '3810',
    );
    List<ItemsViewModel> pvData = [];

    int cumulativeForTable = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i].totalPriceClosing != 0 &&
          !data[i].totalPriceClosing.isNegative) {
        pvData.add(data[i]);
        cumulativeForTable += data[i].totalPriceClosing;
        cumulativeList.add(cumulativeForTable);
      }
    }

    return pvData;
  }
}

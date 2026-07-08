import 'package:flutter/material.dart';
import 'package:stock_app_web/controllers/report_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final _viewDateController = getIt<ViewDateController>();
  final _reportController = getIt<ReportController>();

  String viewDate = '';
  bool cbNotCompleted = true;

  // int todayTotalOpenings = 0;
  // int todayTotalClosings = 0;
  // int todayTotalInwards = 0;
  // int todayTotalSalesValue = 0;
  // int todayTotalCurrentStock = 0;
  // int todayTotalReturnStock = 0;

  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    getViewDate();
    _future = getReportData();
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            PageHeader(
              title: 'Reports',
              viewDate: viewDate,
              query: (String p1) {},
              videoLink: '',
              page: 'report',
              invoiceNo: '',
              showReport: false,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _future,
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

                  return Column(
                    children: [
                      Align(
                        alignment: AlignmentGeometry.centerLeft,
                        child: SizedBox(
                          width: 600,
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(3),
                              1: IntrinsicColumnWidth(),
                              2: FlexColumnWidth(2),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              tableRow(
                                context,
                                'OPENING STOCK',
                                products['totalOpening'],
                              ),
                              tableRow(
                                context,
                                'RECEIPT',
                                products['totalInward'],
                              ),
                              tableRow(
                                context,
                                'RETURN',
                                products['totalReturn'],
                              ),
                              tableRow(
                                context,
                                'TOTAL',
                                products['totalActual'],
                              ),
                              tableRow(
                                context,
                                'CLOSING STOCK',
                                products['totalClosing'],
                                color: cbNotCompleted
                                    ? Colors.pink
                                    : Colors.grey,
                              ),
                              tableRow(
                                context,
                                'sales',
                                products['totalSales'],
                                color: cbNotCompleted
                                    ? Colors.pink
                                    : Colors.grey,
                              ),
                            ],
                          ),
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
    print('viewdate: $value');
    if (mounted) {
      setState(() => viewDate = value);
    }
  }

  Future<Map<String, dynamic>> getReportData() async {
    String value = await _viewDateController.getViewDateForUi();
    Map<String, dynamic> data = await _reportController.getReportsData(
      shopId: '3810',
      docId: value,
    );
    // [totalActual, totalClosing, totalOpening, totalInward, totalSales,totalReturn];
    //
    // setState(() {
    //   todayTotalOpenings = data[2];
    //   todayTotalClosings = data[1];
    //   todayTotalInwards = data[3];
    //   todayTotalSalesValue = data[4];
    //   todayTotalCurrentStock = data[0];
    //   todayTotalReturnStock = data[6];
    // });

    return data;
  }

  TableRow tableRow(
    BuildContext context,
    String title,
    num value, {
    Color color = Colors.pink,
  }) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(title, style: TextStyle(fontSize: 18)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            ':',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Rs.${value.isNegative ? 0 : value}',
            textAlign: TextAlign.end,
            style: TextStyle(color: color, fontSize: 18),
          ),
        ),
      ],
    );
  }
}

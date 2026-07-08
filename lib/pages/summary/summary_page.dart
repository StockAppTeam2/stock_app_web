import 'package:flutter/material.dart';
import 'package:stock_app_web/controllers/summary_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/pages/summary/summary_widgets.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  final _summaryController = getIt<SummaryController>();

  List<Map<String, dynamic>> salesData = [];

  @override
  void initState() {
    super.initState();
    getSalesData();
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<List<List<String>>>>(
                future: getData(),
                builder: (context, data) {
                  if (data.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (data.hasError) {
                    return Text('Error: ${data.error}');
                  } else if (!data.hasData || data.data!.isEmpty) {
                    return const Text('No data available');
                  } else {
                    if (data.data!.length < 2) {
                      return const Text('Data does not have enough elements');
                    }

                    return ListView(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 10,
                          ),
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(6),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(4),
                            },
                            children: List.generate(salesData.length, (index) {
                              final item = salesData[index];
                              return index == salesData.length - 1
                                  ? TableRow(
                                      decoration: const BoxDecoration(
                                        border: Border.symmetric(
                                          horizontal: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '${item['category']} ',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: '(',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '${item['units']}',
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: ')',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Text(
                                          '=',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'Rs.${item['price']}',
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    )
                                  : TableRow(
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '${item['category']} ',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: '(',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '${item['units']}',
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: ')',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Text(
                                          '=',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'Rs.${item['price']}',
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    );
                            }),
                          ),
                        ),
                        const SizedBox(height: 10),

                        const Text(
                          'ORDINARY',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(height: 10),
                        buildStockSummaryDataTable(data.data![1]),
                        const SizedBox(height: 50),
                        const Text(
                          'MEDIUM',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(height: 10),
                        buildStockSummaryDataTable(data.data![2]),
                        const SizedBox(height: 50),
                        const Text(
                          'PREMIUM',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(height: 10),
                        buildStockSummaryDataTable(data.data![3]),
                        const SizedBox(height: 50),
                        const Text(
                          'IMFL',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(height: 10),
                        buildStockSummaryDataTableIMFL(data.data![4]),
                        const SizedBox(height: 50),
                        const Text(
                          'BEER',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(height: 10),
                        buildBeerStockSummaryDataTable(data.data![5]),
                        const SizedBox(height: 50),
                        const Text(
                          'IMFL + BEER',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(height: 10),
                        buildImflAndBeerStockSummaryDataTable(data.data![6]),
                        const SizedBox(height: 20),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<List<List<String>>>> getData() async {
    List<List<List<String>>> datas = await _summaryController.data();
    print('datasdatas $datas');
    return datas;
  }

  void getSalesData() async {
    List<Map<String, dynamic>> salesValue = await _summaryController
        .salesCompletedData();
    setState(() {
      salesData = salesValue;
    });
  }
}

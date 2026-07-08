import 'package:flutter/material.dart';
import 'package:stock_app_web/core/utils/format_date.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/models/inward_table_model.dart';

class ReceiptDailyFolderPage extends StatefulWidget {
  final String monthAndYear;

  const ReceiptDailyFolderPage({super.key, required this.monthAndYear});

  @override
  State<ReceiptDailyFolderPage> createState() => _ReceiptDailyFolderPageState();
}

class _ReceiptDailyFolderPageState extends State<ReceiptDailyFolderPage> {
  List<InwardDailyFolderModel> dailyData = [];

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: dailyData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: InkWell(
                      onTap: () {
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => InwardPage(
                        //       invoiceNo: '${data[index]['invoiceNo']}',
                        //       date: '${data[index]['date']}',
                        //     ),
                        //   ),
                        // );
                      },
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black38,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              title: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 19,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'invoiceNo : ',
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${dailyData[index].invoiceNo} ',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          ' (${formatYYYYMMDDToDDMMYYYY(dailyData[index].date)}) ',
                                    ),
                                    TextSpan(
                                      text: '\nIMFL Rs.',
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '${dailyData[index].imfTotalPrice} ',
                                      style: const TextStyle(
                                        color: Colors.purpleAccent,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\nBEER Rs.',
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '${dailyData[index].beerTotalPrice}',
                                      style: const TextStyle(
                                        color: Colors.purpleAccent,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\nTOTAL Rs.',
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '${dailyData[index].imflAndBeerTotal}',
                                      style: const TextStyle(
                                        color: Colors.purpleAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: const Icon(Icons.navigate_next),
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
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
}

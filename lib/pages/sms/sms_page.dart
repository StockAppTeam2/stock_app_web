import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/sms_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/pages/sms/sms_page_widgets.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class SmsPage extends StatefulWidget {
  const SmsPage({super.key});

  @override
  State<SmsPage> createState() => _SmsPageState();
}

class _SmsPageState extends State<SmsPage> {
  final smsController = getIt<SmsController>();
  final _viewDateController = getIt<ViewDateController>();

  bool removeSmsFirstStar = false;
  bool removeSmsEndStar = false;
  String formattedSmsText = '';

  int? shopId;
  String? smsDate;

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SMS', style: TextStyle(fontSize: 20)),
                ElevatedButton(
                  onPressed: () {
                    final textToShare = removeSmsFirstStar
                        ? "$shopId*$smsDate$formattedSmsText"
                        : "*$shopId*$smsDate$formattedSmsText";

                    Clipboard.setData(ClipboardData(text: textToShare));

                    showSuccessToast('Sms Copied');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  child: Text('Prepare SMS', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: getData(),
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
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Table(
                              columnWidths: {
                                0: FixedColumnWidth(width * 0.45),
                                1: FixedColumnWidth(width * 0.05),
                                2: FixedColumnWidth(width * 0.50),
                              },

                              children: [
                                // Custom first row
                                const TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        'SALES',
                                        style: TextStyle(
                                          color: Color(0xFF800000),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(),
                                    SizedBox(),
                                  ],
                                ),

                                // Data rows
                                ...products.map((data) {
                                  return TableRow(
                                    children: [
                                      nameText(data[1]),
                                      colonText(),
                                      valueText(data[0]),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<dynamic>> getData() async {
    String shopId = await getIt<ShopIdController>().getShopId();
    List<List<dynamic>> oneDayReport = await smsController.oneDayCalc();
    print("oneDayReport $oneDayReport");

    List<List<dynamic>> arrangedList = [];
    String textSms = '';
    List<dynamic> smsList = [];
    List<dynamic> orderList = await smsController.getSmsFormat(
      int.parse(shopId),
    );
    print('orderListss $orderList');

    for (final order in orderList[0]) {
      print('order $order');
      for (final report in oneDayReport) {
        if (order == report[1]) {
          smsList.add(
            (report[0] as int).isNegative ? '0' : report[0].toString(),
          );
          arrangedList.add(report);
          print('reportcc  ${report[0]}, report[1], ${report[1]}');
          print('smsListssss $smsList');
          print('arrangedList33 $arrangedList');
          print('textSms $textSms');
        }
      }
    }
    // print('arrangedList $arrangedList');
    if (oneDayReport != null && oneDayReport.isNotEmpty) {
      String smsText = smsList.map((e) => '*$e').join();
      if (!smsText.endsWith('*')) {
        smsText += '*';
      }

      if (orderList[2] == true) {
        if (smsText.endsWith('*')) {
          smsText = smsText.substring(0, smsText.length - 1);
        }
      }

      print('smsText $smsText');
      // if (mounted) {
      // setState(() {
      removeSmsFirstStar = orderList[1];
      removeSmsEndStar = orderList[2];
      formattedSmsText = smsText;
      // oneDaySaleSummary = arrangedList;
      // });
      // }
      print('formattedSmsText $formattedSmsText');
      String value = await _viewDateController.getViewDateForUi();

      this.shopId = int.parse(shopId);
      smsDate = value;

      return arrangedList;
    }
    return [
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
    ];
  }
}

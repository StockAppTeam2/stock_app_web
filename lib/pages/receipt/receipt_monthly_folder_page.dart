import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/pages/widgets/youtube_button.dart';

class ReceiptMonthlyFolderPage extends StatefulWidget {
  const ReceiptMonthlyFolderPage({super.key});

  @override
  State<ReceiptMonthlyFolderPage> createState() =>
      _ReceiptMonthlyFolderPageState();
}

class _ReceiptMonthlyFolderPageState extends State<ReceiptMonthlyFolderPage> {
  List<String> receiptDates = [];

  @override
  void initState() {
    super.initState();
    getReceiptDates();
  }

  void getReceiptDates() async {
    // List<String> dates = await inwardDatabaseHelper.getInwardValueAllDate();
    List<String> dates = [];
    DateTime dateTime = DateTime.now();
    for (int i = 0; i < 70; i++) {
      dates.add(dateTime.add(Duration(days: i)).toString().substring(0, 10));
      print(
        'date ${dateTime.add(Duration(days: i)).toString().substring(0, 10)}',
      );
    }
    List<String> convertedDate = [];

    for (String date in dates) {
      DateTime dateTime = DateTime.parse(date);

      String formattedDate = DateFormat(
        'MMMM yyyy',
      ).format(dateTime); //May 2024
      print('dare $formattedDate');
      if (!convertedDate.contains(formattedDate)) {
        convertedDate.add(formattedDate);
      }
    }

    setState(() {
      receiptDates = convertedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              YoutubeButton(url: ''),
              ElevatedButton(
                onPressed: () {},
                child: Row(children: [Text('Add Purchase'), Icon(Icons.add)]),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: receiptDates.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 1.0,
                  child: ListTile(
                    title: Text(receiptDates[index]),
                    trailing: const Icon(Icons.navigate_next),
                    onTap: () {
                      DateTime convert = DateFormat(
                        'MMMM yyyy',
                      ).parse(receiptDates[index]);
                      String output = DateFormat('yyyy-MM').format(convert);
                      // Outputs: 2024-05
                      context.go(
                        AppRoutes.receiptDailyFolder,
                        extra: {'monthAndYear': output},
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

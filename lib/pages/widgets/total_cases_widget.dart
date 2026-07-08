import 'package:flutter/material.dart';
import 'package:stock_app_web/models/items_table_model.dart';

class TotalCasesWidget extends StatefulWidget {
  final List modelData;

  const TotalCasesWidget({super.key, required this.modelData});

  @override
  State<TotalCasesWidget> createState() => _TotalCasesWidgetState();
}

class _TotalCasesWidgetState extends State<TotalCasesWidget> {
  int totalImflCases = 0;
  int totalBeerCases = 0;
  int totalCases = 0;

  @override
  void initState() {
    super.initState();
    itemsViewModelCalc();
  }

  void itemsViewModelCalc() async {
    print('itemsViewModelCalc called');
    print('itemsViewModelCalc called ${widget.modelData.length}');
    int totalImflCases1 = 0;
    int totalBeerCases1 = 0;

    for (ItemsViewModel item in widget.modelData as List<ItemsViewModel>) {
      // print('item: ${item.toMap()} : ${item.itemsGroup}');
      if (item.itemsGroup == 'IMFL') {
        totalImflCases1 += item.openingBundle;
      } else if (item.itemsGroup == 'BEER') {
        totalBeerCases1 += item.openingBundle;
      }
    }

    setState(() {
      totalImflCases = totalImflCases1;
      totalBeerCases = totalBeerCases1;
      totalCases = totalImflCases1 + totalBeerCases1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Wrap(
        spacing: 20,
        runSpacing: 10,
        children: [
          summaryTail('Total IMFL Case', totalImflCases),
          summaryTail('Total BEER Case', totalBeerCases),
          summaryTail('Total Case', totalCases),
        ],
      ),
    );
  }

  RichText summaryTail(String title, int value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        children: [
          TextSpan(
            text: "$title : ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '$value',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

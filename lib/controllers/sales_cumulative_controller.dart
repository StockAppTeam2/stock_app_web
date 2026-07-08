import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stock_app_web/models/sales_cumulative_model.dart';

class SalesCumulativeController {
  Future<Map<String, dynamic>> getSalesCumulative(
    String shopId,
    String date,
  ) async {
    DocumentSnapshot documentSnapshotSalesCumulative = await FirebaseFirestore
        .instance
        .collection('sales')
        .doc(shopId)
        .collection('salesCumulative')
        .doc(date)
        .get();
    if (documentSnapshotSalesCumulative.exists) {
      Map<String, dynamic> data =
          documentSnapshotSalesCumulative.data() as Map<String, dynamic>;

      if (data.isNotEmpty) {
        return data;
      }
    }
    return {};
  }

  Future<List> salesCumulativeCalculation(
    String shopId,
    DateTime inputDate,
  ) async {
    List<dynamic> salesCumulativeAdjustment = [inputDate, '0', '0', '0'];
    List<SalesCumulativeModel> salesCumulativeData = [];

    //Adjustment
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // List<String>? salesCumulativeAdjustment = preferences.getStringList(
    //   'form49SalesCumulativeAdjustment',
    // );

    List<String> previousGeneratedDates = [];

    int year = inputDate.year;
    int month = inputDate.month;
    int day = inputDate.day;

    for (int d = day; d >= 1; d--) {
      previousGeneratedDates.add(
        DateTime(year, month, d).toString().split(' ')[0],
      );
    }

    if (previousGeneratedDates.isNotEmpty) {
      for (String date in previousGeneratedDates) {
        Map<String, dynamic> map = await getSalesCumulative(shopId, date);
        print('salesCumulative form 43 $date');

        if (map.isNotEmpty) {
          salesCumulativeData.add(SalesCumulativeModel.forMap(map));
        }
      }
    }

    int imflCumulativeCases = salesCumulativeData.fold(
      0,
      (previousValue, element) => previousValue + element.imflCumulativeCases,
    );
    int beerCumulativeCases = salesCumulativeData.fold(
      0,
      (previousValue, element) => previousValue + element.beerCumulativeCases,
    );
    int totalCumulative = salesCumulativeData.fold(
      0,
      (previousValue, element) => previousValue + element.totalCumulative,
    );
    print(
      '######%2 $imflCumulativeCases, $beerCumulativeCases, $totalCumulative',
    );

    if (salesCumulativeAdjustment.isEmpty) {
      print('hi#####################hi');
      String firstOpDate = salesCumulativeAdjustment[0].toString().substring(
        0,
        10,
      );
      int salesValue = int.parse(salesCumulativeAdjustment[1]);
      int salesImflCase = int.parse(salesCumulativeAdjustment[2]);
      int salesBeerCase = int.parse(salesCumulativeAdjustment[3]);
      print(
        '######%1 $firstOpDate, $salesValue, $salesImflCase, $salesBeerCase',
      );

      // DateTime dateTime = DateFormat('dd/MM/yyyy').parse(firstOpDate);
      DateTime dateTime = DateTime.parse(firstOpDate);

      int adjustmentMonth = dateTime.month;
      int adjustmentYear = dateTime.year;
      print('######% $dateTime, $adjustmentMonth');
      if (month == adjustmentMonth && year == adjustmentYear) {
        imflCumulativeCases += salesImflCase;
        beerCumulativeCases += salesBeerCase;
        totalCumulative += salesValue;
      }
    }

    return [imflCumulativeCases, beerCumulativeCases, totalCumulative];
  }
}

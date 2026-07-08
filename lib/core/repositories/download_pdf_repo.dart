import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stock_app_web/controllers/pos_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/firestore_repo.dart';
import 'package:stock_app_web/core/utils/format_date.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:stock_app_web/models/brand_model.dart';
import 'package:stock_app_web/models/inward_table_model.dart';
import 'package:stock_app_web/models/items_table_model.dart';
import 'package:stock_app_web/models/sales_table_model.dart';
import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;

class DownloadPdfRepo {
  final _viewDateController = getIt<ViewDateController>();
  final _fireRepo = getIt<FirestoreRepo>();

  Future<void> downloadEmptyPdf(
    BuildContext context,
    bool isDailyStatement,
    bool isSmsPage,
  ) async {
    print('DownloadPdf $isDailyStatement');

    bool isConnected = await InternetConnection().hasInternetAccess;

    final city = '';
    int shopId = 3810;

    String value = await _viewDateController.getViewDateForUi();
    String date = formatYYYYMMDDToDDMMYYYY(value);

    String? salesCumulativeVal;

    int totalOpeningBottles = 0;
    int totalPurchaseBottles = 0;
    int totalOpeningAndPurchaseBottles = 0;
    int totalClosingBottles = 0;
    int totalSalesBottles = 0;
    int totalProductValue = 0;

    int totalMediumOpeningBottles = 0;
    int totalMediumPurchaseBottles = 0;
    int totalMediumOpeningAndPurchaseBottles = 0;
    int totalMediumClosingBottles = 0;
    int totalMediumSalesBottles = 0;
    int totalMediumProductValue = 0;
    int totalPremiumOpeningBottles = 0;
    int totalPremiumPurchaseBottles = 0;
    int totalPremiumOpeningAndPurchaseBottles = 0;
    int totalPremiumClosingBottles = 0;
    int totalPremiumSalesBottles = 0;
    int totalPremiumProductValue = 0;

    int totalBeerOpeningBottles = 0;
    int totalBeerPurchaseBottles = 0;
    int totalBeerOpeningAndPurchaseBottles = 0;
    int totalBeerClosingBottles = 0;
    int totalBeerSalesBottles = 0;
    int totalBeerProductValue = 0;

    int totalOpeningValue = 0;
    int totalPurchaseValue = 0;
    int totalClosingValue = 0;

    int totalMediumOpeningValue = 0;
    int totalMediumPurchaseValue = 0;
    int totalMediumClosingValue = 0;
    int totalPremiumOpeningValue = 0;
    int totalPremiumPurchaseValue = 0;
    int totalPremiumClosingValue = 0;
    int totalBeerOpeningValue = 0;
    int totalBeerPurchaseValue = 0;
    int totalBeerClosingValue = 0;

    int posMachineValuePerDay = 0;
    int posMonthlyCumulation = 0;

    List<dynamic> ordinaryOneEight = [];
    List<dynamic> ordianryThreeSeventyFiveDatas = [];
    List<dynamic> ordinarySevenFiftyDatas = [];
    List<dynamic> ordinaryOneThousandDatas = [];
    List<dynamic> mediumOneEight = [];
    List<dynamic> mediumThreeSeventyFiveDatas = [];
    List<dynamic> mediumSevenFiftyDatas = [];
    List<dynamic> mediumOneThousandDatas = [];
    List<dynamic> premiumOneEight = [];
    List<dynamic> premiumThreeSeventyFiveDatas = [];
    List<dynamic> premiumSevenFiftyDatas = [];
    List<dynamic> premiumOneThousandDatas = [];

    List<dynamic> ordinaryDetails = [];
    List<dynamic> mediumDetails = [];
    List<dynamic> premiumDetails = [];
    List<dynamic> beerDetails = [];

    final pdf = pw.Document();

    final List tableItems = await downloadPdf(
      isDailyStatement,
      DateTime.parse(value),
    );

    print('tableItemstableItems $tableItems');

    if (isDailyStatement == true) {
      final tableLastRows = tableItems[1];
      final purchaseBtlCount = tableItems[2];
      final totalOpeningAndPurchaseBtlCount = tableItems[3];
      final totalClosingBtlCount = tableItems[4];
      final totalSalesBtlCount = tableItems[5];
      final totalValue = tableItems[6];
      final beerTableData = tableItems[7];
      final beerOpeningBtlCount = tableItems[8];
      final beerPurchaseBtlCount = tableItems[9];
      final totalBeerOpeningAndPurchaseBtlCount = tableItems[10];
      final totalBeerClosingBtlCount = tableItems[11];
      final totalBeerSalesBtlCount = tableItems[12];
      final totalBeerValue = tableItems[13];
      final ordinaryTableData = tableItems[14];
      final mediumTableData = tableItems[15];
      final premiumTableData = tableItems[16];
      final mediumTotalValue = tableItems[17];
      final totalMediumSalesBtlCount = tableItems[18];
      final totalMediumClosingBtlCount = tableItems[19];
      final totalMediumOpeningAndPurchaseBtlCount = tableItems[20];
      final mediumPurchaseBtlCount = tableItems[21];
      final mediumOpeningBtlCount = tableItems[22];

      final premiumOpeningBtlCount = tableItems[23];
      final premiumPurchaseBtlCount = tableItems[24];
      final totalPremiumOpeningAndPurchaseBtlCount = tableItems[25];
      final totalPremiumClosingBtlCount = tableItems[26];
      final totalPremiumSalesBtlCount = tableItems[27];
      final premiumTotalValue = tableItems[28];
      final totalOpeningValueList = tableItems[29];
      final totalMediumValueList = tableItems[30];
      final totalPremiumValueList = tableItems[31];
      final totalBeerValueList = tableItems[32];
      final salesCumulative = tableItems[33];

      print('salesCumulative5655 $salesCumulative');

      final posVal = tableItems[106];

      posMachineValuePerDay = posVal[0];
      posMonthlyCumulation = posVal[1];

      final closingPdfStatus = tableItems[107];

      final closingPdfFormat = closingPdfStatus[0];

      print('closingPdfFormat22 $closingPdfFormat');

      final brandOrderDetails = tableItems[108];

      final totalOrdinaryLastRow = tableItems[109];
      final totalMediumLastRow = tableItems[110];
      final totalPremiumLastRow = tableItems[111];
      final bottleOpCountDetail = tableItems[112];
      final bottleReceiptCountDetail = tableItems[113];
      final bottleActualCountDetail = tableItems[114];
      final bottleClosingCountDetail = tableItems[115];
      final bottleSalesCountDetail = tableItems[116];
      final beerBottleOpCount = tableItems[117];
      final beerBottleReceiptCount = tableItems[118];
      final beerBottleActualCount = tableItems[119];
      final beerBottleClosingCount = tableItems[120];
      final beerBottleSalesCount = tableItems[121];
      final imflValues = tableItems[122];
      final beerValues = tableItems[123];
      final ImflAndBeerValues = tableItems[124];

      List<int> ordianryItems = await ordinaryDatas([
        tableItems[34],
        tableItems[35],
        tableItems[36],
        tableItems[37],
        tableItems[38],
        tableItems[39],
        tableItems[40],
        tableItems[41],
        tableItems[42],
        tableItems[43],
        tableItems[44],
        tableItems[45],
        tableItems[46],
        tableItems[47],
        tableItems[48],
        tableItems[49],
        tableItems[50],
        tableItems[51],
        tableItems[52],
        tableItems[53],
        tableItems[54],
        tableItems[55],
        tableItems[56],
        tableItems[57],
      ]);

      int OrdinaryOneEightyOpeningBtlsCount = 0;
      int OrdinaryOneEightyPurchaseBtlsCount = 0;
      int OrdinaryOneEightyOpeingAndPurchaseBtlsCount = 0;
      int OrdinaryOneEightyClosingBtlsCount = 0;
      int OrdinaryOneEightySalesBtlsCount = 0;
      int OrdinaryOneEightyTotalValues = 0;

      int ordinaryThreeSeventyFiveOpBtlsCount = 0;
      int ordinaryThreeSeventyFivePurchaseBtlsCount = 0;
      int ordinaryThreeSeventyFiveOpeingAndPurchaseBtlsCount = 0;
      int ordinaryThreeSeventyFiveClosingBtlsCount = 0;
      int ordinaryThreeSeventyFiveSalesBtlsCount = 0;
      int ordinaryThreeSeventyFiveTotalValuesCount = 0;

      int ordinarySevenFiftyOpBtlsCount = 0;
      int ordinarySevenFiftyPurchaseBtlsCount = 0;
      int ordinarySevenFiftyOpeingAndPurchaseBtlsCount = 0;
      int ordinarySevenFiftyClosingBtlsCount = 0;
      int ordinarySevenFiftySalesBtlsCount = 0;
      int ordinarySevenFiftyTotalValuesCount = 0;

      int ordinaryOneThousandOpBtlsCount = 0;
      int ordinaryOneThousandPurchaseBtlsCount = 0;
      int ordinaryOneThousandOpeingAndPurchaseBtlsCount = 0;
      int ordinaryOneThousandClosingBtlsCount = 0;
      int ordinaryOneThousandSalesBtlsCount = 0;
      int ordinaryOneThousandTotalValuesCount = 0;

      OrdinaryOneEightyOpeningBtlsCount = ordianryItems[0];
      OrdinaryOneEightyPurchaseBtlsCount = ordianryItems[1];
      OrdinaryOneEightyOpeingAndPurchaseBtlsCount = ordianryItems[2];
      OrdinaryOneEightyClosingBtlsCount = ordianryItems[3];
      OrdinaryOneEightySalesBtlsCount = ordianryItems[4];
      OrdinaryOneEightyTotalValues = ordianryItems[5];

      ordinaryThreeSeventyFiveOpBtlsCount = ordianryItems[6];
      ordinaryThreeSeventyFivePurchaseBtlsCount = ordianryItems[7];
      ordinaryThreeSeventyFiveOpeingAndPurchaseBtlsCount = ordianryItems[8];
      ordinaryThreeSeventyFiveClosingBtlsCount = ordianryItems[9];
      ordinaryThreeSeventyFiveSalesBtlsCount = ordianryItems[10];
      ordinaryThreeSeventyFiveTotalValuesCount = ordianryItems[11];

      ordinarySevenFiftyOpBtlsCount = ordianryItems[12];
      ordinarySevenFiftyPurchaseBtlsCount = ordianryItems[13];
      ordinarySevenFiftyOpeingAndPurchaseBtlsCount = ordianryItems[14];
      ordinarySevenFiftyClosingBtlsCount = ordianryItems[15];
      ordinarySevenFiftySalesBtlsCount = ordianryItems[16];
      ordinarySevenFiftyTotalValuesCount = ordianryItems[17];

      ordinaryOneThousandOpBtlsCount = ordianryItems[18];
      ordinaryOneThousandPurchaseBtlsCount = ordianryItems[19];
      ordinaryOneThousandOpeingAndPurchaseBtlsCount = ordianryItems[20];
      ordinaryOneThousandClosingBtlsCount = ordianryItems[21];
      ordinaryOneThousandSalesBtlsCount = ordianryItems[22];
      ordinaryOneThousandTotalValuesCount = ordianryItems[23];

      print('totalOrdinaryLastRow22 $totalOrdinaryLastRow');

      List<int> mediumItems = await mediumDatas([
        tableItems[58],
        tableItems[59],
        tableItems[60],
        tableItems[61],
        tableItems[62],
        tableItems[63],
        tableItems[64],
        tableItems[65],
        tableItems[66],
        tableItems[67],
        tableItems[68],
        tableItems[69],
        tableItems[70],
        tableItems[71],
        tableItems[72],
        tableItems[73],
        tableItems[74],
        tableItems[75],
        tableItems[76],
        tableItems[77],
        tableItems[78],
        tableItems[79],
        tableItems[80],
        tableItems[81],
      ]);

      final mediumOneEightyOpBtlsCount = mediumItems[0];
      final mediumOneEightyPurchaseBtlsCount = mediumItems[1];
      final mediumOneEightyOpeingAndPurchaseBtlsCount = mediumItems[2];
      final mediumOneEightyClosingBtlsCount = mediumItems[3];
      final mediumOneEightySalesBtlsCount = mediumItems[4];
      final mediumOneEightyTotalValuesCount = mediumItems[5];

      final mediumThreeSeventyFiveOpBtlsCount = mediumItems[6];
      final mediumThreeSeventyFivePurchaseBtlsCount = mediumItems[7];
      final mediumThreeSeventyFiveOpeingAndPurchaseBtlsCount = mediumItems[8];
      final mediumThreeSeventyFiveClosingBtlsCount = mediumItems[9];
      final mediumThreeSeventyFiveSalesBtlsCount = mediumItems[10];
      final mediumThreeSeventyFiveTotalValuesCount = mediumItems[11];

      final mediumSevenFiftyOpBtlsCount = mediumItems[12];
      final mediumSevenFiftyPurchaseBtlsCount = mediumItems[13];
      final mediumSevenFiftyOpeingAndPurchaseBtlsCount = mediumItems[14];
      final mediumSevenFiftyClosingBtlsCount = mediumItems[15];
      final mediumSevenFiftySalesBtlsCount = mediumItems[16];
      final mediumSevenFiftyTotalValuesCount = mediumItems[17];

      final mediumOneThousandOpBtlsCount = mediumItems[18];
      final mediumOneThousandPurchaseBtlsCount = mediumItems[19];
      final mediumOneThousandOpeingAndPurchaseBtlsCount = mediumItems[20];
      final mediumOneThousandClosingBtlsCount = mediumItems[21];
      final mediumOneThousandSalesBtlsCount = mediumItems[22];
      final mediumOneThousandTotalValuesCount = mediumItems[23];

      List<int> premiumItems = await premiumDatas([
        tableItems[82],
        tableItems[83],
        tableItems[84],
        tableItems[85],
        tableItems[86],
        tableItems[87],
        tableItems[88],
        tableItems[89],
        tableItems[90],
        tableItems[91],
        tableItems[92],
        tableItems[93],
        tableItems[94],
        tableItems[95],
        tableItems[96],
        tableItems[97],
        tableItems[98],
        tableItems[99],
        tableItems[100],
        tableItems[101],
        tableItems[102],
        tableItems[103],
        tableItems[104],
        tableItems[105],
      ]);

      final premiumOneEightyOpBtlsCount = premiumItems[0];
      final premiumOneEightyPurchaseBtlsCount = premiumItems[1];
      final premiumOneEightyOpeingAndPurchaseBtlsCount = premiumItems[2];
      final premiumOneEightyClosingBtlsCount = premiumItems[3];
      final premiumOneEightySalesBtlsCount = premiumItems[4];
      final premiumOneEightyTotalValuesCount = premiumItems[5];

      final premiumThreeSeventyFiveOpBtlsCount = premiumItems[6];
      final premiumThreeSeventyFivePurchaseBtlsCount = premiumItems[7];
      final premiumThreeSeventyFiveOpeingAndPurchaseBtlsCount = premiumItems[8];
      final premiumThreeSeventyFiveClosingBtlsCount = premiumItems[9];
      final premiumThreeSeventyFiveSalesBtlsCount = premiumItems[10];
      final premiumThreeSeventyFiveTotalValuesCount = premiumItems[11];

      final premiumSevenFiftyOpBtlsCount = premiumItems[12];
      final premiumSevenFiftyPurchaseBtlsCount = premiumItems[13];
      final premiumSevenFiftyOpeingAndPurchaseBtlsCount = premiumItems[14];
      final premiumSevenFiftyClosingBtlsCount = premiumItems[15];
      final premiumSevenFiftySalesBtlsCount = premiumItems[16];
      final premiumSevenFiftyTotalValuesCount = premiumItems[17];

      final premiumOneThousandOpBtlsCount = premiumItems[18];
      final premiumOneThousandPurchaseBtlsCount = premiumItems[19];
      final premiumOneThousandOpeingAndPurchaseBtlsCount = premiumItems[20];
      final premiumOneThousandClosingBtlsCount = premiumItems[21];
      final premiumOneThousandSalesBtlsCount = premiumItems[22];
      final premiumOneThousandTotalValuesCount = premiumItems[23];

      final imflDatas = await filterPdfData(
        ordinaryTableData,
        mediumTableData,
        premiumTableData,
        closingPdfFormat,
        brandOrderDetails,
        beerTableData,
      );

      if (closingPdfFormat == 'size wise') {
        ordinaryOneEight = imflDatas[0];
        ordianryThreeSeventyFiveDatas = imflDatas[3];
        ordinarySevenFiftyDatas = imflDatas[6];
        ordinaryOneThousandDatas = imflDatas[9];

        mediumOneEight = imflDatas[1];
        mediumThreeSeventyFiveDatas = imflDatas[4];
        mediumSevenFiftyDatas = imflDatas[7];
        mediumOneThousandDatas = imflDatas[10];

        premiumOneEight = imflDatas[2];
        premiumThreeSeventyFiveDatas = imflDatas[5];
        premiumSevenFiftyDatas = imflDatas[8];
        premiumOneThousandDatas = imflDatas[11];
      } else if (closingPdfFormat == 'default') {
        ordinaryDetails = imflDatas[0];
        mediumDetails = imflDatas[1];
        premiumDetails = imflDatas[2];
        beerDetails = imflDatas[3];
      }

      print('ordinaryDetailsordinaryDetails222 $ordinaryDetails');

      if (isConnected != true) {
        salesCumulativeVal = 'Not connected';
      } else {
        int salesCumulativeValue = salesCumulative.last;
        salesCumulativeVal = salesCumulativeValue.toString();
      }

      for (List<int> val in totalOpeningValueList) {
        totalOpeningValue += val[0];
        totalPurchaseValue += val[1];
        totalClosingValue += val[2];
      }

      for (List<int> val in totalMediumValueList) {
        totalMediumOpeningValue += val[0];
        totalMediumPurchaseValue += val[1];
        totalMediumClosingValue += val[2];
      }

      for (List<int> val in totalPremiumValueList) {
        totalPremiumOpeningValue += val[0];
        totalPremiumPurchaseValue += val[1];
        totalPremiumClosingValue += val[2];
      }

      for (List<int> val in totalBeerValueList) {
        totalBeerOpeningValue += val[0];
        totalBeerPurchaseValue += val[1];
        totalBeerClosingValue += val[2];
      }

      for (int val in tableLastRows) {
        totalOpeningBottles += val;
      }
      for (int val in purchaseBtlCount) {
        totalPurchaseBottles += val;
      }
      for (int val in totalOpeningAndPurchaseBtlCount) {
        totalOpeningAndPurchaseBottles += val;
      }
      for (int val in totalClosingBtlCount) {
        totalClosingBottles += val;
      }
      for (int val in totalSalesBtlCount) {
        totalSalesBottles += val;
      }
      for (int val in totalValue) {
        totalProductValue += val;
      }

      for (int val in mediumOpeningBtlCount) {
        totalMediumOpeningBottles += val;
      }
      for (int val in mediumPurchaseBtlCount) {
        totalMediumPurchaseBottles += val;
      }
      for (int val in totalMediumOpeningAndPurchaseBtlCount) {
        totalMediumOpeningAndPurchaseBottles += val;
      }
      for (int val in totalMediumClosingBtlCount) {
        totalMediumClosingBottles += val;
      }
      for (int val in totalMediumSalesBtlCount) {
        totalMediumSalesBottles += val;
      }
      for (int val in mediumTotalValue) {
        totalMediumProductValue += val;
      }

      for (int val in premiumOpeningBtlCount) {
        totalPremiumOpeningBottles += val;
      }
      for (int val in premiumPurchaseBtlCount) {
        totalPremiumPurchaseBottles += val;
      }
      for (int val in totalPremiumOpeningAndPurchaseBtlCount) {
        totalPremiumOpeningAndPurchaseBottles += val;
      }
      for (int val in totalPremiumClosingBtlCount) {
        totalPremiumClosingBottles += val;
      }
      for (int val in totalPremiumSalesBtlCount) {
        totalPremiumSalesBottles += val;
      }
      for (int val in premiumTotalValue) {
        totalPremiumProductValue += val;
      }

      for (int val in totalBeerValue) {
        totalBeerProductValue += val;
      }
      for (int val in beerPurchaseBtlCount) {
        totalBeerPurchaseBottles += val;
      }
      for (int val in totalBeerOpeningAndPurchaseBtlCount) {
        totalBeerOpeningAndPurchaseBottles += val;
      }
      for (int val in totalBeerClosingBtlCount) {
        totalBeerClosingBottles += val;
      }
      for (int val in totalBeerSalesBtlCount) {
        totalBeerSalesBottles += val;
      }
      for (int val in beerOpeningBtlCount) {
        totalBeerOpeningBottles += val;
      }

      int totalImflSales =
          totalProductValue +
          totalMediumProductValue +
          totalPremiumProductValue;

      int totalImflOpeningValue =
          totalOpeningValue +
          totalMediumOpeningValue +
          totalPremiumOpeningValue;

      int totalImflPurchaseValue =
          totalPurchaseValue +
          totalMediumPurchaseValue +
          totalPremiumPurchaseValue;

      int totalImflOpeningAndPurcahse =
          totalImflOpeningValue + totalImflPurchaseValue;

      int totalImflClosingValue =
          totalClosingValue +
          totalMediumClosingValue +
          totalPremiumClosingValue;

      int totalImflSalesValue =
          totalProductValue +
          totalMediumProductValue +
          totalPremiumProductValue;

      int totalBeerOpeingAndPurchaseValue =
          totalBeerOpeningValue + totalBeerPurchaseValue;

      int totalImflAndBeerOpening =
          totalBeerOpeningValue + totalImflOpeningValue;
      int totalImflAndBeerPurchase =
          totalBeerPurchaseValue + totalImflPurchaseValue;
      int totalImflAndBeerOpAndPurchase =
          totalImflOpeningAndPurcahse + totalBeerOpeingAndPurchaseValue;
      int totalImflAndBeerClosing =
          totalImflClosingValue + totalBeerClosingValue;
      int totalImflAndBeerSales = totalImflSalesValue + totalBeerProductValue;

      String totalImflAndBeerOpeningVal = totalImflAndBeerOpening.toString();
      String totalImflAndBeerPurchaseVal = totalImflAndBeerPurchase.toString();
      String totalImflAndBeerOpAndPurchaseVal = totalImflAndBeerOpAndPurchase
          .toString();
      String totalImflAndBeerClosingVal = totalImflAndBeerClosing.toString();
      String totalImflAndBeerSalesVal = totalImflAndBeerSales.toString();

      String totalOpeningVal = totalOpeningValue.toString();
      String totalPurchaseVal = totalPurchaseValue.toString();
      String totalClosingVal = totalClosingValue.toString();
      String totalMediumOpeningVal = totalMediumOpeningValue.toString();
      String totalMediumPurchaseVal = totalMediumPurchaseValue.toString();
      String totalMediumClosingVal = totalMediumClosingValue.toString();
      String totalPremiumOpeningVal = totalPremiumOpeningValue.toString();
      String totalPremiumPurchaseVal = totalPremiumPurchaseValue.toString();
      String totalPremiumClosingVal = totalPremiumClosingValue.toString();
      String totalBeerOpeningVal = totalBeerOpeningValue.toString();
      String totalBeerPurchaseVal = totalBeerPurchaseValue.toString();
      String totalBeerClosingVal = totalBeerClosingValue.toString();

      String totalImflSale = totalImflSales.toString();
      String totalImflOpeningVal = totalImflOpeningValue.toString();
      String totalImflPurchaseVal = totalImflPurchaseValue.toString();
      String totalImflOpeningAndPurcahseVal = totalImflOpeningAndPurcahse
          .toString();
      String totalImflClosingVal = totalImflClosingValue.toString();
      String totalImflSalesVal = totalImflSalesValue.toString();
      String totalBeerOpeingAndPurchaseVal = totalBeerOpeingAndPurchaseValue
          .toString();

      String totalVal = totalProductValue.toString();

      String totalMediumVal = totalMediumProductValue.toString();

      String totalPremiumVal = totalPremiumProductValue.toString();

      String totalBeerOpeningBtl = totalBeerOpeningBottles.toString();
      String totalBeerPurchaseBtl = totalBeerPurchaseBottles.toString();
      String totalBeerOpeningAndPurchaseBtl = totalBeerOpeningAndPurchaseBottles
          .toString();
      String totalBeerClosingBtl = totalBeerClosingBottles.toString();
      String totalBeerSalesBtl = totalBeerSalesBottles.toString();
      String totalBeerProductVal = totalBeerProductValue.toString();

      final font = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');

      final ttf = pw.Font.ttf(font);

      List<List<String>> tableHeader = [];
      if (closingPdfFormat == 'size wise') {
        tableHeader = [
          [
            'Code',
            'Brand',
            'Category',

            'MRP',
            'Opening',
            'Purchase',
            'Total',
            'Closing',
            'Sales',
            'Value in Rs',
          ],
        ];
      } else if (closingPdfFormat == 'default') {
        tableHeader = [
          [
            'Code',
            'Brand',
            'Category',
            'Size',
            'MRP',
            'Opening',
            'Purchase',
            'Total',
            'Closing',
            'Sales',
            'Value in Rs',
          ],
        ];
      }

      final brandOrderBeerHeader = [
        [
          'Code',
          'Brand',

          'Size ',
          'Range',
          'MRP',
          'Opening',
          'Purchase',
          'Total',
          'Closing',
          'Sales',
          'Value in Rs',
        ],
      ];

      final beerHeader = [
        [
          'Code',
          'Brand',

          'Size in ml',
          'Range',
          'MRP',
          'Opening',
          'Purchase',
          'Total',
          'Closing',
          'Sales',
          'Value in Rs',
        ],
      ];

      final ordinaryOneEightyLastRow = [
        [
          '',
          '',
          '',
          '',
          OrdinaryOneEightyOpeningBtlsCount.toString(),
          OrdinaryOneEightyPurchaseBtlsCount.toString(),
          OrdinaryOneEightyOpeingAndPurchaseBtlsCount.toString(),
          OrdinaryOneEightyClosingBtlsCount.toString(),
          OrdinaryOneEightySalesBtlsCount.toString(),
          OrdinaryOneEightyTotalValues.toString(),
        ],
      ];

      final ordianryThreeSeventyFiveLastRow = [
        [
          '',
          '',
          '',
          '',
          ordinaryThreeSeventyFiveOpBtlsCount.toString(),
          ordinaryThreeSeventyFivePurchaseBtlsCount.toString(),
          ordinaryThreeSeventyFiveOpeingAndPurchaseBtlsCount.toString(),
          ordinaryThreeSeventyFiveClosingBtlsCount.toString(),
          ordinaryThreeSeventyFiveSalesBtlsCount.toString(),
          ordinaryThreeSeventyFiveTotalValuesCount.toString(),
        ],
      ];

      final ordinarySevenFiftyLastRow = [
        [
          '',
          '',
          '',
          '',
          ordinarySevenFiftyOpBtlsCount.toString(),
          ordinarySevenFiftyPurchaseBtlsCount.toString(),
          ordinarySevenFiftyOpeingAndPurchaseBtlsCount.toString(),
          ordinarySevenFiftyClosingBtlsCount.toString(),
          ordinarySevenFiftySalesBtlsCount.toString(),
          ordinarySevenFiftyTotalValuesCount.toString(),
        ],
      ];

      final ordinaryOneThousandLastRow = [
        [
          '',
          '',
          '',
          '',
          ordinaryOneThousandOpBtlsCount.toString(),
          ordinaryOneThousandPurchaseBtlsCount.toString(),
          ordinaryOneThousandOpeingAndPurchaseBtlsCount.toString(),
          ordinaryOneThousandClosingBtlsCount.toString(),
          ordinaryOneThousandSalesBtlsCount.toString(),
          ordinaryOneThousandTotalValuesCount.toString(),
        ],
      ];

      final mediumOneEightyLastRow = [
        [
          '',
          '',
          '',
          '',
          mediumOneEightyOpBtlsCount.toString(),
          mediumOneEightyPurchaseBtlsCount.toString(),
          mediumOneEightyOpeingAndPurchaseBtlsCount.toString(),
          mediumOneEightyClosingBtlsCount.toString(),
          mediumOneEightySalesBtlsCount.toString(),
          mediumOneEightyTotalValuesCount.toString(),
        ],
      ];

      final mediumThreeSeventyFiveLastRow = [
        [
          '',
          '',
          '',
          '',
          mediumThreeSeventyFiveOpBtlsCount.toString(),
          mediumThreeSeventyFivePurchaseBtlsCount.toString(),
          mediumThreeSeventyFiveOpeingAndPurchaseBtlsCount.toString(),
          mediumThreeSeventyFiveClosingBtlsCount.toString(),
          mediumThreeSeventyFiveSalesBtlsCount.toString(),
          mediumThreeSeventyFiveTotalValuesCount.toString(),
        ],
      ];

      final mediumSevenFiftyLastRow = [
        [
          '',
          '',
          '',
          '',
          mediumSevenFiftyOpBtlsCount.toString(),
          mediumSevenFiftyPurchaseBtlsCount.toString(),
          mediumSevenFiftyOpeingAndPurchaseBtlsCount.toString(),
          mediumSevenFiftyClosingBtlsCount.toString(),
          mediumSevenFiftySalesBtlsCount.toString(),
          mediumSevenFiftyTotalValuesCount.toString(),
        ],
      ];

      final mediumOneThousandLastRow = [
        [
          '',
          '',
          '',
          '',
          mediumOneThousandOpBtlsCount.toString(),
          mediumOneThousandPurchaseBtlsCount.toString(),
          mediumOneThousandOpeingAndPurchaseBtlsCount.toString(),
          mediumOneThousandClosingBtlsCount.toString(),
          mediumOneThousandSalesBtlsCount.toString(),
          mediumOneThousandTotalValuesCount.toString(),
        ],
      ];

      final premiumOneEightyLastRow = [
        [
          '',
          '',
          '',
          '',
          premiumOneEightyOpBtlsCount.toString(),
          premiumOneEightyPurchaseBtlsCount.toString(),
          premiumOneEightyOpeingAndPurchaseBtlsCount.toString(),
          premiumOneEightyClosingBtlsCount.toString(),
          premiumOneEightySalesBtlsCount.toString(),
          premiumOneEightyTotalValuesCount.toString(),
        ],
      ];
      print('premiumOneEightyOpBtlsCount $premiumOneEightyOpBtlsCount');
      print(
        'premiumOneEightyPurchaseBtlsCount $premiumOneEightyPurchaseBtlsCount',
      );
      print(
        'premiumOneEightyOpeingAndPurchaseBtlsCount $premiumOneEightyOpeingAndPurchaseBtlsCount',
      );

      final premiumThreeSeventyFiveLastRow = [
        [
          '',
          '',
          '',
          '',
          premiumThreeSeventyFiveOpBtlsCount.toString(),
          premiumThreeSeventyFivePurchaseBtlsCount.toString(),
          premiumThreeSeventyFiveOpeingAndPurchaseBtlsCount.toString(),
          premiumThreeSeventyFiveClosingBtlsCount.toString(),
          premiumThreeSeventyFiveSalesBtlsCount.toString(),
          premiumThreeSeventyFiveTotalValuesCount.toString(),
        ],
      ];

      final premiumSevenFiftyLastRow = [
        [
          '',
          '',
          '',
          '',
          premiumSevenFiftyOpBtlsCount.toString(),
          premiumSevenFiftyPurchaseBtlsCount.toString(),
          premiumSevenFiftyOpeingAndPurchaseBtlsCount.toString(),
          premiumSevenFiftyClosingBtlsCount.toString(),
          premiumSevenFiftySalesBtlsCount.toString(),
          premiumSevenFiftyTotalValuesCount.toString(),
        ],
      ];

      final premiumOneThousandLastRow = [
        [
          '',
          '',
          '',
          '',
          premiumOneThousandOpBtlsCount.toString(),
          premiumOneThousandPurchaseBtlsCount.toString(),
          premiumOneThousandOpeingAndPurchaseBtlsCount.toString(),
          premiumOneThousandClosingBtlsCount.toString(),
          premiumOneThousandSalesBtlsCount.toString(),
          premiumOneThousandTotalValuesCount.toString(),
        ],
      ];

      final beerTableLastRow = [
        [
          '',
          '',
          '',
          '',
          '',
          totalBeerOpeningBtl,
          totalBeerPurchaseBtl,
          totalBeerOpeningAndPurchaseBtl,
          totalBeerClosingBtl,
          totalBeerSalesBtl,
          totalBeerProductVal,
        ],
      ];

      final totalData = [
        [
          'Product',
          'Opening Stock',
          'Purchase',
          'Total (OP + Purchase)',
          'Closing',
          'Sales',
        ],
        [
          'IMFL',
          totalImflOpeningVal,
          totalImflPurchaseVal,
          totalImflOpeningAndPurcahseVal,
          totalImflClosingVal,
          totalImflSalesVal,
        ],
        [
          'BEER',
          totalBeerOpeningVal,
          totalBeerPurchaseVal,
          totalBeerOpeingAndPurchaseVal,
          totalBeerClosingVal,
          totalBeerProductVal,
        ],
        [
          'Total',
          totalImflAndBeerOpeningVal,
          totalImflAndBeerPurchaseVal,
          totalImflAndBeerOpAndPurchaseVal,
          totalImflAndBeerClosingVal,
          totalImflAndBeerSalesVal,
        ],
      ];

      final imflTableSummary = [
        ['', 'ORDINARY', 'MEDIUM', 'PREMIUM'],
        [
          'Opening Stock',
          totalOpeningVal,
          totalMediumOpeningVal,
          totalPremiumOpeningVal,
        ],
        [
          'Purchase',
          totalPurchaseVal,
          totalMediumPurchaseVal,
          totalPremiumPurchaseVal,
        ],
        [
          'Total',
          totalOpeningValue + totalPurchaseValue,
          totalMediumOpeningValue + totalMediumPurchaseValue,
          totalPremiumOpeningValue + totalPremiumPurchaseValue,
        ],
        [
          'Closing Stock',
          totalClosingVal,
          totalMediumClosingVal,
          totalPremiumClosingVal,
        ],
        ['Sales', totalVal, totalMediumVal, totalPremiumVal],
      ];

      final beerSummary = [
        ['Opening Stock', totalBeerOpeningVal],
        ['Purchase', totalBeerPurchaseVal],
        ['Closing Stock', totalBeerClosingVal],
        ['Sales', totalBeerProductVal],
      ];

      List<List<dynamic>> BottleHeading = [
        ['IMFL', 'BEER', 'IMFL', 'BEER', 'TOTAL'],
      ];
      List<List<dynamic>> imflBottleDetails = [
        ['', '1000', '750', '375', '180'],
        bottleOpCountDetail,
        bottleReceiptCountDetail,
        bottleActualCountDetail,
        bottleClosingCountDetail,
        bottleSalesCountDetail,
      ];
      List<List<dynamic>> beerBottleDetails = [
        ['650', '500/325'],
        beerBottleOpCount,
        beerBottleReceiptCount,
        beerBottleActualCount,
        beerBottleClosingCount,
        beerBottleSalesCount,
      ];

      List<List<dynamic>> totalImflBottleValues = [
        [imflValues[0]],
        [imflValues[1]],
        [imflValues[2]],
        [imflValues[3]],
        [imflValues[4]],
        [imflValues[5]],
      ];
      List<List<dynamic>> totalBeerBottleValues = [
        [beerValues[0]],
        [beerValues[1]],
        [beerValues[2]],
        [beerValues[3]],
        [beerValues[4]],
        [beerValues[5]],
      ];

      List<List<dynamic>> totalImflAndBeerBottleValues = [
        [ImflAndBeerValues[0]],
        [ImflAndBeerValues[1]],
        [ImflAndBeerValues[2]],
        [ImflAndBeerValues[3]],
        [ImflAndBeerValues[4]],
        [ImflAndBeerValues[5]],
      ];

      pw.Widget imflBottleCountTable(tableData) {
        return pw.Table(
          border: pw.TableBorder.all(width: 1),
          columnWidths: {
            0: const pw.FixedColumnWidth(2),
            1: const pw.FixedColumnWidth(1),
            2: const pw.FixedColumnWidth(1),
            3: const pw.FixedColumnWidth(1),
            4: const pw.FixedColumnWidth(1),
          },
          children: [
            for (int rowIndex = 0; rowIndex < tableData.length; rowIndex++)
              pw.TableRow(
                children: [
                  for (int i = 0; i < tableData[rowIndex].length; i++)
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Container(
                        height: 11,
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          tableData[rowIndex][i].toString(),
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: (rowIndex == 0 || i == 0)
                                ? pw.FontWeight.bold
                                : pw.FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        );
      }

      pw.Widget beerBottleCountTable(tableData) {
        return pw.Table(
          border: pw.TableBorder.all(width: 1),
          columnWidths: {
            0: const pw.FixedColumnWidth(1),
            1: const pw.FixedColumnWidth(1),
          },
          children: [
            for (int rowIndex = 0; rowIndex < tableData.length; rowIndex++)
              pw.TableRow(
                children: [
                  for (int i = 0; i < tableData[rowIndex].length; i++)
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Container(
                        height: 11,
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          tableData[rowIndex][i].toString(),
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: rowIndex == 0
                                ? pw.FontWeight.bold
                                : pw.FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        );
      }

      pw.Widget totalBottleValueTable(tableData) {
        return pw.Table(
          border: pw.TableBorder.all(width: 1),
          columnWidths: {0: const pw.FixedColumnWidth(1)},
          children: [
            for (int rowIndex = 0; rowIndex < tableData.length; rowIndex++)
              pw.TableRow(
                children: [
                  for (int i = 0; i < tableData[rowIndex].length; i++)
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Container(
                        height: 11,
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          tableData[rowIndex][i].toString(),
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: rowIndex == 0
                                ? pw.FontWeight.bold
                                : pw.FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        );
      }

      final bottleCountTable = pw.Table(
        border: pw.TableBorder.all(width: 1),
        columnWidths: {
          0: const pw.FixedColumnWidth(250),
          1: const pw.FixedColumnWidth(150),
          2: const pw.FixedColumnWidth(70),
          3: const pw.FixedColumnWidth(70),
          4: const pw.FixedColumnWidth(70),
        },
        children: [
          for (final row in BottleHeading)
            pw.TableRow(
              children: [
                for (int i = 0; i < row.length; i++)
                  pw.Padding(
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Container(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        row[i],
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          pw.TableRow(
            children: [
              pw.Container(child: imflBottleCountTable(imflBottleDetails)),
              pw.Container(child: beerBottleCountTable(beerBottleDetails)),
              pw.Container(child: totalBottleValueTable(totalImflBottleValues)),
              pw.Container(child: totalBottleValueTable(totalBeerBottleValues)),
              pw.Container(
                child: totalBottleValueTable(totalImflAndBeerBottleValues),
              ),
            ],
          ),
        ],
      );

      pw.Widget brandOrderPdfImfl(tableHeader, tableDetails, tableLastRow) {
        return pw.Table(
          border: pw.TableBorder.all(width: 1),
          columnWidths: {
            0: const pw.FixedColumnWidth(50),
            1: const pw.FixedColumnWidth(160),
            2: const pw.FixedColumnWidth(70),
            3: const pw.FixedColumnWidth(50),
            4: const pw.FixedColumnWidth(50),
            5: const pw.FixedColumnWidth(50),
            6: const pw.FixedColumnWidth(50),
            7: const pw.FixedColumnWidth(50),
            8: const pw.FixedColumnWidth(50),
            9: const pw.FixedColumnWidth(50),
            10: const pw.FixedColumnWidth(50),
          },
          children: [
            for (final row in tableHeader)
              pw.TableRow(
                children: [
                  for (int i = 0; i < row.length; i++)
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Container(
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          row[i],
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            for (final row in tableDetails)
              pw.TableRow(
                children: [
                  for (int i = 0; i < row.length; i++)
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Container(
                        height: 11,
                        alignment: i == 1
                            ? pw.Alignment.centerLeft
                            : pw.Alignment.center,
                        child: pw.Text(
                          row[i],
                          style: pw.TextStyle(fontSize: 8),
                        ),
                      ),
                    ),
                ],
              ),
            for (final row in tableLastRow)
              pw.TableRow(
                children: [
                  for (int i = 0; i < row.length; i++)
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Container(
                        height: 11,
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          row[i].toString(),
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        );
      }

      ;

      pw.Widget beerBrandOrderPdfImfl(tableHeader, tableDetails, tableLastRow) {
        return pw.Table(
          border: pw.TableBorder.all(width: 1),
          columnWidths: {
            0: const pw.FixedColumnWidth(50),
            1: const pw.FixedColumnWidth(160),
            2: const pw.FixedColumnWidth(50),
            3: const pw.FixedColumnWidth(70),
            4: const pw.FixedColumnWidth(50),
            5: const pw.FixedColumnWidth(50),
            6: const pw.FixedColumnWidth(50),
            7: const pw.FixedColumnWidth(50),
            8: const pw.FixedColumnWidth(50),
            9: const pw.FixedColumnWidth(50),
            10: const pw.FixedColumnWidth(50),
          },
          children: [
            for (final row in tableHeader)
              pw.TableRow(
                children: [
                  for (int i = 0; i < row.length; i++)
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Container(
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          row[i],
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            for (final row in tableDetails)
              pw.TableRow(
                children: [
                  for (int i = 0; i < row.length; i++)
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Container(
                        height: 11,
                        alignment: i == 1
                            ? pw.Alignment.centerLeft
                            : pw.Alignment.center,
                        child: pw.Text(
                          row[i],
                          style: pw.TextStyle(fontSize: 8),
                        ),
                      ),
                    ),
                ],
              ),
            for (final row in tableLastRow)
              pw.TableRow(
                children: [
                  for (int i = 0; i < row.length; i++)
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Container(
                        height: 11,
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          row[i].toString(),
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        );
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'DAILY STATEMENT',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Text(
                    'Shop ID : $shopId',
                    style: pw.TextStyle(font: ttf),
                  ),
                ),
                pw.Spacer(),
                pw.Expanded(
                  child: pw.Text('$city', style: pw.TextStyle(font: ttf)),
                ),
                pw.Spacer(),
                pw.Expanded(
                  child: pw.Text(
                    'Date : $date',
                    style: pw.TextStyle(font: ttf),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 15),
            if (closingPdfFormat == 'size wise') ...[
              pw.Text(
                'IMFL Details',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                '- ORDINARY - 180 ml Details',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  for (final row in tableHeader)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,

                                fontSize: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  for (final row in ordinaryOneEight)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(font: ttf, fontSize: 8),
                            ),
                          ),
                      ],
                    ),
                  for (final row in ordinaryOneEightyLastRow)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                '- ORDINARY - 375 ml Details',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  for (final row in tableHeader)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,

                                fontSize: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  for (final row in ordianryThreeSeventyFiveDatas)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(font: ttf, fontSize: 8),
                            ),
                          ),
                      ],
                    ),
                  for (final row in ordianryThreeSeventyFiveLastRow)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                '- ORDINARY - 750 ml Details',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  for (final row in tableHeader)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,

                                fontSize: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  for (final row in ordinarySevenFiftyDatas)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(font: ttf, fontSize: 8),
                            ),
                          ),
                      ],
                    ),
                  for (final row in ordinarySevenFiftyLastRow)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Text(
                '- ORDINARY - 1000 ml Details',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  for (final row in tableHeader)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,

                                fontSize: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  for (final row in ordinaryOneThousandDatas)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(font: ttf, fontSize: 8),
                            ),
                          ),
                      ],
                    ),
                  for (final row in ordinaryOneThousandLastRow)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Text(
                '- MEDIUM - 180 ml Details',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  for (final row in tableHeader)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,

                                fontSize: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  for (final row in mediumOneEight)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(font: ttf, fontSize: 8),
                            ),
                          ),
                      ],
                    ),
                  for (final row in mediumOneEightyLastRow)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Text(
                '- MEDIUM - 375 ml Details',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  for (final row in tableHeader)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,

                                fontSize: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  for (final row in mediumThreeSeventyFiveDatas)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(font: ttf, fontSize: 8),
                            ),
                          ),
                      ],
                    ),
                  for (final row in mediumThreeSeventyFiveLastRow)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Text(
                '- MEDIUM - 750 ml Details',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  for (final row in tableHeader)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,

                                fontSize: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  for (final row in mediumSevenFiftyDatas)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(font: ttf, fontSize: 8),
                            ),
                          ),
                      ],
                    ),
                  for (final row in mediumSevenFiftyLastRow)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Text(
                '- MEDIUM - 1000 ml Details',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  for (final row in tableHeader)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,

                                fontSize: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  for (final row in mediumOneThousandDatas)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(font: ttf, fontSize: 8),
                            ),
                          ),
                      ],
                    ),
                  for (final row in mediumOneThousandLastRow)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Text(
                '- PREMIUM - 180 ml Details',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  for (final row in tableHeader)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,

                                fontSize: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  for (final row in premiumOneEight)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(font: ttf, fontSize: 8),
                            ),
                          ),
                      ],
                    ),
                  for (final row in premiumOneEightyLastRow)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Text(
                '- PREMIUM - 375 ml Details',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  for (final row in tableHeader)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,

                                fontSize: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  for (final row in premiumThreeSeventyFiveDatas)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(font: ttf, fontSize: 8),
                            ),
                          ),
                      ],
                    ),
                  for (final row in premiumThreeSeventyFiveLastRow)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Text(
                '- PREMIUM - 750 ml Details',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  for (final row in tableHeader)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,

                                fontSize: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  for (final row in premiumSevenFiftyDatas)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(font: ttf, fontSize: 8),
                            ),
                          ),
                      ],
                    ),
                  for (final row in premiumSevenFiftyLastRow)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Text(
                '- PREMIUM - 1000 ml Details',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  for (final row in tableHeader)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,

                                fontSize: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  for (final row in premiumOneThousandDatas)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(font: ttf, fontSize: 8),
                            ),
                          ),
                      ],
                    ),
                  for (final row in premiumOneThousandLastRow)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'BEER Details',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  for (final row in beerHeader)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  for (final row in beerTableData)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(font: ttf, fontSize: 8),
                            ),
                          ),
                      ],
                    ),
                  for (final row in beerTableLastRow)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Row(
                children: [
                  pw.Text(
                    'IMFL Summary :',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  for (final row in imflTableSummary)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell.toString(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),

              pw.SizedBox(height: 25),
              pw.Row(
                children: [
                  pw.Text(
                    'Total IMFL Sale Value : ',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                  pw.Spacer(),
                  pw.Text(
                    totalImflSale,
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                  pw.Spacer(),
                  pw.Spacer(),
                  pw.Spacer(),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Row(
                children: [
                  pw.Text(
                    'BEER Summary :',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                columnWidths: {
                  0: const pw.FixedColumnWidth(100.0),
                  1: const pw.FixedColumnWidth(200.0),
                  2: const pw.FixedColumnWidth(300.0),
                  3: const pw.FixedColumnWidth(400.0),
                },
                children: [
                  for (final row in beerSummary)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                font: ttf,
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),

              pw.SizedBox(height: 40),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  for (int i = 0; i < totalData.length; i++)
                    pw.TableRow(
                      children: [
                        for (final cell in totalData[i])
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: i == 0
                                    ? pw.FontWeight.bold
                                    : pw.FontWeight.normal,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Bottle Details',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              bottleCountTable,

              pw.SizedBox(height: 30),
              pw.Row(
                children: [
                  pw.Text(
                    'Sales Value :',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                  pw.Spacer(),
                  pw.Text(
                    totalImflAndBeerSalesVal,
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                  pw.Spacer(),
                  pw.Text(
                    'Sales Cumulative :',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                  pw.Spacer(),
                  pw.Text(
                    '$salesCumulativeVal',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                children: [
                  pw.Text(
                    'POS Value :',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                  pw.Spacer(),
                  pw.Text(
                    '$posMachineValuePerDay',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                  pw.Spacer(),
                  pw.Text(
                    'POS Cumulative :',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                  pw.Spacer(),
                  pw.Text(
                    '$posMonthlyCumulation',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ],
              ),

              pw.SizedBox(height: 20),
            ],
            if (closingPdfFormat == 'default') ...[
              pw.Text(
                'IMFL Details',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                '- ORDINARY',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              brandOrderPdfImfl(
                tableHeader,
                ordinaryDetails,
                totalOrdinaryLastRow,
              ),
              pw.SizedBox(height: 20),
              pw.SizedBox(height: 8),
              pw.Text(
                '- MEDIUM',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              brandOrderPdfImfl(tableHeader, mediumDetails, totalMediumLastRow),
              pw.SizedBox(height: 20),
              pw.SizedBox(height: 8),
              pw.Text(
                '- PREMIUM',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              brandOrderPdfImfl(
                tableHeader,
                premiumDetails,
                totalPremiumLastRow,
              ),
              pw.SizedBox(height: 20),
              pw.SizedBox(height: 8),
              pw.Text(
                '- BEER Details',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              beerBrandOrderPdfImfl(
                brandOrderBeerHeader,
                beerDetails,
                beerTableLastRow,
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                children: [
                  pw.Text(
                    'IMFL Summary :',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  for (final row in imflTableSummary)
                    pw.TableRow(
                      children: [
                        for (final cell in row)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),

                            child: pw.Text(
                              cell.toString(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Bottle Details',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              bottleCountTable,
              pw.SizedBox(height: 30),
              pw.Row(
                children: [
                  pw.Text(
                    'Sales Value :',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                  pw.Spacer(),
                  pw.Text(
                    totalImflAndBeerSalesVal,
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                  pw.Spacer(),
                  pw.Text(
                    'Sales Cumulative :',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                  pw.Spacer(),
                  pw.Text(
                    '$salesCumulativeVal',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                children: [
                  pw.Text(
                    'POS Value :',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                  pw.Spacer(),
                  pw.Text(
                    '$posMachineValuePerDay',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                  pw.Spacer(),
                  pw.Text(
                    'POS Cumulative :',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                  pw.Spacer(),
                  pw.Text(
                    '$posMonthlyCumulation',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    } else {
      List<List<String>> premiumheadingOne = [];
      final ordinaryHeadingData = tableItems[0];
      final ordinaryOneEightyData = tableItems[1];
      final ordinaryThreeSeventyData = tableItems[2];
      final ordinarySevenFiftyData = tableItems[3];
      final mediumHeadingData = tableItems[7];
      final mediumOneEightyData = tableItems[8];
      final mediumThreeSeventyData = tableItems[10];
      final mediumSevenFiftyData = tableItems[12];
      final premiumHeadingData = tableItems[14];
      final premiumOneEightyData = tableItems[15];
      final premiumThreeSeventyFiveData = tableItems[17];
      final premiumSevenFiftyData = tableItems[18];
      final opSummary = tableItems[23];
      final oneThousandHeadingData = tableItems[24];
      final ordinaryOneThousandData = tableItems[25];
      final mediumOneThousandData = tableItems[26];
      final premiumOneThousandData = tableItems[27];
      final beerHeadings = tableItems[28];
      final beerDatas = tableItems[29];
      final lengthOfBeerSizes = tableItems[30];

      print('premiumHeadingDatarrrr ${premiumHeadingData.runtimeType}');
      print('mediumThreeSeventyData $mediumThreeSeventyData');
      print('premiumSevenFiftyData ${premiumSevenFiftyData.length}');

      int preHeadingLen = premiumHeadingData.length;
      List<int> preDataLen = [];

      Future<int> getTotalValList(dataList) async {
        final addData = [];

        for (final val in dataList) {
          print('bbbbb333b ${val[0]}');
          if (val[0] != '.') {
            addData.add(val);
            print('oneEightyDataoneEightyData5555555 $dataList');
          }
        }

        print('addData $addData');
        return addData.length;
      }

      final preOneEightVal = await getTotalValList(premiumOneEightyData);
      final preThreeSeventyFiveVal = await getTotalValList(
        premiumThreeSeventyFiveData,
      );
      final preSevenFiftVal = await getTotalValList(premiumSevenFiftyData);

      print('preOneEightVal $preOneEightVal');
      print('preThreeSeventyFiveVal $preThreeSeventyFiveVal');
      print('preSevenFiftVal $preSevenFiftVal');

      List<int> preTableEnd = [];
      List<int> ordTableEnd = [];
      List<int> mdmTableEnd = [];
      List<int> thousandTableEnd = [];

      int preTableCount = 0;
      int mdmTableCount = 0;
      int ordTableCount = 0;
      int thousandTableCount = 0;
      int preLastValue = 0;
      print('lenEEEE $preHeadingLen');

      final numberOfTable = preHeadingLen / 25;

      int premiumTableCount = numberOfTable.ceil();

      print(
        'numberOfTableyyyyyy $numberOfTable, premiumTableCount $premiumTableCount',
      );
      ;

      Future<List<String>> tableLastRow(datas) async {
        int totOp = 0;
        int totRcpt = 0;
        int totOpAndRcpt = 0;
        List<String> lastRow = [];

        for (final val in datas) {
          totOp += int.parse(val[1]);
          totRcpt += int.parse(val[2]);
          totOpAndRcpt += int.parse(val[3]);
          lastRow = [
            '',
            totOp.toString(),
            totRcpt.toString(),
            totOpAndRcpt.toString(),
          ];
        }

        return lastRow;
      }

      final ordOneEighty = await tableLastRow(ordinaryOneEightyData);
      final ordThreeSeventyFive = await tableLastRow(ordinaryThreeSeventyData);
      final ordSevenFifty = await tableLastRow(ordinarySevenFiftyData);

      final mdmOneEighty = await tableLastRow(mediumOneEightyData);
      final mdmThreeSeventyFive = await tableLastRow(mediumThreeSeventyData);
      final mdmSevenFifty = await tableLastRow(mediumSevenFiftyData);

      final preOneEighty = await tableLastRow(premiumOneEightyData);
      final preThreeSeventyFive = await tableLastRow(
        premiumThreeSeventyFiveData,
      );
      final presevenFifty = await tableLastRow(premiumSevenFiftyData);

      final ordThousand = await tableLastRow(ordinaryOneThousandData);
      final mdmThousand = await tableLastRow(mediumOneThousandData);
      final preThousand = await tableLastRow(premiumOneThousandData);

      print('ordThousandordThousand$ordThousand');

      List<List<String>> ordThousandRow = [];
      List<List<String>> mdmThousandRow = [];
      List<List<String>> preThousandRow = [];

      List<List<String>> ordOneLastRow = [];
      List<List<String>> ordThreeSeventyFiveLastRow = [];
      List<List<String>> ordSevenFiftyLastRow = [];
      List<List<String>> mdmOneLastRow = [];
      List<List<String>> mdmThreeSeventyFiveLastRow = [];
      List<List<String>> mdmSevenFiftyLastRow = [];

      if (ordThousand.isNotEmpty) {
        ordThousandRow = [
          ['', ordThousand[1], ordThousand[2], ordThousand[3]],
        ];
      }

      if (mdmThousand.isNotEmpty) {
        mdmThousandRow = [
          ['', mdmThousand[1], mdmThousand[2], mdmThousand[3]],
        ];
      }

      if (preThousand.isNotEmpty) {
        preThousandRow = [
          ['', preThousand[1], preThousand[2], preThousand[3]],
        ];
      }

      if (ordOneEighty.isNotEmpty) {
        ordOneLastRow = [
          ['', ordOneEighty[1], ordOneEighty[2], ordOneEighty[3]],
        ];
      }

      if (ordThreeSeventyFive.isNotEmpty) {
        ordThreeSeventyFiveLastRow = [
          [
            '',
            ordThreeSeventyFive[1],
            ordThreeSeventyFive[2],
            ordThreeSeventyFive[3],
          ],
        ];
      }

      if (ordSevenFifty.isNotEmpty) {
        ordSevenFiftyLastRow = [
          ['', ordSevenFifty[1], ordSevenFifty[2], ordSevenFifty[3]],
        ];
      }

      if (mdmOneEighty.isNotEmpty) {
        mdmOneLastRow = [
          ['', mdmOneEighty[1], mdmOneEighty[2], mdmOneEighty[3]],
        ];
      }

      if (mdmThreeSeventyFive.isNotEmpty) {
        mdmThreeSeventyFiveLastRow = [
          [
            '',
            mdmThreeSeventyFive[1],
            mdmThreeSeventyFive[2],
            mdmThreeSeventyFive[3],
          ],
        ];
      }

      if (mdmSevenFifty.isNotEmpty) {
        mdmSevenFiftyLastRow = [
          ['', mdmSevenFifty[1], mdmSevenFifty[2], mdmSevenFifty[3]],
        ];
      }

      print('preOneEighty44 $preOneEighty');
      print('preThreeSeventyFive4 $preThreeSeventyFive');
      print('presevenFifty44 $presevenFifty');

      print('premiumheadingOne333 $premiumheadingOne');

      print('ordinaryOneEightyData $ordinaryOneEightyData');
      print('++++++++ $ordinaryThreeSeventyData');
      print('mediumOneEightyData $mediumOneEightyData');

      final caseTableFirstHead = [
        ['CASES'],
      ];

      final caseTableSecondHead = [
        ['180 ml', '375 ml'],
      ];

      final firstTwoColumn = [
        ['180 ml', '375 ml', 'Code', 'Brand'],
      ];

      final beerFirstTwoColumn = [
        ['Code', 'Brand'],
      ];

      final thousandFirstTwoColumn = [
        ['Code', 'Brand'],
      ];

      final firstOrdinaryColumn = [
        ['ORDINARY'],
      ];

      final firstMediumColumn = [
        ['MEDIUM'],
      ];

      final firstPremiumColumn = [
        ['PREMIUM'],
      ];

      final firstHeadingOneEighty = [
        ['', '', '', '', '', '', '180 ml'],
      ];

      final firstHeadingThreeSeventyFive = [
        ['', '', '', '', '', '', '375 ml'],
      ];

      final firstHeadingSevenFifty = [
        ['', '', '', '', '750 ml', ''],
      ];

      final headings = [
        ['MRP', 'OP', 'RCPT', 'OB', 'SAL', 'CASE', 'BOTT'],
      ];

      final sevenFiftyHeadings = [
        ['MRP', 'OP', 'RCPT', 'OB', 'SAL', 'CB'],
      ];

      final oneThousandHeading = [
        ['', '1000 ml'],
      ];

      final oneThousandHeadingOne = [
        ['', '', '', '', 'ORD', ''],
      ];
      final oneThousandHeadingTwo = [
        ['', '', '', '', 'MED', ''],
      ];
      final oneThousandHeadingThree = [
        ['', '', '', '', 'PRE', ''],
      ];

      final beerHeading = [
        ['', 'BEER'],
      ];

      final beerHeadingOne = [
        ['.'],
      ];

      List<List<String>> beerEmptyCol = [];
      List<List<String>> beerEmptyColHead = [
        ['Fridge Details'],
      ];

      final openingSummaryHeading = [
        [
          'DETAIL',
          '1000 ML',
          '750 ML',
          '375 ML',
          '180 ML',
          '650 ML',
          '500 ML',
          'IMFS AMOUNT',
          'BEER AMOUNT',
          '   TOTAL   ',
        ],
      ];

      final salesHeading = [
        ['S.No', 'Description', 'Values'],
      ];
      final salesOverViewData = [
        ['1.', 'SHOP NO', '$shopId'],
        ['2.', 'SALES DATE', date],
        ['3.', 'CONTACT NO', ''],
        ['4.', 'DISTRICT', ''],
        ['5.', 'IMFL 1000', ''],
        ['6.', 'IMFL 750', ''],
        ['7.', 'IMFL 375', ''],
        ['8.', 'IMFL 180', ''],
        ['9.', 'BEER 650', ''],
        ['10.', 'BEER 500', ''],
        ['11.', 'IMFL SALES CASES', ''],
        ['12.', 'IMFL BEER SALES CASES', ''],
        ['13.', 'IMFL SALES VALUE', ''],
        ['14.', 'BEER SALES VALUE', ''],
        ['15.', 'TOTAL SALES VALUE IMFL + BEER', ''],
        ['16.', 'BANK REMITANCE', ''],
        ['17.', 'POS VALUE', ''],
        ['18.', 'TOTAL SALES AMOUNT (POS + BANK)', ''],
        ['19.', 'ORD.IMFL CB CASES', ''],
        ['20.', 'MEDIUM IMFS CB CASES', ''],
        ['21.', 'PREMIUM IMFL CB CASES', ''],
        ['22.', 'STRONG BEER CASES', ''],
        ['23.', 'LAGER BEER CASES', ''],
        ['24.', 'OVERALL CB VALUE (IMFL + BEER)', ''],
        ['25.', 'STOCK RECIEPT IMFL CASES', ''],
        ['26.', 'STOCK RECIEPT BEER  CASES', ''],
        ['27.', 'TOTAL RECIEPT  (IMFL + BEER)', ''],
        ['28.', 'IMFL STOCK RECIEPT IN CASE ORDINARY', ''],
        ['29.', 'IMFL STOCK RECIEPT IN CASE MEDIUM', ''],
        ['30.', 'IMFL STOCK RECIEPT IN CASE PREMIUM', ''],
        ['31.', 'BEER STOCK RECIEPT IN CASES STRONG', ''],
        ['32.', 'BEER STOCK RECIEPT IN CASES LAGER', ''],
        ['33.', 'STOCK RETURN IMFL CASES', ''],
        ['34.', 'STOCK RETURN BEER CASES', ''],
        ['35.', 'TOTAL RETURN VALUE (IMFL + BEER)', ''],
        ['36.', 'IMFL STOCK RETURN ORDINARY CASES', ''],
        ['37.', 'IMFL STOCK RETURN MEDIUM CASES', ''],
        ['38.', 'IMFL STOCK RETURN PREMIUM CASES', ''],
        ['39.', 'BEER STOCK RETURN STRONG CASES', ''],
        ['40.', 'BEER STOCK RETURN LAGER CASES', ''],
        ['41.', '60 DAYS STOCK IN CASES', ''],
        ['42.', '90 DAYS STOCK IN CASES', ''],
        ['43.', '90 DAYS STOCK IN VALUES', ''],
      ];

      pw.Widget heading() {
        return pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'OPENING STATEMENT',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.SizedBox(width: 10),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text(
                        'SHOP NO : ',
                        style: pw.TextStyle(
                          fontSize: 15,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        '$shopId',
                        style: const pw.TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                pw.Spacer(),
                pw.Expanded(
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text('$city', style: const pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                ),
                pw.Spacer(),
                pw.Expanded(
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Text(
                        'DATE : ',
                        style: pw.TextStyle(
                          fontSize: 15,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(date, style: const pw.TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      }

      List<List<List<String>>> casesChunks = [];

      List<List<List<String>>> ordinaryHeadingChunks = [];
      List<List<List<String>>> ordinaryOneEightyChunks = [];
      List<List<List<String>>> ordinaryThreeSeventFiveChunks = [];
      List<List<List<String>>> ordinarySevenFiftyChunks = [];

      for (int i = 0; i < ordinaryHeadingData.length; i += 25) {
        int end = min(i + 25, ordinaryHeadingData.length);

        ordTableEnd.add(end);

        ordinaryHeadingChunks.add(ordinaryHeadingData.sublist(i, end));
        ordinaryOneEightyChunks.add(ordinaryOneEightyData.sublist(i, end));
        ordinaryThreeSeventFiveChunks.add(
          ordinaryThreeSeventyData.sublist(i, end),
        );
        ordinarySevenFiftyChunks.add(ordinarySevenFiftyData.sublist(i, end));
        casesChunks.add([
          ['', ''],
        ]);
        print('ordinaryOneEightyChunks[i]ordinaryOneEightyChunks[i] ${i}');
      }

      List<List<List<String>>> mediumHeadingChunks = [];
      List<List<List<String>>> mediumOneEightyChunks = [];
      List<List<List<String>>> mediumThreeSeventFiveChunks = [];
      List<List<List<String>>> mediumSevenFiftyChunks = [];

      for (int i = 0; i < mediumHeadingData.length; i += 25) {
        int end = min(i + 25, mediumHeadingData.length);

        mdmTableEnd.add(end);

        mediumHeadingChunks.add(mediumHeadingData.sublist(i, end));
        mediumOneEightyChunks.add(mediumOneEightyData.sublist(i, end));
        mediumThreeSeventFiveChunks.add(mediumThreeSeventyData.sublist(i, end));
        mediumSevenFiftyChunks.add(mediumSevenFiftyData.sublist(i, end));
      }

      List<List<List<String>>> chunks = [];
      List<List<List<String>>> oneEightyChunks = [];
      List<List<List<String>>> ThreeSeventFiveChunks = [];
      List<List<List<String>>> SevenFiftyChunks = [];

      int tableCount = 1;
      int c = 0;

      for (int i = 0; i < premiumHeadingData.length; i += 25) {
        int end = min(i + 25, premiumHeadingData.length);
        print('endddd $end');

        c = tableCount++;
        preTableEnd.add(end);

        chunks.add(premiumHeadingData.sublist(i, end));
        oneEightyChunks.add(premiumOneEightyData.sublist(i, end));
        ThreeSeventFiveChunks.add(premiumThreeSeventyFiveData.sublist(i, end));
        SevenFiftyChunks.add(premiumSevenFiftyData.sublist(i, end));
      }

      print('cccc555 $c');
      print('premiumHeadingData444 $chunks');
      print('preTableEnd $preTableEnd');

      List<List<List<String>>> beerHeadingchunks = [];
      List<List<List<String>>> beerDataChunks = [];
      List<List<List<String>>> beerFiveHundredChunks = [];
      List<List<List<String>>> beerSixFiftyChunks = [];

      for (int i = 0; i < beerHeadings.length; i += 24) {
        int end = min(i + 24, beerHeadings.length);
        beerHeadingchunks.add(beerHeadings.sublist(i, end));
        beerDataChunks.add(beerDatas.sublist(i, end));
      }

      List<List<List<String>>> oneThousandHeadingChunks = [];
      List<List<List<String>>> ordinaryOneThousandChunks = [];
      List<List<List<String>>> mediumOneThousandChunks = [];
      List<List<List<String>>> premiumOneThousandChunks = [];

      for (int i = 0; i < oneThousandHeadingData.length; i += 25) {
        int end = min(i + 25, oneThousandHeadingData.length);
        thousandTableEnd.add(end);
        oneThousandHeadingChunks.add(oneThousandHeadingData.sublist(i, end));
        ordinaryOneThousandChunks.add(ordinaryOneThousandData.sublist(i, end));
        mediumOneThousandChunks.add(mediumOneThousandData.sublist(i, end));
        premiumOneThousandChunks.add(premiumOneThousandData.sublist(i, end));
      }

      pw.Widget generateTable(
        List<List<String>> data,
        List<List<String>> firstHead,
        bool isCaseExists,
        String tableStatus,
      ) {
        const PdfColor evenRowColor = PdfColors.grey200;
        const PdfColor oddRowColor = PdfColors.white;

        final columnWidths = isCaseExists
            ? {
                0: const pw.FlexColumnWidth(0.8),
                1: const pw.FlexColumnWidth(0.8),
                2: const pw.FlexColumnWidth(0.8),
                3: const pw.FlexColumnWidth(3),
              }
            : {
                0: const pw.FlexColumnWidth(0.8),
                1: const pw.FlexColumnWidth(2),
              };

        return pw.Table(
          border: pw.TableBorder.all(width: 1, color: PdfColors.grey),
          columnWidths: columnWidths,
          children: [
            for (final row in firstHead)
              pw.TableRow(
                children: [
                  for (int i = 0; i < row.length; i++)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(
                        left: 4,
                        right: 4,
                        top: 4,
                        bottom: 4,
                      ),
                      child: pw.Container(
                        height: 11,
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          row[i],
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            if (isCaseExists == true)
              for (final row in firstTwoColumn)
                pw.TableRow(
                  children: [
                    for (int i = 0; i < row.length; i++)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(
                          left: 4,
                          right: 4,
                          top: 4,
                          bottom: 4,
                        ),
                        child: pw.Container(
                          height: 11,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            row[i],
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            if (isCaseExists == false)
              for (final row in thousandFirstTwoColumn)
                pw.TableRow(
                  children: [
                    for (int i = 0; i < row.length; i++)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(
                          left: 4,
                          right: 4,
                          top: 4,
                          bottom: 4,
                        ),
                        child: pw.Container(
                          height: 11,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            row[i],
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            for (int index = 0; index < data.length; index++)
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: index % 2 == 0 ? evenRowColor : oddRowColor,
                ),
                children: [
                  for (var i = 0; i < data[index].length; i++)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(
                        left: 4,
                        right: 4,
                        top: 4,
                        bottom: 4,
                      ),
                      child: pw.Container(
                        height: 11,
                        child: pw.Text(
                          data[index][i],
                          style: const pw.TextStyle(fontSize: 9),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        );
      }

      pw.Widget generateBeerTable(
        List<List<String>> data,
        List<List<String>> firstHead,
      ) {
        const PdfColor evenRowColor = PdfColors.grey200;
        const PdfColor oddRowColor = PdfColors.white;

        print('firstHeadfirstHeadbeer $firstHead');

        print('datafffffff $data');

        print('vvvvvlengthOfBeerSizes $lengthOfBeerSizes');

        List<String> ThreeTwentyFiveHead = ['', '325 ml'];

        List<String> FiveHundredHead = ['', '500 ml'];

        List<String> SixFiftyHead = ['', '650 ml'];

        final lengthOfThreeTwentyFive = lengthOfBeerSizes[0];

        final lengthOfFiveHundred = lengthOfBeerSizes[1];

        int indexValSixFifty = 0;
        int indexValFiveHundred = 0;

        int indexValSixFiftyCheck = 0;
        int indexValFiveHundredCheck = 0;

        List<int> boldIndices = [];

        if (lengthOfBeerSizes[2] != 0) {
          indexValSixFifty = lengthOfThreeTwentyFive + lengthOfFiveHundred;
          data.insert(indexValSixFifty, SixFiftyHead);
        }

        if (lengthOfBeerSizes[1] != 0) {
          indexValFiveHundred = lengthOfThreeTwentyFive;
          data.insert(indexValFiveHundred, FiveHundredHead);
          indexValSixFiftyCheck =
              lengthOfThreeTwentyFive + lengthOfFiveHundred + 1;
        } else {
          indexValSixFiftyCheck = lengthOfThreeTwentyFive + lengthOfFiveHundred;
        }

        if (lengthOfBeerSizes[0] != 0) {
          data.insert(0, ThreeTwentyFiveHead);
          indexValFiveHundred + 1;
          indexValFiveHundredCheck = lengthOfThreeTwentyFive + 1;
          indexValSixFiftyCheck =
              lengthOfThreeTwentyFive + lengthOfFiveHundred + 2;
        } else {
          indexValFiveHundredCheck = lengthOfThreeTwentyFive;
        }

        if (lengthOfBeerSizes[0] != 0) {
          boldIndices.add(0);
        }

        if (lengthOfBeerSizes[1] != 0) {
          boldIndices.add(indexValFiveHundredCheck);
        }

        if (lengthOfBeerSizes[2] != 0) {
          boldIndices.add(indexValSixFiftyCheck);
        }

        print('boldIndicesboldIndices $boldIndices');
        print('datadatadata $data');

        return pw.Table(
          border: pw.TableBorder.all(width: 1, color: PdfColors.grey),
          columnWidths: {
            0: const pw.FlexColumnWidth(0.8),
            1: const pw.FlexColumnWidth(3),
          },
          children: [
            for (final row in firstHead)
              pw.TableRow(
                children: [
                  for (int i = 0; i < row.length; i++)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(
                        left: 4,
                        right: 4,
                        top: 4,
                        bottom: 4,
                      ),
                      child: pw.Container(
                        height: 11,
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          row[i],
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            for (final row in beerFirstTwoColumn)
              pw.TableRow(
                children: [
                  for (int i = 0; i < row.length; i++)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(
                        left: 4,
                        right: 4,
                        top: 4,
                        bottom: 4,
                      ),
                      child: pw.Container(
                        height: 11,
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          row[i],
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            for (int index = 0; index < data.length; index++)
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: index % 2 == 0 ? evenRowColor : oddRowColor,
                ),
                children: [
                  for (var i = 0; i < data[index].length; i++)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 4,
                        bottom: 4,
                      ),
                      child: pw.Container(
                        height: 11,
                        alignment: boldIndices.contains(index)
                            ? pw.Alignment.center
                            : pw.Alignment.centerLeft,
                        child: pw.Text(
                          data[index][i],
                          style: pw.TextStyle(
                            fontSize: 9,
                            fontWeight: boldIndices.contains(index)
                                ? pw.FontWeight.bold
                                : pw.FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        );
      }

      int tableLastRowGetCalculatoin(
        List<int> totalPreLength,
        int preTableCount,
      ) {
        int sum = 0;

        if (totalPreLength.length >= preTableCount) {
          for (
            int i = preTableCount - 1;
            i < totalPreLength.length;
            i += preTableCount
          ) {
            sum += totalPreLength[i];
          }

          print('sum55554 $sum');
          return sum;
        } else {
          print("The list has fewer than 4 elements.");
          return sum;
        }
      }

      pw.Widget beerDataTable(
        List<List<String>> oneEightyData,
        PdfColor color,
        List<List<String>> firstHead,
        List<List<String>> secondHead,
      ) {
        print('oneEightyDatabeer $oneEightyData');
        print('firstHeadfirstHead beer data  $firstHead');

        List<String> ThreeTwentyFiveHeadData = ['', '', '.', '', '', ''];

        List<String> FiveHundredHeadData = ['', '', '.', '', '', ''];

        List<String> SixFiftyHeadData = ['', '', '.', '', '', ''];

        final lengthOfThreeTwentyFive = lengthOfBeerSizes[0];

        final lengthOfFiveHundred = lengthOfBeerSizes[1];

        int indexValSixFifty = 0;
        int indexValFiveHundred = 0;

        int indexValSixFiftyCheck = 0;
        int indexValFiveHundredCheck = 0;

        List<int> boldIndices = [];

        String? val1;
        int totOp = 0;
        int totRcpt = 0;
        int totOpAndRcpt = 0;
        List<List<String>> lastRow = [];

        for (final val in oneEightyData) {
          totOp += int.parse(val[1]);
          totRcpt += int.parse(val[2]);
          totOpAndRcpt += int.parse(val[3]);
          if (val[1] == '0') {
            val[1] = '';
            val1 = '';
          }
          if (val[2] == '0') {
            val[2] = '';
          }
          if (val[3] == '0') {
            val[3] = '';
          }
          print(
            'subVal[1] $totOp, subVal[2] $totRcpt, subVal[3] $totOpAndRcpt',
          );
          lastRow = [
            ['', totOp.toString(), totRcpt.toString(), totOpAndRcpt.toString()],
          ];
        }

        if (oneEightyData.isNotEmpty) {
          if (lengthOfBeerSizes[2] != 0) {
            indexValSixFifty = lengthOfThreeTwentyFive + lengthOfFiveHundred;
            oneEightyData.insert(indexValSixFifty, SixFiftyHeadData);
          }

          if (lengthOfBeerSizes[1] != 0) {
            indexValFiveHundred = lengthOfThreeTwentyFive;
            oneEightyData.insert(indexValFiveHundred, FiveHundredHeadData);
            indexValSixFiftyCheck =
                lengthOfThreeTwentyFive + lengthOfFiveHundred + 1;
          } else {
            indexValSixFiftyCheck =
                lengthOfThreeTwentyFive + lengthOfFiveHundred;
          }

          if (lengthOfBeerSizes[0] != 0) {
            oneEightyData.insert(0, ThreeTwentyFiveHeadData);
            indexValFiveHundred + 1;
            indexValFiveHundredCheck = lengthOfThreeTwentyFive + 1;
          } else {
            indexValFiveHundredCheck = lengthOfThreeTwentyFive;
          }

          if (lengthOfBeerSizes[0] != 0) {
            boldIndices.add(0);
          }

          if (lengthOfBeerSizes[1] != 0) {
            boldIndices.add(indexValFiveHundredCheck);
          }

          if (lengthOfBeerSizes[2] != 0) {
            boldIndices.add(indexValSixFiftyCheck);
          }
        }

        const PdfColor evenRowColor = PdfColors.grey200;
        const PdfColor oddRowColor = PdfColors.white;

        return pw.Table(
          border: pw.TableBorder.all(width: 1, color: PdfColors.grey),
          columnWidths: {
            0: const pw.FixedColumnWidth(200),
            1: const pw.FixedColumnWidth(200),
            2: const pw.FixedColumnWidth(200),
            3: const pw.FixedColumnWidth(200),
            4: const pw.FixedColumnWidth(200),
            5: const pw.FixedColumnWidth(200),
          },
          children: [
            for (final row in firstHead)
              pw.TableRow(
                children: [
                  for (int i = 0; i < row.length; i++)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(
                        left: 4,
                        right: 4,
                        top: 4,
                        bottom: 4,
                      ),
                      child: pw.Container(
                        height: 11,
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          row[i],
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 8,
                            color: i >= 3 || row[i] == 'Fridge Details'
                                ? PdfColors.black
                                : PdfColors.grey,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

            for (final row in secondHead)
              pw.TableRow(
                children: [
                  for (int i = 0; i < row.length; i++)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(
                        left: 4,
                        right: 4,
                        top: 4,
                        bottom: 4,
                      ),
                      child: pw.Container(
                        height: 11,
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          row[i],
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 8,
                            color: i >= 3 ? PdfColors.black : PdfColors.grey,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

            for (int index = 0; index < oneEightyData.length; index++)
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: index % 2 == 0 ? evenRowColor : oddRowColor,
                ),
                children: [
                  for (var i = 0; i < oneEightyData[index].length; i++)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(
                        left: 4,
                        right: 4,
                        top: 4,
                        bottom: 4,
                      ),
                      child: pw.Container(
                        height: 11,
                        child: pw.Text(
                          oneEightyData[index][i],
                          style: pw.TextStyle(
                            fontSize: i == 3 ? 9.5 : 9.5,
                            fontWeight: i == 3
                                ? pw.FontWeight.bold
                                : pw.FontWeight.normal,
                            color: i == 3 ? color : PdfColors.grey,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            for (final row in lastRow)
              pw.TableRow(
                children: [
                  for (int i = 0; i < row.length; i++)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(
                        left: 4,
                        right: 4,
                        top: 4,
                        bottom: 4,
                      ),
                      child: pw.Container(
                        height: 11,
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          row[i],
                          style: pw.TextStyle(
                            fontSize: 9.5,
                            fontWeight: pw.FontWeight.bold,
                            color: i >= 3 ? PdfColors.black : PdfColors.grey,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        );
      }

      int count = 0;

      int loopCount = 0;
      int renderLastRow = 0;
      int loopOrdCount = 0;
      int renderOrdLastRow = 0;
      int loopMdmCount = 0;
      int renderMdmLastRow = 0;
      int loopPreCount = 0;
      int renderPreLastRow = 0;
      int loopThousandCount = 0;
      int renderThousandLastRow = 0;

      List<int> totalPreLength = [];
      pw.Widget premiumOneEightyTable(
        List<List<String>> oneEightyData,
        PdfColor color,
        List<List<String>> firstHead,
        String tableName,
        lastRow,
        isSevenFifty,
        headings,
      ) {
        print('oneEightyData $oneEightyData');

        int totalLength = 0;
        int totalRows = 0;

        print('tablenameee  $tableName');

        final columnWidths = isSevenFifty
            ? {
                0: const pw.FixedColumnWidth(200),
                1: const pw.FixedColumnWidth(200),
                2: const pw.FixedColumnWidth(200),
                3: const pw.FixedColumnWidth(200),
                4: const pw.FixedColumnWidth(200),
                5: const pw.FixedColumnWidth(200),
              }
            : {
                0: const pw.FixedColumnWidth(200),
                1: const pw.FixedColumnWidth(200),
                2: const pw.FixedColumnWidth(200),
                3: const pw.FixedColumnWidth(200),
                4: const pw.FixedColumnWidth(200),
                5: const pw.FixedColumnWidth(200),
                6: const pw.FixedColumnWidth(200),
              };

        if (tableName == 'ORDINARY') {
          totalLength = oneEightyData.length;
          ordTableCount = ordTableEnd.length;

          if (ordTableCount == 4) {
            renderOrdLastRow = 10;
          } else if (ordTableCount == 5) {
            renderOrdLastRow = 13;
          } else if (ordTableCount == 3) {
            print('table count equal to 3');
            renderOrdLastRow = 7;
          } else if (ordTableCount == 2) {
            renderOrdLastRow = 4;
          } else {
            renderOrdLastRow = 1;
          }

          loopOrdCount++;

          loopCount = loopOrdCount;
          renderLastRow = renderOrdLastRow;
        }

        if (tableName == 'MEDIUM') {
          totalLength = oneEightyData.length;
          mdmTableCount = mdmTableEnd.length;

          if (mdmTableCount == 4) {
            renderMdmLastRow = 10;
          } else if (mdmTableCount == 5) {
            renderMdmLastRow = 13;
          } else if (mdmTableCount == 3) {
            print('table count equal to 3');
            renderMdmLastRow = 7;
          } else if (mdmTableCount == 2) {
            renderMdmLastRow = 4;
          } else {
            renderMdmLastRow = 1;
          }
          loopMdmCount++;

          loopCount = loopMdmCount;
          renderLastRow = renderMdmLastRow;
        }

        if (tableName == 'THOUSAND') {
          totalLength = oneEightyData.length;
          thousandTableCount = thousandTableEnd.length;

          if (thousandTableCount == 4) {
            renderThousandLastRow = 10;
          } else if (thousandTableCount == 5) {
            renderThousandLastRow = 13;
          } else if (thousandTableCount == 3) {
            print('table count equal to 3');
            renderThousandLastRow = 7;
          } else if (thousandTableCount == 2) {
            renderThousandLastRow = 4;
          } else {
            renderThousandLastRow = 1;
          }
          loopThousandCount++;
          loopCount = loopThousandCount;
          renderLastRow = renderThousandLastRow;
        }

        if (tableName == 'PREMIUM') {
          preDataLen.add(oneEightyData.length);
          totalLength = oneEightyData.length;
          totalPreLength.add(totalLength);

          preLastValue = preTableEnd.last;
          print('preLastValue $preLastValue');
          preTableCount = preTableEnd.length;

          totalRows = tableLastRowGetCalculatoin(totalPreLength, preTableCount);

          print('totalRows44444444444 $totalRows');
          print('datadata333333 ${oneEightyData.length}');
          print('preTableEnd33333 $preTableEnd');
          print('lastRowlastRowssss $lastRow');
          print('totalLengthsss $totalLength');

          if (preTableCount == 4) {
            renderPreLastRow = 10;
          } else if (preTableCount == 5) {
            renderPreLastRow = 13;
          } else if (preTableCount == 3) {
            print('table count equal to 3');
            renderPreLastRow = 7;
          } else if (preTableCount == 2) {
            renderPreLastRow = 4;
          } else {
            renderPreLastRow = 1;
          }

          loopPreCount++;

          loopCount = loopPreCount;
          renderLastRow = renderPreLastRow;
          print('preDataLen555555 $preDataLen');
          print('loopCount333333 $loopPreCount');
          print('renderLastRow2222 $renderPreLastRow');
          print('oneEightyDataoneEightyData $oneEightyData');
          print('totalPreLength333333333 $totalPreLength');
          print('preTableCount444 $preTableCount');
        }

        print('loopCount++++ $loopCount');
        print('renderLastRow++++ $renderLastRow');
        print('counttt $count');

        print('preDataLenpreDataLen66 $preDataLen');

        String? val1;
        int totOp = 0;
        int totRcpt = 0;
        int totOpAndRcpt = 0;

        for (final val in oneEightyData) {
          totOp += int.parse(val[1]);
          totRcpt += int.parse(val[2]);
          totOpAndRcpt += int.parse(val[3]);
          if (val[1] == '0') {
            val[1] = '';
            val1 = '';
          }
          if (val[2] == '0') {
            val[2] = '';
          }
          if (val[3] == '0') {
            val[3] = '';
          }
          print(
            'subVal[1] $totOp, subVal[2] $totRcpt, subVal[3] $totOpAndRcpt',
          );
        }

        const PdfColor evenRowColor = PdfColors.grey200;
        const PdfColor oddRowColor = PdfColors.white;

        return pw.Table(
          border: pw.TableBorder.all(width: 1, color: PdfColors.grey),
          columnWidths: columnWidths,
          children: [
            for (final row in firstHead)
              pw.TableRow(
                children: [
                  for (int i = 0; i < row.length; i++)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(
                        left: 4,
                        right: 4,
                        top: 4,
                        bottom: 4,
                      ),
                      child: pw.Container(
                        height: 11,
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          row[i],
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 8,
                            color: i >= 3 ? PdfColors.black : PdfColors.grey,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

            for (final row in headings)
              pw.TableRow(
                children: [
                  for (int i = 0; i < row.length; i++)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(
                        left: 4,
                        right: 4,
                        top: 4,
                        bottom: 4,
                      ),
                      child: pw.Container(
                        height: 11,
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          row[i],
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 8,
                            color: i >= 3 ? PdfColors.black : PdfColors.grey,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

            for (int index = 0; index < oneEightyData.length; index++)
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: index % 2 == 0 ? evenRowColor : oddRowColor,
                ),
                children: [
                  for (var i = 0; i < oneEightyData[index].length; i++)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(
                        left: 4,
                        right: 4,
                        top: 4,
                        bottom: 4,
                      ),
                      child: pw.Container(
                        height: 11,
                        child: pw.Text(
                          oneEightyData[index][i],
                          style: pw.TextStyle(
                            fontSize: i == 3 ? 9.5 : 9.5,
                            fontWeight: i == 3
                                ? pw.FontWeight.bold
                                : pw.FontWeight.normal,
                            color: i == 3 ? color : PdfColors.grey,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),

            if (loopCount >= renderLastRow)
              for (final row in lastRow)
                pw.TableRow(
                  children: [
                    for (int i = 0; i < row.length; i++)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(
                          left: 4,
                          right: 4,
                          top: 4,
                          bottom: 4,
                        ),
                        child: pw.Container(
                          height: 11,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            row[i],
                            style: pw.TextStyle(
                              fontSize: 9.5,
                              fontWeight: pw.FontWeight.bold,
                              color: i >= 3 ? PdfColors.black : PdfColors.grey,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
          ],
        );
      }

      pw.Widget openingSummary() {
        const PdfColor evenRowColor = PdfColors.grey200;
        const PdfColor oddRowColor = PdfColors.white;

        return pw.Table(
          border: pw.TableBorder.all(width: 1),
          children: [
            for (final row in openingSummaryHeading)
              pw.TableRow(
                children: [
                  for (final cell in row)
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        cell,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,

                          fontSize: 11,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                ],
              ),

            for (int index = 0; index < opSummary.length; index++)
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: index % 2 == 0 ? evenRowColor : oddRowColor,
                ),
                children: [
                  for (int i = 0; i < opSummary[index].length; i++)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(
                        left: 4,
                        right: 4,
                        top: 3,
                        bottom: 3,
                      ),
                      child: pw.Container(
                        height: 20,

                        width: i < 7 ? null : 80,
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          opSummary[index][i],
                          style: const pw.TextStyle(fontSize: 12),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
          ],
        );
      }

      final mainTable = pw.Table(
        border: pw.TableBorder.all(width: 1),
        columnWidths: {
          0: const pw.FixedColumnWidth(150),
          1: const pw.FixedColumnWidth(225),
          2: const pw.FixedColumnWidth(225),
          3: const pw.FixedColumnWidth(200),
        },
        children: [
          for (int i = 0; i < ordinaryHeadingChunks.length; i++)
            pw.TableRow(
              children: [
                pw.Container(
                  child: generateTable(
                    ordinaryHeadingChunks[i],
                    firstOrdinaryColumn,
                    false,
                    'ORDINARY',
                  ),
                ),
                pw.Container(
                  child: premiumOneEightyTable(
                    ordinaryOneEightyChunks[i],
                    PdfColors.blue900,
                    firstHeadingOneEighty,
                    'ORDINARY',
                    ordOneLastRow,
                    false,
                    headings,
                  ),
                ),
                pw.Container(
                  child: premiumOneEightyTable(
                    ordinaryThreeSeventFiveChunks[i],
                    PdfColors.blue900,
                    firstHeadingThreeSeventyFive,
                    'ORDINARY',
                    ordThreeSeventyFiveLastRow,
                    false,
                    headings,
                  ),
                ),
                pw.Container(
                  child: premiumOneEightyTable(
                    ordinarySevenFiftyChunks[i],
                    PdfColors.blue900,
                    firstHeadingSevenFifty,
                    'ORDINARY',
                    ordSevenFiftyLastRow,
                    true,
                    sevenFiftyHeadings,
                  ),
                ),
              ],
            ),
        ],
      );

      final mideumTable = pw.Table(
        border: pw.TableBorder.all(width: 1),
        columnWidths: {
          0: const pw.FixedColumnWidth(150),
          1: const pw.FixedColumnWidth(225),
          2: const pw.FixedColumnWidth(225),
          3: const pw.FixedColumnWidth(200),
        },
        children: [
          for (int i = 0; i < mediumHeadingChunks.length; i++)
            pw.TableRow(
              children: [
                pw.Container(
                  child: generateTable(
                    mediumHeadingChunks[i],
                    firstMediumColumn,
                    false,
                    'MEDIUM',
                  ),
                ),
                pw.Container(
                  child: premiumOneEightyTable(
                    mediumOneEightyChunks[i],
                    PdfColors.blue900,
                    firstHeadingOneEighty,
                    'MEDIUM',
                    mdmOneLastRow,
                    false,
                    headings,
                  ),
                ),
                pw.Container(
                  child: premiumOneEightyTable(
                    mediumThreeSeventFiveChunks[i],
                    PdfColors.blue900,
                    firstHeadingThreeSeventyFive,
                    'MEDIUM',
                    mdmThreeSeventyFiveLastRow,
                    false,
                    headings,
                  ),
                ),
                pw.Container(
                  child: premiumOneEightyTable(
                    mediumSevenFiftyChunks[i],
                    PdfColors.blue900,
                    firstHeadingSevenFifty,
                    'MEDIUM',
                    mdmSevenFiftyLastRow,
                    true,
                    sevenFiftyHeadings,
                  ),
                ),
              ],
            ),
        ],
      );

      pw.Widget premiumTable() {
        List<List<String>> preOneLastRow = [];
        List<List<String>> preThreeSeventyFiveLastRow = [];
        List<List<String>> preSevenFiftyLastRow = [];

        int loopCount = 0;
        for (int i = 0; i < chunks.length; i++) {
          print('loopCountvvv $loopCount');
          print('chunks[i]11111 ${chunks[i]}');
          print('oneEightyChunks[i] ${oneEightyChunks[i]}');
          print('ThreeSeventFiveChunks[i] ${ThreeSeventFiveChunks[i]}');
          print('SevenFiftyChunks[i] ${SevenFiftyChunks[i]}');
          print('ffffffffff $i');
          print('cccccccccc $c');

          loopCount = i + 1;

          if (loopCount == c) {
            print('cccxxxxxx $c == $loopCount');
            if (preOneEighty.isNotEmpty) {
              preOneLastRow = [
                ['', preOneEighty[1], preOneEighty[2], preOneEighty[3]],
              ];
            }

            if (preThreeSeventyFive.isNotEmpty) {
              preThreeSeventyFiveLastRow = [
                [
                  '',
                  preThreeSeventyFive[1],
                  preThreeSeventyFive[2],
                  preThreeSeventyFive[3],
                ],
              ];
            }

            if (presevenFifty.isNotEmpty) {
              preSevenFiftyLastRow = [
                ['', presevenFifty[1], presevenFifty[2], presevenFifty[3]],
              ];
            }
          } else {
            preOneLastRow = [
              ['', '', '', ''],
            ];

            preThreeSeventyFiveLastRow = [
              ['', '', '', ''],
            ];

            preSevenFiftyLastRow = [
              ['', '', '', ''],
            ];
            print('vvsss $loopCount vvcccc $c');

            print(
              'preOneLastRow--- $preOneLastRow preThreeSeventyFiveLastRow $preThreeSeventyFiveLastRow preSevenFiftyLastRow $preSevenFiftyLastRow',
            );
          }
        }

        if (loopCount == c) {
          print(
            'preOneLastRowddd $preOneLastRow preThreeSeventyFiveLastRow $preThreeSeventyFiveLastRow preSevenFiftyLastRow $preSevenFiftyLastRow',
          );
        } else {
          print(
            'preOneLastRow--- $preOneLastRow preThreeSeventyFiveLastRow $preThreeSeventyFiveLastRow preSevenFiftyLastRow $preSevenFiftyLastRow',
          );
        }

        return pw.Table(
          border: pw.TableBorder.all(width: 1),
          columnWidths: {
            0: const pw.FixedColumnWidth(150),
            1: const pw.FixedColumnWidth(225),
            2: const pw.FixedColumnWidth(225),
            3: const pw.FixedColumnWidth(200),
          },
          children: [
            for (int i = 0; i < chunks.length; i++)
              pw.TableRow(
                children: [
                  pw.Container(
                    child: generateTable(
                      chunks[i],
                      firstPremiumColumn,
                      false,
                      'PREMIUM',
                    ),
                  ),
                  pw.Container(
                    child: premiumOneEightyTable(
                      oneEightyChunks[i],
                      PdfColors.blue900,
                      firstHeadingOneEighty,
                      'PREMIUM',
                      (loopCount == c)
                          ? preOneLastRow
                          : [
                              ['', '', '', ''],
                            ],
                      false,
                      headings,
                    ),
                  ),
                  pw.Container(
                    child: premiumOneEightyTable(
                      ThreeSeventFiveChunks[i],
                      PdfColors.blue900,
                      firstHeadingThreeSeventyFive,
                      'PREMIUM',
                      (loopCount == c)
                          ? preThreeSeventyFiveLastRow
                          : [
                              ['', '', '', ''],
                            ],
                      false,
                      headings,
                    ),
                  ),
                  pw.Container(
                    child: premiumOneEightyTable(
                      SevenFiftyChunks[i],
                      PdfColors.blue900,
                      firstHeadingSevenFifty,
                      'PREMIUM',
                      (loopCount == c)
                          ? preSevenFiftyLastRow
                          : [
                              ['', '', '', ''],
                            ],
                      true,
                      sevenFiftyHeadings,
                    ),
                  ),
                ],
              ),
          ],
        );
      }

      final beerTable = pw.Table(
        border: pw.TableBorder.all(width: 1),
        columnWidths: {
          0: const pw.FixedColumnWidth(200),
          1: const pw.FixedColumnWidth(200),
          2: const pw.FixedColumnWidth(400),
        },
        children: [
          for (int i = 0; i < beerHeadingchunks.length; i++)
            pw.TableRow(
              children: [
                pw.Container(
                  child: generateBeerTable(beerHeadingchunks[i], beerHeading),
                ),
                pw.Container(
                  child: beerDataTable(
                    beerDataChunks[i],
                    PdfColors.blue900,
                    beerHeadingOne,
                    sevenFiftyHeadings,
                  ),
                ),
                pw.Container(
                  child: beerDataTable(
                    beerEmptyCol,
                    PdfColors.blue900,
                    beerEmptyColHead,
                    beerEmptyCol,
                  ),
                ),
              ],
            ),
        ],
      );

      final oneThousandTable = pw.Table(
        border: pw.TableBorder.all(width: 1),
        columnWidths: {
          0: const pw.FixedColumnWidth(200),
          1: const pw.FixedColumnWidth(200),
          2: const pw.FixedColumnWidth(200),
          3: const pw.FixedColumnWidth(200),
        },
        children: [
          for (int i = 0; i < oneThousandHeadingChunks.length; i++)
            pw.TableRow(
              children: [
                pw.Container(
                  child: generateTable(
                    oneThousandHeadingChunks[i],
                    oneThousandHeading,
                    false,
                    'THOUSAND',
                  ),
                ),
                pw.Container(
                  child: premiumOneEightyTable(
                    ordinaryOneThousandChunks[i],
                    PdfColors.pink,
                    oneThousandHeadingOne,
                    'THOUSAND',
                    ordThousandRow,
                    true,
                    sevenFiftyHeadings,
                  ),
                ),
                pw.Container(
                  child: premiumOneEightyTable(
                    mediumOneThousandChunks[i],
                    PdfColors.pink,
                    oneThousandHeadingTwo,
                    'THOUSAND',
                    mdmThousandRow,
                    true,
                    sevenFiftyHeadings,
                  ),
                ),
                pw.Container(
                  child: premiumOneEightyTable(
                    premiumOneThousandChunks[i],
                    PdfColors.pink,
                    oneThousandHeadingThree,
                    'THOUSAND',
                    preThousandRow,
                    true,
                    sevenFiftyHeadings,
                  ),
                ),
              ],
            ),
        ],
      );

      final font = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');

      pdf.addPage(
        pw.MultiPage(
          maxPages: 100,
          pageFormat: PdfPageFormat.legal.landscape,
          margin: const pw.EdgeInsets.all(20),
          build: (context) => [
            heading(),
            pw.SizedBox(height: 10),
            mainTable,
            pw.SizedBox(height: 10),
            mideumTable,
            pw.SizedBox(height: 10),
            premiumTable(),

            pw.SizedBox(height: 10),
            oneThousandTable,
            pw.SizedBox(height: 10),
            beerTable,
            pw.SizedBox(height: 20),
          ],
        ),
      );

      pdf.addPage(
        pw.MultiPage(
          maxPages: 100,
          pageFormat: PdfPageFormat.legal.landscape,
          margin: const pw.EdgeInsets.all(20),
          build: (context) => [pw.SizedBox(height: 10), openingSummary()],
        ),
      );
    }

    Future<void> saveFilePermanently(Uint8List bytes) async {
      final blob = html.Blob([bytes], 'application/pdf');

      final url = html.Url.createObjectUrlFromBlob(blob);
      String fileName = '';

      if (isDailyStatement == true) {
        fileName = '$shopId - $date report.pdf';
      } else {
        fileName = '$shopId - $date OP report.pdf';
      }

      html.AnchorElement(href: url)
        ..download = fileName
        ..click();

      html.Url.revokeObjectUrl(url);

      // final anchor = html.AnchorElement(href: url)
      //   ..setAttribute("download", fileName)
      //   ..click();
      //
      // html.Url.revokeObjectUrl(url);
    }

    // Future<File?> saveFilePermanently(
    //   directory,
    //   String fileName,
    //   Uint8List bytes,
    //   String folderMonthAndYear,
    // ) async {
    //   String newFilePath = '';
    //   if (isDailyStatement) {
    //     String basePathReportsPdf =
    //         '/storage/emulated/0/Download/Stock Chitta/Reports PDF/$folderMonthAndYear';
    //     final baseDirectoryReportsPdf = Directory(basePathReportsPdf);
    //     if (!await baseDirectoryReportsPdf.exists()) {
    //       await baseDirectoryReportsPdf.create(recursive: true);
    //     }
    //     print('baseDirectory pdf pdf $baseDirectoryReportsPdf');
    //
    //     newFilePath = join(baseDirectoryReportsPdf.path, fileName);
    //   } else {
    //     String baseOBPathReportsPdf =
    //         '/storage/emulated/0/Download/Stock Chitta/OP Reports PDF/$folderMonthAndYear';
    //     final baseDirectoryOBReportsPdf = Directory(baseOBPathReportsPdf);
    //     if (!await baseDirectoryOBReportsPdf.exists()) {
    //       await baseDirectoryOBReportsPdf.create(recursive: true);
    //     }
    //     print('baseDirectory pdf pdf $baseDirectoryOBReportsPdf');
    //
    //     newFilePath = join(baseDirectoryOBReportsPdf.path, fileName);
    //   }
    //
    //   final file;
    //   if (isSmsPage) {
    //     file = File(newFilePath);
    //     await file.writeAsBytes(bytes);
    //   } else {
    //     file = File(newFilePath);
    //     await file
    //         .writeAsBytes(bytes)
    //         .then(
    //           (value) => Fluttertoast.showToast(
    //             msg: "PDF Successfully Generated.",
    //             toastLength: Toast.LENGTH_SHORT,
    //             gravity: ToastGravity.BOTTOM,
    //
    //             timeInSecForIosWeb: 1,
    //             backgroundColor: Colors.green,
    //           ),
    //         );
    //   }
    //
    //   if (isSmsPage == false) {
    //     Share.shareXFiles([
    //       XFile(newFilePath),
    //     ], text: 'Here is your PDF report.');
    //   }
    //   print('PDF saved to: ${file.path}');
    //
    //   return file;
    // }

    Future<void> storageAccesss(Uint8List pdfBytes) async {
      await saveFilePermanently(pdfBytes);
    }

    // Future<bool> storageAccesss(Uint8List pdfBytes) async {
    //   bool storageStatus = false;
    //
    //   File? file;
    //
    //   if (Platform.isAndroid) {
    //     final deviceInfoPlugin = DeviceInfoPlugin();
    //     final androidInfo = await deviceInfoPlugin.androidInfo;
    //     int sdkInt = androidInfo.version.sdkInt;
    //     print('vvvvvvvvvvvv $sdkInt');
    //     DateFormat inputFormat = DateFormat('dd-MM-yyyy');
    //     DateFormat outputFormat = DateFormat('MMMM yyyy');
    //
    //     DateTime parsedDate = inputFormat.parse(date);
    //     String folderMonthAndYear = outputFormat.format(parsedDate);
    //
    //     if (sdkInt >= 30) {
    //       final directory = await getExternalStorageDirectory();
    //
    //       print('directory222 $directory');
    //       if (directory != null) {
    //         if (isDailyStatement == true) {
    //           file = await saveFilePermanently(
    //             directory,
    //             '$shopId - $date report.pdf',
    //             pdfBytes,
    //             folderMonthAndYear,
    //           );
    //         } else {
    //           file = await saveFilePermanently(
    //             directory,
    //             '$shopId - $date OP report.pdf',
    //             pdfBytes,
    //             folderMonthAndYear,
    //           );
    //         }
    //       }
    //     } else {
    //       PermissionStatus status = await Permission.storage.request();
    //       if (status.isGranted) {
    //         final directory = await getExternalStorageDirectory();
    //         if (directory != null) {
    //           if (isDailyStatement == true) {
    //             file = await saveFilePermanently(
    //               directory,
    //               '$shopId - $date report.pdf',
    //               pdfBytes,
    //               folderMonthAndYear,
    //             );
    //           } else {
    //             file = await saveFilePermanently(
    //               directory,
    //               '$shopId - $date OP report.pdf',
    //               pdfBytes,
    //               folderMonthAndYear,
    //             );
    //           }
    //           if (file != null) {
    //             print("Storage access granted to store pdf");
    //             storageStatus = true;
    //           } else {
    //             print("Failed to save PDF");
    //             storageStatus = false;
    //           }
    //         } else {
    //           storageStatus = false;
    //         }
    //       } else {
    //         print("Storage access denied");
    //         storageStatus = false;
    //       }
    //     }
    //   } else {}
    //
    //   print('storageStatus22 $storageStatus');
    //   return storageStatus;
    // }

    print('bf storageAccess');

    final pdfBytes = await pdf.save();

    await storageAccesss(pdfBytes);
    // bool status = await storageAccesss(pdfBytes);

    print('af storageAccess');

    // print('status111 $status');
    //
    // if (status == true) {
    // } else {}
  }

  Future<List<int>> ordinaryDatas(List<dynamic> items) async {
    final totalOrdinaryOneEightyOpeningBtls = items[0];
    final ordinaryThreeSeventyFiveOpBtls = items[1];
    final ordinarySevenFiftyOpBtls = items[2];
    final ordinaryOneThousandOpBtls = items[3];

    final totalOrdinaryOneEightyPurchaseBtls = items[4];
    final ordinaryThreeSeventyFivePurchaseBtls = items[5];
    final ordinarySevenFiftyPurchaseBtls = items[6];
    final ordinaryOneThousandPurchaseBtls = items[7];

    final totalOrdinaryOneEightyOpeingAndPurchaseBtls = items[8];
    final ordinaryThreeSeventyFiveOpeingAndPurchaseBtls = items[9];
    final ordinarySevenFiftyOpeingAndPurchaseBtls = items[10];
    final ordinaryOneThousandOpeingAndPurchaseBtls = items[11];

    final totalOrdinaryOneEightyClosingBtls = items[12];
    final ordinaryThreeSeventyFiveClosingBtls = items[13];
    final ordinarySevenFiftyClosingBtls = items[14];
    final ordinaryOneThousandClosingBtls = items[15];

    final totalOrdinaryOneEightySalesBtls = items[16];
    final ordinaryThreeSeventyFiveSalesBtls = items[17];
    final ordinarySevenFiftySalesBtls = items[18];
    final ordinaryOneThousandSalesBtls = items[19];

    final totalOrdinaryOneEightyTotalValues = items[20];
    final ordinaryThreeSeventyFiveTotalValues = items[21];
    final ordinarySevenFiftyTotalValues = items[22];
    final ordinaryOneThousandTotalValues = items[23];

    final List<List<int>> ordinaryOneEightyLastRowVal = [
      totalOrdinaryOneEightyOpeningBtls,
      totalOrdinaryOneEightyPurchaseBtls,
      totalOrdinaryOneEightyOpeingAndPurchaseBtls,
      totalOrdinaryOneEightyClosingBtls,
      totalOrdinaryOneEightySalesBtls,
      totalOrdinaryOneEightyTotalValues,

      ordinaryThreeSeventyFiveOpBtls,
      ordinaryThreeSeventyFivePurchaseBtls,
      ordinaryThreeSeventyFiveOpeingAndPurchaseBtls,
      ordinaryThreeSeventyFiveClosingBtls,
      ordinaryThreeSeventyFiveSalesBtls,
      ordinaryThreeSeventyFiveTotalValues,

      ordinarySevenFiftyOpBtls,
      ordinarySevenFiftyPurchaseBtls,
      ordinarySevenFiftyOpeingAndPurchaseBtls,
      ordinarySevenFiftyClosingBtls,
      ordinarySevenFiftySalesBtls,
      ordinarySevenFiftyTotalValues,

      ordinaryOneThousandOpBtls,
      ordinaryOneThousandPurchaseBtls,
      ordinaryOneThousandOpeingAndPurchaseBtls,
      ordinaryOneThousandClosingBtls,
      ordinaryOneThousandSalesBtls,
      ordinaryOneThousandTotalValues,
    ];

    int OrdinaryOneEightyOpeningBtlsCount = 0;
    int OrdinaryOneEightyPurchaseBtlsCount = 0;
    int OrdinaryOneEightyOpeingAndPurchaseBtlsCount = 0;
    int OrdinaryOneEightyClosingBtlsCount = 0;
    int OrdinaryOneEightySalesBtlsCount = 0;
    int OrdinaryOneEightyTotalValues = 0;

    int ordinaryThreeSeventyFiveOpBtlsCount = 0;
    int ordinaryThreeSeventyFivePurchaseBtlsCount = 0;
    int ordinaryThreeSeventyFiveOpeingAndPurchaseBtlsCount = 0;
    int ordinaryThreeSeventyFiveClosingBtlsCount = 0;
    int ordinaryThreeSeventyFiveSalesBtlsCount = 0;
    int ordinaryThreeSeventyFiveTotalValuesCount = 0;

    int ordinarySevenFiftyOpBtlsCount = 0;
    int ordinarySevenFiftyPurchaseBtlsCount = 0;
    int ordinarySevenFiftyOpeingAndPurchaseBtlsCount = 0;
    int ordinarySevenFiftyClosingBtlsCount = 0;
    int ordinarySevenFiftySalesBtlsCount = 0;
    int ordinarySevenFiftyTotalValuesCount = 0;

    int ordinaryOneThousandOpBtlsCount = 0;
    int ordinaryOneThousandPurchaseBtlsCount = 0;
    int ordinaryOneThousandOpeingAndPurchaseBtlsCount = 0;
    int ordinaryOneThousandClosingBtlsCount = 0;
    int ordinaryOneThousandSalesBtlsCount = 0;
    int ordinaryOneThousandTotalValuesCount = 0;

    for (int i = 0; i < ordinaryOneEightyLastRowVal.length; i++) {
      for (int subList in ordinaryOneEightyLastRowVal[i]) {
        if (i == 0) {
          OrdinaryOneEightyOpeningBtlsCount += subList;
        } else if (i == 1) {
          OrdinaryOneEightyPurchaseBtlsCount += subList;
        } else if (i == 2) {
          OrdinaryOneEightyOpeingAndPurchaseBtlsCount += subList;
        } else if (i == 3) {
          OrdinaryOneEightyClosingBtlsCount += subList;
        } else if (i == 4) {
          OrdinaryOneEightySalesBtlsCount += subList;
        } else if (i == 5) {
          OrdinaryOneEightyTotalValues += subList;
        } else if (i == 6) {
          ordinaryThreeSeventyFiveOpBtlsCount += subList;
        } else if (i == 7) {
          ordinaryThreeSeventyFivePurchaseBtlsCount += subList;
        } else if (i == 8) {
          ordinaryThreeSeventyFiveOpeingAndPurchaseBtlsCount += subList;
        } else if (i == 9) {
          ordinaryThreeSeventyFiveClosingBtlsCount += subList;
        } else if (i == 10) {
          ordinaryThreeSeventyFiveSalesBtlsCount += subList;
        } else if (i == 11) {
          ordinaryThreeSeventyFiveTotalValuesCount += subList;
        } else if (i == 12) {
          ordinarySevenFiftyOpBtlsCount += subList;
        } else if (i == 13) {
          ordinarySevenFiftyPurchaseBtlsCount += subList;
        } else if (i == 14) {
          ordinarySevenFiftyOpeingAndPurchaseBtlsCount += subList;
        } else if (i == 15) {
          ordinarySevenFiftyClosingBtlsCount += subList;
        } else if (i == 16) {
          ordinarySevenFiftySalesBtlsCount += subList;
        } else if (i == 17) {
          ordinarySevenFiftyTotalValuesCount += subList;
        } else if (i == 18) {
          ordinaryOneThousandOpBtlsCount += subList;
        } else if (i == 19) {
          ordinaryOneThousandPurchaseBtlsCount += subList;
        } else if (i == 20) {
          ordinaryOneThousandOpeingAndPurchaseBtlsCount += subList;
        } else if (i == 21) {
          ordinaryOneThousandClosingBtlsCount += subList;
        } else if (i == 22) {
          ordinaryOneThousandSalesBtlsCount += subList;
        } else if (i == 23) {
          ordinaryOneThousandTotalValuesCount += subList;
        }
      }
    }

    return [
      OrdinaryOneEightyOpeningBtlsCount,
      OrdinaryOneEightyPurchaseBtlsCount,
      OrdinaryOneEightyOpeingAndPurchaseBtlsCount,
      OrdinaryOneEightyClosingBtlsCount,
      OrdinaryOneEightySalesBtlsCount,
      OrdinaryOneEightyTotalValues,
      ordinaryThreeSeventyFiveOpBtlsCount,
      ordinaryThreeSeventyFivePurchaseBtlsCount,
      ordinaryThreeSeventyFiveOpeingAndPurchaseBtlsCount,
      ordinaryThreeSeventyFiveClosingBtlsCount,
      ordinaryThreeSeventyFiveSalesBtlsCount,
      ordinaryThreeSeventyFiveTotalValuesCount,
      ordinarySevenFiftyOpBtlsCount,
      ordinarySevenFiftyPurchaseBtlsCount,
      ordinarySevenFiftyOpeingAndPurchaseBtlsCount,
      ordinarySevenFiftyClosingBtlsCount,
      ordinarySevenFiftySalesBtlsCount,
      ordinarySevenFiftyTotalValuesCount,
      ordinaryOneThousandOpBtlsCount,
      ordinaryOneThousandPurchaseBtlsCount,
      ordinaryOneThousandOpeingAndPurchaseBtlsCount,
      ordinaryOneThousandClosingBtlsCount,
      ordinaryOneThousandSalesBtlsCount,
      ordinaryOneThousandTotalValuesCount,
    ];
  }

  Future<List<int>> mediumDatas(List<dynamic> items) async {
    final mediumOneEightyOpBtls = items[0];
    final mediumThreeSeventyFiveOpBtls = items[1];
    final mediumSevenFiftyOpBtls = items[2];
    final mediumOneThousandOpBtls = items[3];
    final mediumOneEightyPurchaseBtls = items[4];
    final mediumThreeSeventyFivePurchaseBtls = items[5];
    final mediumSevenFiftyPurchaseBtls = items[6];
    final mediumOneThousandPurchaseBtls = items[7];
    final mediumOneEightyOpeingAndPurchaseBtls = items[8];
    final mediumThreeSeventyFiveOpeingAndPurchaseBtls = items[9];
    final mediumSevenFiftyOpeingAndPurchaseBtls = items[10];
    final mediumOneThousandOpeingAndPurchaseBtls = items[11];
    final mediumOneEightyClosingBtls = items[12];
    final mediumThreeSeventyFiveClosingBtls = items[13];
    final mediumSevenFiftyClosingBtls = items[14];
    final mediumOneThousandClosingBtls = items[15];
    final mediumOneEightySalesBtls = items[16];
    final mediumThreeSeventyFiveSalesBtls = items[17];
    final mediumSevenFiftySalesBtls = items[18];
    final mediumOneThousandSalesBtls = items[19];
    final mediumOneEightyTotalValues = items[20];
    final mediumThreeSeventyFiveTotalValues = items[21];
    final mediumSevenFiftyTotalValues = items[22];
    final mediumOneThousandTotalValues = items[23];

    final List<List<int>> mediumLastRowDataList = [
      mediumOneEightyOpBtls,
      mediumOneEightyPurchaseBtls,
      mediumOneEightyOpeingAndPurchaseBtls,
      mediumOneEightyClosingBtls,
      mediumOneEightySalesBtls,
      mediumOneEightyTotalValues,

      mediumThreeSeventyFiveOpBtls,
      mediumThreeSeventyFivePurchaseBtls,
      mediumThreeSeventyFiveOpeingAndPurchaseBtls,
      mediumThreeSeventyFiveClosingBtls,
      mediumThreeSeventyFiveSalesBtls,
      mediumThreeSeventyFiveTotalValues,

      mediumSevenFiftyOpBtls,
      mediumSevenFiftyPurchaseBtls,
      mediumSevenFiftyOpeingAndPurchaseBtls,
      mediumSevenFiftyClosingBtls,
      mediumSevenFiftySalesBtls,
      mediumSevenFiftyTotalValues,

      mediumOneThousandOpBtls,
      mediumOneThousandPurchaseBtls,
      mediumOneThousandOpeingAndPurchaseBtls,
      mediumOneThousandClosingBtls,
      mediumOneThousandSalesBtls,
      mediumOneThousandTotalValues,
    ];

    int mediumOneEightyOpBtlsCount = 0;
    int mediumOneEightyPurchaseBtlsCount = 0;
    int mediumOneEightyOpeingAndPurchaseBtlsCount = 0;
    int mediumOneEightyClosingBtlsCount = 0;
    int mediumOneEightySalesBtlsCount = 0;
    int mediumOneEightyTotalValuesCount = 0;

    int mediumThreeSeventyFiveOpBtlsCount = 0;
    int mediumThreeSeventyFivePurchaseBtlsCount = 0;
    int mediumThreeSeventyFiveOpeingAndPurchaseBtlsCount = 0;
    int mediumThreeSeventyFiveClosingBtlsCount = 0;
    int mediumThreeSeventyFiveSalesBtlsCount = 0;
    int mediumThreeSeventyFiveTotalValuesCount = 0;

    int mediumSevenFiftyOpBtlsCount = 0;
    int mediumSevenFiftyPurchaseBtlsCount = 0;
    int mediumSevenFiftyOpeingAndPurchaseBtlsCount = 0;
    int mediumSevenFiftyClosingBtlsCount = 0;
    int mediumSevenFiftySalesBtlsCount = 0;
    int mediumSevenFiftyTotalValuesCount = 0;

    int mediumOneThousandOpBtlsCount = 0;
    int mediumOneThousandPurchaseBtlsCount = 0;
    int mediumOneThousandOpeingAndPurchaseBtlsCount = 0;
    int mediumOneThousandClosingBtlsCount = 0;
    int mediumOneThousandSalesBtlsCount = 0;
    int mediumOneThousandTotalValuesCount = 0;

    for (int i = 0; i < mediumLastRowDataList.length; i++) {
      for (int subList in mediumLastRowDataList[i]) {
        if (i == 0) {
          mediumOneEightyOpBtlsCount += subList;
        } else if (i == 1) {
          mediumOneEightyPurchaseBtlsCount += subList;
        } else if (i == 2) {
          mediumOneEightyOpeingAndPurchaseBtlsCount += subList;
        } else if (i == 3) {
          mediumOneEightyClosingBtlsCount += subList;
        } else if (i == 4) {
          mediumOneEightySalesBtlsCount += subList;
        } else if (i == 5) {
          mediumOneEightyTotalValuesCount += subList;
        } else if (i == 6) {
          mediumThreeSeventyFiveOpBtlsCount += subList;
        } else if (i == 7) {
          mediumThreeSeventyFivePurchaseBtlsCount += subList;
        } else if (i == 8) {
          mediumThreeSeventyFiveOpeingAndPurchaseBtlsCount += subList;
        } else if (i == 9) {
          mediumThreeSeventyFiveClosingBtlsCount += subList;
        } else if (i == 10) {
          mediumThreeSeventyFiveSalesBtlsCount += subList;
        } else if (i == 11) {
          mediumThreeSeventyFiveTotalValuesCount += subList;
        } else if (i == 12) {
          mediumSevenFiftyOpBtlsCount += subList;
        } else if (i == 13) {
          mediumSevenFiftyPurchaseBtlsCount += subList;
        } else if (i == 14) {
          mediumSevenFiftyOpeingAndPurchaseBtlsCount += subList;
        } else if (i == 15) {
          mediumSevenFiftyClosingBtlsCount += subList;
        } else if (i == 16) {
          mediumSevenFiftySalesBtlsCount += subList;
        } else if (i == 17) {
          mediumSevenFiftyTotalValuesCount += subList;
        } else if (i == 18) {
          mediumOneThousandOpBtlsCount += subList;
        } else if (i == 19) {
          mediumOneThousandPurchaseBtlsCount += subList;
        } else if (i == 20) {
          mediumOneThousandOpeingAndPurchaseBtlsCount += subList;
        } else if (i == 21) {
          mediumOneThousandClosingBtlsCount += subList;
        } else if (i == 22) {
          mediumOneThousandSalesBtlsCount += subList;
        } else if (i == 23) {
          mediumOneThousandTotalValuesCount += subList;
        }
      }
    }

    return [
      mediumOneEightyOpBtlsCount,
      mediumOneEightyPurchaseBtlsCount,
      mediumOneEightyOpeingAndPurchaseBtlsCount,
      mediumOneEightyClosingBtlsCount,
      mediumOneEightySalesBtlsCount,
      mediumOneEightyTotalValuesCount,
      mediumThreeSeventyFiveOpBtlsCount,
      mediumThreeSeventyFivePurchaseBtlsCount,
      mediumThreeSeventyFiveOpeingAndPurchaseBtlsCount,
      mediumThreeSeventyFiveClosingBtlsCount,
      mediumThreeSeventyFiveSalesBtlsCount,
      mediumThreeSeventyFiveTotalValuesCount,
      mediumSevenFiftyOpBtlsCount,
      mediumSevenFiftyPurchaseBtlsCount,
      mediumSevenFiftyOpeingAndPurchaseBtlsCount,
      mediumSevenFiftyClosingBtlsCount,
      mediumSevenFiftySalesBtlsCount,
      mediumSevenFiftyTotalValuesCount,
      mediumOneThousandOpBtlsCount,
      mediumOneThousandPurchaseBtlsCount,
      mediumOneThousandOpeingAndPurchaseBtlsCount,
      mediumOneThousandClosingBtlsCount,
      mediumOneThousandSalesBtlsCount,
      mediumOneThousandTotalValuesCount,
    ];
  }

  Future<List<int>> premiumDatas(List<dynamic> items) async {
    final premiumOneEightyOpBtls = items[0];
    final premiumThreeSeventyFiveOpBtls = items[1];
    final premiumSevenFiftyOpBtls = items[2];
    final premiumOneThousandOpBtls = items[3];
    final premiumOneEightyPurchaseBtls = items[4];
    final premiumThreeSeventyFivePurchaseBtls = items[5];
    final premiumSevenFiftyPurchaseBtls = items[6];
    final premiumOneThousandPurchaseBtls = items[7];
    final premiumOneEightyOpeingAndPurchaseBtls = items[8];
    final premiumThreeSeventyFiveOpeingAndPurchaseBtls = items[9];
    final premiumSevenFiftyOpeingAndPurchaseBtls = items[10];
    final premiumOneThousandOpeingAndPurchaseBtls = items[11];
    final premiumOneEightyClosingBtls = items[12];
    final premiumThreeSeventyFiveClosingBtls = items[13];
    final premiumSevenFiftyClosingBtls = items[14];
    final premiumOneThousandClosingBtls = items[15];
    final premiumOneEightySalesBtls = items[16];
    final premiumThreeSeventyFiveSalesBtls = items[17];
    final premiumSevenFiftySalesBtls = items[18];
    final premiumOneThousandSalesBtls = items[19];
    final premiumOneEightyTotalValues = items[20];
    final premiumThreeSeventyFiveTotalValues = items[21];
    final premiumSevenFiftyTotalValues = items[22];
    final premiumOneThousandTotalValues = items[23];

    final List<List<int>> premiumLastRowDataList = [
      premiumOneEightyOpBtls,
      premiumOneEightyPurchaseBtls,
      premiumOneEightyOpeingAndPurchaseBtls,
      premiumOneEightyClosingBtls,
      premiumOneEightySalesBtls,
      premiumOneEightyTotalValues,

      premiumThreeSeventyFiveOpBtls,
      premiumThreeSeventyFivePurchaseBtls,
      premiumThreeSeventyFiveOpeingAndPurchaseBtls,
      premiumThreeSeventyFiveClosingBtls,
      premiumThreeSeventyFiveSalesBtls,
      premiumThreeSeventyFiveTotalValues,

      premiumSevenFiftyOpBtls,
      premiumSevenFiftyPurchaseBtls,
      premiumSevenFiftyOpeingAndPurchaseBtls,
      premiumSevenFiftyClosingBtls,
      premiumSevenFiftySalesBtls,
      premiumSevenFiftyTotalValues,

      premiumOneThousandOpBtls,
      premiumOneThousandPurchaseBtls,
      premiumOneThousandOpeingAndPurchaseBtls,
      premiumOneThousandClosingBtls,
      premiumOneThousandSalesBtls,
      premiumOneThousandTotalValues,
    ];

    int premiumOneEightyOpBtlsCount = 0;
    int premiumOneEightyPurchaseBtlsCount = 0;
    int premiumOneEightyOpeingAndPurchaseBtlsCount = 0;
    int premiumOneEightyClosingBtlsCount = 0;
    int premiumOneEightySalesBtlsCount = 0;
    int premiumOneEightyTotalValuesCount = 0;

    int premiumThreeSeventyFiveOpBtlsCount = 0;
    int premiumThreeSeventyFivePurchaseBtlsCount = 0;
    int premiumThreeSeventyFiveOpeingAndPurchaseBtlsCount = 0;
    int premiumThreeSeventyFiveClosingBtlsCount = 0;
    int premiumThreeSeventyFiveSalesBtlsCount = 0;
    int premiumThreeSeventyFiveTotalValuesCount = 0;

    int premiumSevenFiftyOpBtlsCount = 0;
    int premiumSevenFiftyPurchaseBtlsCount = 0;
    int premiumSevenFiftyOpeingAndPurchaseBtlsCount = 0;
    int premiumSevenFiftyClosingBtlsCount = 0;
    int premiumSevenFiftySalesBtlsCount = 0;
    int premiumSevenFiftyTotalValuesCount = 0;

    int premiumOneThousandOpBtlsCount = 0;
    int premiumOneThousandPurchaseBtlsCount = 0;
    int premiumOneThousandOpeingAndPurchaseBtlsCount = 0;
    int premiumOneThousandClosingBtlsCount = 0;
    int premiumOneThousandSalesBtlsCount = 0;
    int premiumOneThousandTotalValuesCount = 0;

    for (int i = 0; i < premiumLastRowDataList.length; i++) {
      for (int subList in premiumLastRowDataList[i]) {
        if (i == 0) {
          premiumOneEightyOpBtlsCount += subList;
        } else if (i == 1) {
          premiumOneEightyPurchaseBtlsCount += subList;
        } else if (i == 2) {
          premiumOneEightyOpeingAndPurchaseBtlsCount += subList;
        } else if (i == 3) {
          premiumOneEightyClosingBtlsCount += subList;
        } else if (i == 4) {
          premiumOneEightySalesBtlsCount += subList;
        } else if (i == 5) {
          premiumOneEightyTotalValuesCount += subList;
        } else if (i == 6) {
          premiumThreeSeventyFiveOpBtlsCount += subList;
        } else if (i == 7) {
          premiumThreeSeventyFivePurchaseBtlsCount += subList;
        } else if (i == 8) {
          premiumThreeSeventyFiveOpeingAndPurchaseBtlsCount += subList;
        } else if (i == 9) {
          premiumThreeSeventyFiveClosingBtlsCount += subList;
        } else if (i == 10) {
          premiumThreeSeventyFiveSalesBtlsCount += subList;
        } else if (i == 11) {
          premiumThreeSeventyFiveTotalValuesCount += subList;
        } else if (i == 12) {
          premiumSevenFiftyOpBtlsCount += subList;
        } else if (i == 13) {
          premiumSevenFiftyPurchaseBtlsCount += subList;
        } else if (i == 14) {
          premiumSevenFiftyOpeingAndPurchaseBtlsCount += subList;
        } else if (i == 15) {
          premiumSevenFiftyClosingBtlsCount += subList;
        } else if (i == 16) {
          premiumSevenFiftySalesBtlsCount += subList;
        } else if (i == 17) {
          premiumSevenFiftyTotalValuesCount += subList;
        } else if (i == 18) {
          premiumOneThousandOpBtlsCount += subList;
        } else if (i == 19) {
          premiumOneThousandPurchaseBtlsCount += subList;
        } else if (i == 20) {
          premiumOneThousandOpeingAndPurchaseBtlsCount += subList;
        } else if (i == 21) {
          premiumOneThousandClosingBtlsCount += subList;
        } else if (i == 22) {
          premiumOneThousandSalesBtlsCount += subList;
        } else if (i == 23) {
          premiumOneThousandTotalValuesCount += subList;
        }
      }
    }

    return [
      premiumOneEightyOpBtlsCount,
      premiumOneEightyPurchaseBtlsCount,
      premiumOneEightyOpeingAndPurchaseBtlsCount,
      premiumOneEightyClosingBtlsCount,
      premiumOneEightySalesBtlsCount,
      premiumOneEightyTotalValuesCount,
      premiumThreeSeventyFiveOpBtlsCount,
      premiumThreeSeventyFivePurchaseBtlsCount,
      premiumThreeSeventyFiveOpeingAndPurchaseBtlsCount,
      premiumThreeSeventyFiveClosingBtlsCount,
      premiumThreeSeventyFiveSalesBtlsCount,
      premiumThreeSeventyFiveTotalValuesCount,
      premiumSevenFiftyOpBtlsCount,
      premiumSevenFiftyPurchaseBtlsCount,
      premiumSevenFiftyOpeingAndPurchaseBtlsCount,
      premiumSevenFiftyClosingBtlsCount,
      premiumSevenFiftySalesBtlsCount,
      premiumSevenFiftyTotalValuesCount,
      premiumOneThousandOpBtlsCount,
      premiumOneThousandPurchaseBtlsCount,
      premiumOneThousandOpeingAndPurchaseBtlsCount,
      premiumOneThousandClosingBtlsCount,
      premiumOneThousandSalesBtlsCount,
      premiumOneThousandTotalValuesCount,
    ];
  }

  Future<List<List<dynamic>>> downloadPdf(
    bool isDailyStatement,
    DateTime lastDate,
  ) async {
    int shopId = 3810;
    bool isConnected = await InternetConnection().hasInternetAccess;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    List<String> dateList = await generatePassedDates(lastDate);
    String closingPdfFormat = await getPdfFormat(shopId);

    // final db = await databaseHelper.database;

    String currentDate;
    DateTime date = DateTime.now();

    if (lastDate != '') {
      currentDate = date.toIso8601String().substring(0, 10);
    } else {
      currentDate = lastDate.toIso8601String().substring(0, 10);
    }

    int currentMonthSales = 0;
    int monthSales = 0;
    int posMachineValuePerDay = 0;
    int posMonthlyCumulation = 0;

    int lengthOfHeading = 0;
    int lengthOfMediumHeading = 0;
    int lengthOfPremiumHeading = 0;
    int lengthOfBeerHeading = 0;
    int lengthOfOneThousandHeading = 0;

    String totalPrice = '';

    int ordOneEightyTotalReciptBtls = 0;
    int ordOneEightyTotalOpeningBtls = 0;
    int ordOneEightyTotalOpAndReciptBtls = 0;

    int ordThreeSeventyFiveTotalReciptBtls = 0;
    int ordThreeSeventyFiveTotalOpeningBtls = 0;
    int ordThreeSeventyFiveTotalOpAndReciptBtls = 0;

    int ordSevenFiftyTotalReciptBtls = 0;
    int ordSevenFiftyTotalOpeningBtls = 0;
    int ordSevenFiftyTotalOpAndReciptBtls = 0;

    int mdmOneEightyTotalReciptBtls = 0;
    int mdmOneEightyTotalOpeningBtls = 0;
    int mdmOneEightyTotalOpAndReciptBtls = 0;

    int mdmThreeSeventyFiveTotalReciptBtls = 0;
    int mdmThreeSeventyFiveTotalOpeningBtls = 0;
    int mdmThreeSeventyFiveTotalOpAndReciptBtls = 0;

    int mdmSevenFiftyTotalOpeningBtls = 0;
    int mdmSevenFiftyTotalReciptBtls = 0;
    int mdmSevenFiftyTotalOpAndReciptBtls = 0;

    int prmOneEightyTotalReciptBtls = 0;
    int prmOneEightyTotalOpeningBtls = 0;
    int prmOneEightyTotalOpAndReciptBtls = 0;

    int prmThreeSeventyFiveTotalReciptBtls = 0;
    int prmThreeSeventyFiveTotalOpeningBtls = 0;
    int prmThreeSeventyFiveTotalOpAndReciptBtls = 0;

    int prmSevenFiftyTotalOpeningBtls = 0;
    int prmSevenFiftyTotalReciptBtls = 0;
    int prmSevenFiftyTotalOpAndReciptBtls = 0;

    int thousandOpBtls = 0;
    int sevanFiftyOpBtls = 0;
    int threeSeventyFiveOpBtls = 0;
    int oneEightyOpBtls = 0;
    int sixFiftyOpBtls = 0;
    int fiveHundredOpBtls = 0;
    int threeTwentyFiveOpBtls = 0;

    int imflOpAmount = 0;
    int beerOpAmount = 0;
    int totalOpAmount = 0;

    int thousandRecptBtls = 0;
    int sevanFiftyRecptBtls = 0;
    int threeSeventyFiveRecptBtls = 0;
    int oneEightyRecptBtls = 0;
    int sixFiftyRecptBtlss = 0;
    int fiveHundredRecptBtls = 0;
    int threeTwentyFiveRecptBtls = 0;

    int imflRecptAmount = 0;
    int beerRecptAmount = 0;
    int totalRecptAmount = 0;

    int thousandTotalBtls = 0;
    int sevanFiftyTotalBtls = 0;
    int threeSeventyFiveTotalBtls = 0;
    int oneEightyTotalBtls = 0;
    int sixFiftyTotalBtls = 0;
    int fiveHundredTotalBtls = 0;
    int threeTwentyFiveTotalBtls = 0;
    int totalOpImflAmount = 0;

    int totalOpImflAnBeerAmount = 0;
    int TotalRecptAmount = 0;
    int totalAmount = 0;

    int totalImflOpWithRecptAmount = 0;
    int totalBeerOpWithRecptAmount = 0;

    List<List<String>> ordinaryHeadingList = [];
    List<List<String>> mediumHeadingList = [];
    List<List<String>> premiumHeadingList = [];
    List<List<String>> beerHeadingList = [];
    List<List<String>> beerDatas = [];

    List<List<String>> beerTrimmedBrandNameListOne = [];
    List<List<String>> beerDataListOne = [];
    List<List<String>> beerTrimmedBrandNameListTwo = [];
    List<List<String>> beerDataListTwo = [];
    List<List<String>> beerTrimmedBrandNameListThree = [];
    List<List<String>> beerDataListThree = [];

    List<List<String>> beerTrimmedBrandNameList = [];

    final removeDuplicate = <String>{};

    List<List<String>> ordinaryHeadingSizeList = [];
    List<List<String>> mediumHeadingSizeList = [];
    List<List<String>> premiumHeadingSizeList = [];
    List<List<String>> beerHeadingSizeList = [];

    List<List<String>> oneThousandHeadingSizeList = [];

    List<List<String>> ordinaryUniqueItems = [];
    List<List<String>> mediumUniqueItems = [];
    List<List<String>> premiumUniqueItems = [];
    List<List<String>> beerUniqueItems = [];

    List<int> lengthOfBeerSizes = [];

    List<List<String>> oneThousandUniqueItems = [];

    List<List<String>> ordinaryFinalUniqueItems = [];
    List<List<String>> mediumFinalUniqueItems = [];
    List<List<String>> premiumFinalUniqueItems = [];
    List<List<String>> beerFinalUniqueItems = [];

    List<List<String>> oneThousandFinalUniqueItems = [];

    List<List<String>> oneThousandHeadingList = [];

    List<List<String>> ordinaryOneEightyData = [];
    List<List<String>> ordinaryThreeSeventyData = [];
    List<List<String>> ordinarySevenFiftyData = [];

    List<List<String>> mediumOneEightyData = [];
    List<List<String>> mediumThreeSeventyData = [];
    List<List<String>> mediumSevenFiftyData = [];

    List<List<String>> premiumOneEightyData = [];
    List<List<String>> premiumThreeSeventyData = [];
    List<List<String>> premiumSevenFiftyData = [];

    List<List<String>> ordOneEighty = [];
    List<List<String>> ordThreeSeventyFive = [];
    List<List<String>> ordSevenFifty = [];

    List<List<String>> ordOneEightyLastRowData = [];
    List<List<String>> ordThreeSevenFiveLastRowData = [];
    List<List<String>> ordSevenFiftyLastRowData = [];

    List<int> ordinaryOneEightyndex = [];
    List<int> ordinaryThreeSeventyFiveIndex = [];
    List<int> ordinarySevenFiftyIndex = [];

    List<List<String>> mdmOneEighty = [];
    List<List<String>> mdmThreeSeventyFive = [];
    List<List<String>> mdmSevenFifty = [];

    List<List<String>> mdmOneEightyLastRowData = [];
    List<List<String>> mdmThreeSevenFiveLastRowData = [];
    List<List<String>> mdmSevenFiftyLastRowData = [];

    List<int> mediumOneEightyndex = [];
    List<int> mediumThreeSeventyFiveIndex = [];
    List<int> mediumSevenFiftyIndex = [];

    List<List<String>> prmOneEighty = [];
    List<List<String>> prmThreeSeventyFive = [];
    List<List<String>> prmSevenFifty = [];

    List<List<String>> prmOneEightyLastRowData = [];
    List<List<String>> prmThreeSevenFiveLastRowData = [];
    List<List<String>> prmSevenFiftyLastRowData = [];

    List<int> premiumOneEightyndex = [];
    List<int> premiumThreeSeventyFiveIndex = [];
    List<int> premiumSevenFiftyIndex = [];

    List<List<String>> beerThreeTwentyFive = [];
    List<List<String>> beerFiveHundredFive = [];
    List<List<String>> beerSixFiftyFive = [];

    List<List<String>> beerThreeTwentyFiveData = [];
    List<List<String>> beerFiveHundredFiveData = [];
    List<List<String>> beerSixFiftyFiveData = [];

    List<int> beerThreeTwentyFiveIndex = [];
    List<int> beerFiveHundredFiveIndex = [];
    List<int> beerSixFiftyFiveIndex = [];

    List<List<String>> opSummaryData = [];
    List<String> opSummary = [];
    List<String> recptSummary = [];
    List<String> totalSummary = [];
    List<String> salesSummary = ['SALES', '', '', '', '', '', '', '', '', ''];
    List<String> cbSummary = ['CB', '', '', '', '', '', '', '', '', ''];

    List<int> odinaryOneThousandIndex = [];
    List<int> mediumOneThousandIndex = [];
    List<int> premiumOneThousandIndex = [];

    List<List<String>> odinaryOneThousandData = [];
    List<List<String>> mediumOneThousandData = [];
    List<List<String>> premiumOneThousandData = [];

    List<List<String>> ordinaryOneThousand = [];
    List<List<String>> mediumOneThousand = [];
    List<List<String>> premiumOneThousand = [];

    Future<void> assignValueList(
      ordinaryOneEightyndex,
      List<List<String>> ordinaryOneEightyData,
      ordinaryThreeSeventyFiveIndex,
      List<List<String>> ordinaryThreeSeventyData,
      ordinarySevenFiftyIndex,
      List<List<String>> ordinarySevenFiftyData,
      mediumOneEightyndex,
      mediumOneEightyData,
      mediumThreeSeventyFiveIndex,
      mediumThreeSeventyData,
      mediumSevenFiftyIndex,
      mediumSevenFiftyData,
      premiumOneEightyndex,
      premiumOneEightyData,
      premiumThreeSeventyFiveIndex,
      premiumThreeSeventyData,
      premiumSevenFiftyIndex,
      premiumSevenFiftyData,
      beerThreeTwentyFiveIndex,
      beerThreeTwentyFiveData,
      beerFiveHundredFiveIndex,
      beerFiveHundredFiveData,
      beerSixFiftyFiveIndex,
      beerSixFiftyFiveData,
      odinaryOneThousandIndex,
      odinaryOneThousandData,
      mediumOneThousandIndex,
      mediumOneThousandData,
      premiumOneThousandIndex,
      premiumOneThousandData,
    ) async {
      debugPrint(
        'index  $ordinaryThreeSeventyFiveIndex  value $ordinaryThreeSeventyData length $lengthOfHeading',
      );
      debugPrint('ordinaryHeadingList77777 ${ordinaryHeadingList.length}');

      debugPrint('ordinaryOneEightyndex $ordinaryOneEightyndex');
      debugPrint(
        'mediumOneEightyndex $mediumOneEightyndex , mediumOneEightyData $mediumOneEightyData lengthOfMediumHeading $lengthOfMediumHeading',
      );

      debugPrint('premiumOneEightyndex ${premiumOneEightyndex.length}');
      debugPrint('premiumOneEightyData $premiumOneEightyData');
      debugPrint('premiumSevenFiftyIndex $premiumSevenFiftyIndex');
      debugPrint('premiumSevenFiftyData ${premiumSevenFiftyData}');

      final ordThreeSevenInitialVal = ['.', '0', '0', '0'];
      final ordOneEightyInitialVal = ['.', '0', '0', '0'];
      final ordSevenFiftyVal = ['.', '0', '0', '0'];

      final mdmOneEightyInitialVal = ['.', '0', '0', '0'];
      final mdmThreeSevenInitialVal = ['.', '0', '0', '0'];
      final mdmSevenFiftyInitialVal = ['.', '0', '0', '0'];

      final prmOneEightyInitialVal = ['.', '0', '0', '0'];
      final prmSevenFiftyInitialVal = ['.', '0', '0', '0'];

      final beerInitialVal = ['.', '0', '0', '0'];

      final oneThousandInitialVal = ['.', '0', '0', '0'];

      debugPrint(
        'prmOneEighty $prmOneEighty lengthOfPremiumHeading $lengthOfPremiumHeading',
      );
      debugPrint(
        'premiumThreeSeventyFiveIndex $premiumThreeSeventyFiveIndex lengthOfPremiumHeading $lengthOfPremiumHeading',
      );
      debugPrint('premiumThreeSeventyData $premiumThreeSeventyData');

      ordinaryOneThousand = List.generate(
        lengthOfOneThousandHeading,
        (index) => List.from(oneThousandInitialVal),
      );

      for (int i = 0; i < odinaryOneThousandIndex.length; i++) {
        int targetIndex = odinaryOneThousandIndex[i];

        if (targetIndex >= 0 && targetIndex < ordinaryOneThousand.length) {
          ordinaryOneThousand[targetIndex] = odinaryOneThousandData[i];
        } else {
          debugPrint(
            "WARNING: Index $targetIndex is out of bounds for ordThreeSeventyFive.",
          );
        }
      }

      mediumOneThousand = List.generate(
        lengthOfOneThousandHeading,
        (index) => List.from(oneThousandInitialVal),
      );

      for (int i = 0; i < mediumOneThousandIndex.length; i++) {
        int targetIndex = mediumOneThousandIndex[i];

        if (targetIndex >= 0 && targetIndex < mediumOneThousand.length) {
          mediumOneThousand[targetIndex] = mediumOneThousandData[i];
        } else {
          debugPrint(
            "WARNING: Index $targetIndex is out of bounds for ordThreeSeventyFive.",
          );
        }
      }

      premiumOneThousand = List.generate(
        lengthOfOneThousandHeading,
        (index) => List.from(oneThousandInitialVal),
      );

      for (int i = 0; i < premiumOneThousandIndex.length; i++) {
        int targetIndex = premiumOneThousandIndex[i];

        if (targetIndex >= 0 && targetIndex < premiumOneThousand.length) {
          premiumOneThousand[targetIndex] = premiumOneThousandData[i];
        } else {
          debugPrint(
            "WARNING: Index $targetIndex is out of bounds for ordThreeSeventyFive.",
          );
        }
      }

      beerThreeTwentyFive = List.generate(
        lengthOfBeerHeading,
        (index) => List.from(beerInitialVal),
      );

      for (int i = 0; i < beerThreeTwentyFiveIndex.length; i++) {
        int targetIndex = beerThreeTwentyFiveIndex[i];

        if (targetIndex >= 0 && targetIndex < beerThreeTwentyFive.length) {
          beerThreeTwentyFive[targetIndex] = beerThreeTwentyFiveData[i];
        } else {
          debugPrint(
            "WARNING: Index $targetIndex is out of bounds for ordThreeSeventyFive.",
          );
        }
      }

      beerFiveHundredFive = List.generate(
        lengthOfBeerHeading,
        (index) => List.from(beerInitialVal),
      );

      for (int i = 0; i < beerFiveHundredFiveIndex.length; i++) {
        int targetIndex = beerFiveHundredFiveIndex[i];

        if (targetIndex >= 0 && targetIndex < beerFiveHundredFive.length) {
          beerFiveHundredFive[targetIndex] = beerFiveHundredFiveData[i];
        } else {
          debugPrint(
            "WARNING: Index $targetIndex is out of bounds for ordThreeSeventyFive.",
          );
        }
      }

      beerSixFiftyFive = List.generate(
        lengthOfBeerHeading,
        (index) => List.from(beerInitialVal),
      );

      for (int i = 0; i < beerSixFiftyFiveIndex.length; i++) {
        int targetIndex = beerSixFiftyFiveIndex[i];

        if (targetIndex >= 0 && targetIndex < beerSixFiftyFive.length) {
          beerSixFiftyFive[targetIndex] = beerSixFiftyFiveData[i];
        } else {
          debugPrint(
            "WARNING: Index $targetIndex is out of bounds for ordThreeSeventyFive.",
          );
        }
      }

      debugPrint('vvvvvveee $prmOneEighty ggggg ${prmOneEighty.length}');
      debugPrint(
        'prmThreeSeventyFiveprmThreeSeventyFive $prmThreeSeventyFive hhh ${prmThreeSeventyFive}',
      );
      debugPrint(
        'prmSevenFiftyprmSevenFifty $prmSevenFifty hhh ${prmSevenFifty}',
      );

      prmOneEighty = List.generate(
        lengthOfPremiumHeading,
        (index) => List.from(prmOneEightyInitialVal),
      );

      for (int i = 0; i < premiumOneEightyndex.length; i++) {
        int targetIndex = premiumOneEightyndex[i];

        if (targetIndex >= 0 && targetIndex < prmOneEighty.length) {
          prmOneEighty[targetIndex] = premiumOneEightyData[i];
        } else {
          debugPrint(
            "WARNING: Index $targetIndex is out of bounds for ordThreeSeventyFive.",
          );
        }
      }

      prmThreeSeventyFive = List.generate(
        lengthOfPremiumHeading,
        (index) => List.from(prmOneEightyInitialVal),
      );

      for (int i = 0; i < premiumThreeSeventyFiveIndex.length; i++) {
        int targetIndex = premiumThreeSeventyFiveIndex[i];

        if (targetIndex >= 0 && targetIndex < prmThreeSeventyFive.length) {
          prmThreeSeventyFive[targetIndex] = premiumThreeSeventyData[i];
        } else {
          debugPrint(
            "WARNING: Index $targetIndex is out of bounds for ordThreeSeventyFive.",
          );
        }
      }

      prmSevenFifty = List.generate(
        lengthOfPremiumHeading,
        (index) => List.from(prmOneEightyInitialVal),
      );

      for (int i = 0; i < premiumSevenFiftyIndex.length; i++) {
        int targetIndex = premiumSevenFiftyIndex[i];

        if (targetIndex >= 0 && targetIndex < prmSevenFifty.length) {
          prmSevenFifty[targetIndex] = premiumSevenFiftyData[i];
        } else {
          debugPrint(
            "WARNING: Index $targetIndex is out of bounds for ordThreeSeventyFive.",
          );
        }
      }

      debugPrint(
        'ordOneEighty ${ordOneEighty.runtimeType} lengthOfHeading ${lengthOfHeading.runtimeType}',
      );
      ordOneEighty = List.generate(
        lengthOfHeading,
        (index) => List.from(ordOneEightyInitialVal),
      );

      for (int i = 0; i < ordinaryOneEightyndex.length; i++) {
        int targetIndex = ordinaryOneEightyndex[i];

        if (targetIndex >= 0 && targetIndex < ordOneEighty.length) {
          ordOneEighty[targetIndex] = ordinaryOneEightyData[i];
        } else {
          debugPrint(
            "WARNING: Index $targetIndex is out of bounds for ordThreeSeventyFive.",
          );
        }
      }

      ordThreeSeventyFive = List.generate(
        lengthOfHeading,
        (index) => List.from(ordThreeSevenInitialVal),
      );

      debugPrint('ordThreeSeventyFive $ordThreeSeventyFive');

      for (int i = 0; i < ordinaryThreeSeventyFiveIndex.length; i++) {
        int targetIndex = ordinaryThreeSeventyFiveIndex[i];

        if (targetIndex >= 0 && targetIndex < ordThreeSeventyFive.length) {
          ordThreeSeventyFive[targetIndex] = ordinaryThreeSeventyData[i];
        } else {
          debugPrint(
            "WARNING: Index $targetIndex is out of bounds for ordThreeSeventyFive.",
          );
        }
      }

      debugPrint('after adding value list $ordThreeSeventyFive');

      ordSevenFifty = List.generate(
        lengthOfHeading,
        (index) => List.from(ordSevenFiftyVal),
      );

      debugPrint('ordThreeSeventyFive $ordThreeSeventyFive');

      for (int i = 0; i < ordinarySevenFiftyIndex.length; i++) {
        int targetIndex = ordinarySevenFiftyIndex[i];

        if (targetIndex >= 0 && targetIndex < ordSevenFifty.length) {
          ordSevenFifty[targetIndex] = ordinarySevenFiftyData[i];
        } else {
          debugPrint(
            "WARNING: Index $targetIndex is out of bounds for ordThreeSeventyFive.",
          );
        }
      }

      mdmOneEighty = List.generate(
        lengthOfMediumHeading,
        (index) => List.from(mdmOneEightyInitialVal),
      );

      for (int i = 0; i < mediumOneEightyndex.length; i++) {
        int targetIndex = mediumOneEightyndex[i];

        if (targetIndex >= 0 && targetIndex < mdmOneEighty.length) {
          mdmOneEighty[targetIndex] = mediumOneEightyData[i];
        } else {
          debugPrint(
            "WARNING: Index $targetIndex is out of bounds for ordThreeSeventyFive.",
          );
        }
      }

      mdmThreeSeventyFive = List.generate(
        lengthOfMediumHeading,
        (index) => List.from(mdmThreeSevenInitialVal),
      );

      for (int i = 0; i < mediumThreeSeventyFiveIndex.length; i++) {
        int targetIndex = mediumThreeSeventyFiveIndex[i];

        if (targetIndex >= 0 && targetIndex < mdmThreeSeventyFive.length) {
          mdmThreeSeventyFive[targetIndex] = mediumThreeSeventyData[i];
        } else {
          debugPrint(
            "WARNING: Index $targetIndex is out of bounds for ordThreeSeventyFive.",
          );
        }
      }

      debugPrint('mdmSevenFifty lengthOfMediumHeading $lengthOfMediumHeading');
      mdmSevenFifty = List.generate(
        lengthOfMediumHeading,
        (index) => List.from(mdmSevenFiftyInitialVal),
      );

      for (int i = 0; i < mediumSevenFiftyIndex.length; i++) {
        int targetIndex = mediumSevenFiftyIndex[i];

        if (targetIndex >= 0 && targetIndex < mdmSevenFifty.length) {
          mdmSevenFifty[targetIndex] = mediumSevenFiftyData[i];
        } else {
          debugPrint(
            "WARNING: Index $targetIndex is out of bounds for ordThreeSeventyFive.",
          );
        }
      }
    }

    Future<List<List<String>>> sperateImflList(
      matchedInwardItem,
      matchedInwardData,
    ) async {
      debugPrint(
        'matchedInwardItemmatchedInwardItem333333333 $matchedInwardItem',
      );
      debugPrint(
        'matchedInwardDatamatchedInwardDatamatchedInwardData $matchedInwardData',
      );

      var productCode = matchedInwardItem[0];
      var brandN = matchedInwardItem[1].toUpperCase();
      var productSize = matchedInwardItem[2];
      var productPrice = matchedInwardItem[4];
      var opBottle = matchedInwardItem[5];

      var brandName = brandN.trim();

      debugPrint('brandNamebrandName $brandName');

      var inwardRetail = '0';
      var inwardPrice = '0';

      int opBtl = int.parse(opBottle);
      int? inwardBtl;
      int opWithPurchase = 0;

      if (matchedInwardData != null) {
        inwardRetail = matchedInwardData[0];
        inwardPrice = matchedInwardData[2];

        inwardBtl = int.parse(inwardRetail);

        if (matchedInwardData[1] == 'ORDINARY' ||
            matchedInwardData[1] == 'MEDIUM' ||
            matchedInwardData[1] == 'PREMIUM') {
          int btlInwardPrice = inwardBtl * int.parse(inwardPrice);
          imflRecptAmount += btlInwardPrice;
          debugPrint('imflRecptAmount $imflRecptAmount');
        } else {
          int btlInwardPrice = inwardBtl * int.parse(inwardPrice);
          beerRecptAmount += btlInwardPrice;
          debugPrint('beerRecptAmount $beerRecptAmount');
        }
      }

      inwardBtl = int.parse(inwardRetail);
      opWithPurchase = opBtl + inwardBtl;

      debugPrint('opBtl555 $opBtl');
      debugPrint('inwardBtl555 $inwardBtl');
      debugPrint('opWithPurchase55 $opWithPurchase');

      int price = int.parse(productPrice);
      debugPrint('priceprice $price');
      debugPrint('opBtl $opBtl');

      if (matchedInwardItem[3] == 'ORDINARY' ||
          matchedInwardItem[3] == 'MEDIUM' ||
          matchedInwardItem[3] == 'PREMIUM') {
        int btlOpPrice = opBtl * price;

        imflOpAmount += btlOpPrice;
        debugPrint('imflOpAmount $imflOpAmount');
      } else if (matchedInwardItem[3] == 'BEER') {
        int btlOpPrice = opBtl * price;
        beerOpAmount += btlOpPrice;
        debugPrint('beerOpAmount3333 $beerOpAmount');
      }

      totalOpImflAnBeerAmount = imflOpAmount + beerOpAmount;
      TotalRecptAmount = imflRecptAmount + beerRecptAmount;

      totalAmount = totalOpImflAnBeerAmount + TotalRecptAmount;

      totalImflOpWithRecptAmount = imflOpAmount + imflRecptAmount;
      totalBeerOpWithRecptAmount = beerOpAmount + beerRecptAmount;

      debugPrint('totalOpImflAnBeerAmount $totalOpImflAnBeerAmount');
      debugPrint('TotalRecptAmount $TotalRecptAmount');
      debugPrint('totalAmount $totalAmount');
      debugPrint('totalOpAmount $totalOpAmount');

      if (productSize == '1000 ml') {
        thousandOpBtls += opBtl;
        thousandRecptBtls += inwardBtl;
        thousandTotalBtls += opWithPurchase;
      }

      if (productSize == '750 ml') {
        sevanFiftyOpBtls += opBtl;
        sevanFiftyRecptBtls += inwardBtl;
        sevanFiftyTotalBtls += opWithPurchase;
      }

      if (productSize == '375 ml') {
        threeSeventyFiveOpBtls += opBtl;
        threeSeventyFiveRecptBtls += inwardBtl;
        threeSeventyFiveTotalBtls += opWithPurchase;
      }

      if (productSize == '180 ml') {
        oneEightyOpBtls += opBtl;
        oneEightyRecptBtls += inwardBtl;
        oneEightyTotalBtls += opWithPurchase;
      }

      if (productSize == '650 ml') {
        sixFiftyOpBtls += opBtl;
        sixFiftyRecptBtlss += inwardBtl;
        sixFiftyTotalBtls += opWithPurchase;
      }

      if (productSize == '500 ml') {
        fiveHundredOpBtls += opBtl;
        fiveHundredRecptBtls += inwardBtl;
        fiveHundredTotalBtls += opWithPurchase;
      }

      if (productSize == '325 ml') {
        threeTwentyFiveOpBtls += opBtl;
        threeTwentyFiveRecptBtls += inwardBtl;
        threeTwentyFiveTotalBtls += opWithPurchase;
      }

      int FiveAndThreeOpBtls = fiveHundredOpBtls + threeTwentyFiveOpBtls;
      int FiveAndThreeRcptBtls =
          fiveHundredRecptBtls + threeTwentyFiveRecptBtls;
      int FiveAndThreeTotalBtls =
          fiveHundredTotalBtls + threeTwentyFiveTotalBtls;

      debugPrint(
        'sevanFiftyOpBtls $sevanFiftyOpBtls, threeSeventyFiveOpBtls $threeSeventyFiveOpBtls',
      );
      debugPrint(
        'sevanFiftyRecptBtls $sevanFiftyRecptBtls, totalOpImflAmount $totalOpImflAmount',
      );
      debugPrint(
        'sevanFiftyTotalBtls $sevanFiftyTotalBtls threeSeventyFiveTotalBtls $threeSeventyFiveTotalBtls',
      );

      opSummary = [
        'OB',
        thousandOpBtls.toString(),
        sevanFiftyOpBtls.toString(),
        threeSeventyFiveOpBtls.toString(),
        oneEightyOpBtls.toString(),
        sixFiftyOpBtls.toString(),
        FiveAndThreeOpBtls.toString(),
        imflOpAmount.toString(),
        beerOpAmount.toString(),
        totalOpImflAnBeerAmount.toString(),
      ];
      recptSummary = [
        'RECIEPT',
        thousandRecptBtls.toString(),
        sevanFiftyRecptBtls.toString(),
        threeSeventyFiveRecptBtls.toString(),
        oneEightyRecptBtls.toString(),
        sixFiftyRecptBtlss.toString(),
        FiveAndThreeRcptBtls.toString(),
        imflRecptAmount.toString(),
        beerRecptAmount.toString(),
        TotalRecptAmount.toString(),
      ];

      totalSummary = [
        'TOTAL',
        thousandTotalBtls.toString(),
        sevanFiftyTotalBtls.toString(),
        threeSeventyFiveTotalBtls.toString(),
        oneEightyTotalBtls.toString(),
        sixFiftyTotalBtls.toString(),
        FiveAndThreeTotalBtls.toString(),
        totalImflOpWithRecptAmount.toString(),
        totalBeerOpWithRecptAmount.toString(),
        totalAmount.toString(),
      ];

      opSummaryData = [
        opSummary,
        recptSummary,
        totalSummary,
        salesSummary,
        cbSummary,
      ];

      debugPrint('opSummaryData $opSummaryData');

      String? shortedBrand;

      String? isUppercase(b) {
        if (b.toUpperCase() == b && b.length >= 16) {
          shortedBrand = b.substring(0, 16);
        } else {
          if (b.length >= 20) {
            shortedBrand = b.substring(0, 20);
          } else {
            shortedBrand = b;
          }
        }

        return shortedBrand;
      }

      brandf(listData, comparisionData) {
        final List<List<String>> result = [];
        final Set<int> indexesToRemove = {};
        final UniqueItems = <List<String>>[];

        for (final item in comparisionData) {
          final id = item[0];
          final size = item[2];
          final brand = item[1].split(' ')[0];

          debugPrint('brandbrand $brand');
          debugPrint('itemitem $item');
          if (!indexesToRemove.contains(brand)) {
            UniqueItems.add(item);

            indexesToRemove.add(int.parse(id));
          }
        }

        debugPrint('UniqueItemsUniqueItems $UniqueItems');
        debugPrint('indexesToRemoveindexesToRemove $indexesToRemove');
        debugPrint('resultresult $result');
      }

      List<List<List<String>>> filterBrands(
        listData,
        comparisionData,
        isThousand,
      ) {
        debugPrint('listData333333 $listData');
        debugPrint('comparisionData444 $comparisionData');
        bool isDifferentBrand = false;
        final finalUniqueBrand = <List<String>>[];
        final finalUniqueBrandWithSize = <List<String>>[];
        final checkBrands = [];
        final checkIds = <String>{};

        List<int> uniqueIndice = [];
        List<String> repeatedBrandIds = [];
        List<String> checkIdsList = [];
        List<String> compainedIdList = [];
        List<String> existBrandIds = [];

        for (final item in comparisionData) {
          final brandId = item[0];
          final brand = item[1];
          final v = isUppercase(item[1]);
          List<int> matchedIndices = [];

          for (int i = 0; i < checkBrands.length; i++) {
            if (checkBrands[i] == brand) {
              matchedIndices.add(i);
            }
          }

          List<String> newItems = [brandId, v!];

          if (checkBrands.contains(brand)) {
            uniqueIndice = matchedIndices.toSet().toList();
            checkIdsList = checkIds.toList();
            debugPrint('checkIdsList222 $checkIdsList');

            existBrandIds = uniqueIndice
                .map((index) => checkIdsList[index])
                .toList();
            debugPrint('result3333 $existBrandIds');

            List<List> groupedProducts = [];
            List<dynamic> tempGroup = [];

            for (int i = 0; i < existBrandIds.length; i++) {
              debugPrint(
                'existBrandIds[i] -${existBrandIds[i]}  brandId - $brandId',
              );
              if ((int.parse(existBrandIds[i]) - int.parse(brandId)).abs() <=
                  2) {
                debugPrint('product contains <= 2 difference');
                isDifferentBrand = false;
                break;
              } else {
                debugPrint('product contains > 2 difference======');
                isDifferentBrand = true;
                tempGroup.add(existBrandIds[i]);
              }
            }

            groupedProducts.add(tempGroup);

            debugPrint('isDifferentBrand $isDifferentBrand');
            debugPrint('groupedProducts $groupedProducts');
            debugPrint('tempGroup $tempGroup');

            repeatedBrandIds.add(brandId);

            compainedIdList = existBrandIds + repeatedBrandIds;

            debugPrint('bf sort compainedIdList $compainedIdList ');
            compainedIdList.sort();
            debugPrint('af sort compainedIdList ${compainedIdList}');
            debugPrint('matchedIndices $matchedIndices');
            debugPrint('isDifferentBrand222222 $isDifferentBrand');
            if (isDifferentBrand == true) {
              finalUniqueBrandWithSize.add(item);
              finalUniqueBrand.add(newItems);
              checkBrands.add(brand);
              checkIds.add(brandId);
            }
            debugPrint(
              'finalUniqueBrandWithSize.add(item); $finalUniqueBrandWithSize',
            );
          } else {
            checkIdsList = checkIds.toList();
            debugPrint('checkIdsListcheckIdsList $checkIdsList');
            checkBrands.add(brand);
            checkIds.add(brandId);
            finalUniqueBrand.add(newItems);
            finalUniqueBrandWithSize.add(item);
          }
        }

        debugPrint('compainedIdList $compainedIdList');
        debugPrint('repeatedBrandIds $repeatedBrandIds');
        debugPrint('uniqueIndice $uniqueIndice');
        debugPrint('finalUniqueBrandWithSize $finalUniqueBrandWithSize');
        debugPrint('checkBrands ${checkBrands}');
        debugPrint('checkIds $checkIds');
        debugPrint('checkIdsList $checkIdsList');
        debugPrint('finalUniqueBrand $finalUniqueBrand');
        return [finalUniqueBrandWithSize, finalUniqueBrand];
      }

      List<List<List<String>>> filterBrand(
        listData,
        comparisionData,
        isThousand,
      ) {
        final UniqueItems = <List<String>>[];
        final seenBrands = <String>{};
        final finalBrand = <List<String>>[];
        List<String> newItems = [];
        final seenBrandData = <String>{};
        List<String> finalSeenBrand = [];

        debugPrint('comparisionData $comparisionData');
        for (final item in comparisionData) {
          debugPrint('branddd nameee ${item[1]}');
          final brand = item[1];
          final brandId = item[0];
          final v = isUppercase(item[1]);

          debugPrint('vvvvvv $v');

          newItems = [item[0], v!];
          finalSeenBrand = [v!, item[2]];

          String finalSeenBrandString = finalSeenBrand.join('-');

          debugPrint('finalSeenBrandString $finalSeenBrandString');

          debugPrint('brandbrand $brand');
          debugPrint('itemitem $item');
          debugPrint('brandId $brandId');
          if (!seenBrands.contains(brand)) {
            UniqueItems.add(item);
            finalBrand.add(newItems);
            seenBrands.add(brand);
            seenBrandData.add(finalSeenBrandString);
          }
        }

        debugPrint('seenBrands $seenBrands');
        debugPrint('UniqueItems $UniqueItems');
        debugPrint('finalBrand $finalBrand');
        debugPrint('seenBrandData $seenBrandData');

        return [UniqueItems, finalBrand];
      }

      List<String> headingList = [];

      List<String> headingSizeList = [];

      headingList = [productCode, brandName];

      headingSizeList = [productCode, brandName, productSize];

      List<String> dataList = [
        productPrice,
        opBottle,
        inwardRetail,
        opWithPurchase.toString(),
      ];

      bool brandIndexCheck(item) {
        bool? condition;
        int brandId = int.parse(item[0]);

        if (item[2] == '180 ml') {
          condition =
              (brandId.toString() == productCode && item[1] == brandName) ||
              ((brandId - 1).toString() == productCode &&
                  item[1] == brandName) ||
              ((brandId - 2).toString() == productCode && item[1] == brandName);
        } else if (item[2] == '375 ml') {
          condition =
              (brandId.toString() == productCode && item[1] == brandName) ||
              ((brandId - 1).toString() == productCode &&
                  item[1] == brandName) ||
              ((brandId + 1).toString() == productCode && item[1] == brandName);
        } else if (item[2] == "750 ml") {
          condition =
              (brandId.toString() == productCode && item[1] == brandName) ||
              ((brandId + 1).toString() == productCode &&
                  item[1] == brandName) ||
              ((brandId + 2).toString() == productCode && item[1] == brandName);
        } else {
          condition =
              (brandId.toString() == productCode && item[1] == brandName);
        }

        return condition;
      }

      if (matchedInwardItem![3] == 'ORDINARY' && productSize != '1000 ml') {
        ordinaryHeadingList.add(headingList!);
        debugPrint('ordinaryHeadingList3333 $ordinaryHeadingList');
        ordinaryHeadingSizeList.add(headingSizeList);

        lengthOfHeading = ordinaryHeadingList.length;

        brandf(ordinaryHeadingList, ordinaryHeadingSizeList);

        final f = filterBrand(
          ordinaryHeadingList,
          ordinaryHeadingSizeList,
          false,
        );

        final g = filterBrands(
          ordinaryHeadingList,
          ordinaryHeadingSizeList,
          false,
        );

        ordinaryUniqueItems = g[0];
        ordinaryFinalUniqueItems = g[1];
        debugPrint('length of the ordinaryHeadingList $lengthOfHeading');

        debugPrint('inital ordinaryOneEightyData ${ordinaryOneEightyData}');

        if (productCode == '1238') {
          debugPrint('product size $productSize, brand name  $brandName');
        }
        if (productCode == '1285') {
          debugPrint(
            'product size55555 $productSize, brand name5555  $brandName',
          );
        }

        if (productSize == '180 ml') {
          final desiredItemIndex = ordinaryUniqueItems.indexWhere(
            (item) => brandIndexCheck(item),
          );

          debugPrint('desiredItemIndex $desiredItemIndex ');

          debugPrint('new list $ordinaryOneEightyData');

          ordOneEightyTotalReciptBtls += int.parse(inwardRetail);
          ordOneEightyTotalOpeningBtls += opBtl;
          ordOneEightyTotalOpAndReciptBtls += opWithPurchase;

          ordOneEightyLastRowData = [
            [
              totalPrice,
              ordOneEightyTotalOpeningBtls.toString(),
              ordOneEightyTotalReciptBtls.toString(),
              ordOneEightyTotalOpAndReciptBtls.toString(),
            ],
          ];

          debugPrint(
            'ordOneEightyTotalReciptBtls $ordOneEightyTotalReciptBtls',
          );
          debugPrint('ordOneEightyLastRowData $ordOneEightyLastRowData');
          ordinaryOneEightyndex.add(desiredItemIndex);
          ordinaryOneEightyData.add(dataList);
          debugPrint('wwwwwwwwww $ordinaryOneEightyData');
        }
        if (productSize == '375 ml') {
          debugPrint('productCode $productCode');
          debugPrint('brandName11111 $brandName');
          debugPrint('productSize $productSize');
          debugPrint('productPrice $productPrice');
          debugPrint('opBottle $opBottle');

          debugPrint(
            'ordinaryThreeSeventyData++++ ${ordinaryThreeSeventyData.length}',
          );

          final desiredItemIndex = ordinaryUniqueItems.indexWhere(
            (item) => brandIndexCheck(item),
          );

          ordThreeSeventyFiveTotalReciptBtls += int.parse(inwardRetail);
          ordThreeSeventyFiveTotalOpeningBtls += opBtl;
          ordThreeSeventyFiveTotalOpAndReciptBtls += opWithPurchase;

          ordThreeSevenFiveLastRowData = [
            [
              totalPrice,
              ordThreeSeventyFiveTotalOpeningBtls.toString(),
              ordThreeSeventyFiveTotalReciptBtls.toString(),
              ordThreeSeventyFiveTotalOpAndReciptBtls.toString(),
            ],
          ];

          debugPrint(
            'ordThreeSeventyFiveTotalReciptBtls $ordThreeSeventyFiveTotalReciptBtls',
          );
          debugPrint(
            'ordThreeSeventyFiveTotalOpeningBtls $ordThreeSeventyFiveTotalOpeningBtls',
          );
          debugPrint(
            'ordThreeSeventyFiveTotalOpAndReciptBtls $ordThreeSeventyFiveTotalOpAndReciptBtls',
          );

          ordinaryThreeSeventyFiveIndex.add(desiredItemIndex);
          ordinaryThreeSeventyData.add(dataList);
          debugPrint('tttttttttt $ordinaryThreeSeventyData');
          debugPrint('375 index $ordinaryThreeSeventyFiveIndex');
        }

        if (productSize == '750 ml') {
          final desiredItemIndex = ordinaryUniqueItems.indexWhere(
            (item) => brandIndexCheck(item),
          );

          ordSevenFiftyTotalReciptBtls += int.parse(inwardRetail);
          ordSevenFiftyTotalOpeningBtls += opBtl;
          ordSevenFiftyTotalOpAndReciptBtls += opWithPurchase;

          ordSevenFiftyLastRowData = [
            [
              totalPrice,
              ordSevenFiftyTotalReciptBtls.toString(),
              ordSevenFiftyTotalOpeningBtls.toString(),
              ordSevenFiftyTotalOpAndReciptBtls.toString(),
            ],
          ];

          ordinarySevenFiftyIndex.add(desiredItemIndex);
          ordinarySevenFiftyData.add(dataList);
        }
      }

      if (matchedInwardItem![3] == 'MEDIUM' && productSize != '1000 ml') {
        mediumHeadingList.add(headingList!);

        mediumHeadingSizeList.add(headingSizeList);

        lengthOfMediumHeading = mediumHeadingList.length;

        final g = filterBrands(mediumHeadingList, mediumHeadingSizeList, false);

        mediumUniqueItems = g[0];
        mediumFinalUniqueItems = g[1];

        debugPrint('lengthOfMediumHeading $lengthOfMediumHeading');

        if (productSize == '180 ml') {
          debugPrint('mediumUniqueItems 180 $mediumUniqueItems');
          final desiredItemIndex = mediumUniqueItems.indexWhere(
            (item) => brandIndexCheck(item),
          );

          debugPrint('(item[0] == $productCode && item[1] == $brandName) 180');

          debugPrint('desiredItemIndex $desiredItemIndex');

          mdmOneEightyTotalReciptBtls += int.parse(inwardRetail);
          mdmOneEightyTotalOpeningBtls += opBtl;
          mdmOneEightyTotalOpAndReciptBtls += opWithPurchase;

          mdmOneEightyLastRowData = [
            [
              totalPrice,
              mdmOneEightyTotalOpeningBtls.toString(),
              mdmOneEightyTotalReciptBtls.toString(),
              mdmOneEightyTotalOpAndReciptBtls.toString(),
            ],
          ];

          debugPrint(
            'mdmOneEightyTotalOpAndReciptBtls $mdmOneEightyTotalOpAndReciptBtls',
          );
          debugPrint('mdmOneEightyLastRowData $mdmOneEightyLastRowData');
          mediumOneEightyndex.add(desiredItemIndex);
          mediumOneEightyData.add(dataList);
          debugPrint('dataList333 $dataList');
          debugPrint('mediumOneEightyndex $mediumOneEightyndex');
          debugPrint('mediumOneEightyData $mediumOneEightyData');
        }

        if (productSize == '375 ml') {
          debugPrint('mediumUniqueItems 375 $mediumUniqueItems');

          final desiredItemIndex = mediumUniqueItems.indexWhere(
            (item) => brandIndexCheck(item),
          );

          debugPrint('(item[0] == $productCode && item[1] == $brandName)  375');

          debugPrint('desiredItemIndex 375  $desiredItemIndex');

          mdmThreeSeventyFiveTotalReciptBtls += int.parse(inwardRetail);
          mdmThreeSeventyFiveTotalOpeningBtls += opBtl;
          mdmThreeSeventyFiveTotalOpAndReciptBtls += opWithPurchase;

          mdmThreeSevenFiveLastRowData = [
            [
              totalPrice,
              mdmThreeSeventyFiveTotalOpeningBtls.toString(),
              mdmThreeSeventyFiveTotalReciptBtls.toString(),
              mdmThreeSeventyFiveTotalOpAndReciptBtls.toString(),
            ],
          ];

          debugPrint(
            'mdmThreeSeventyFiveTotalOpAndReciptBtls $mdmThreeSeventyFiveTotalOpAndReciptBtls',
          );
          debugPrint(
            'mdmThreeSevenFiveLastRowData $mdmThreeSevenFiveLastRowData',
          );
          mediumThreeSeventyFiveIndex.add(desiredItemIndex);
          mediumThreeSeventyData.add(dataList);
          debugPrint('mdm 375 data $dataList');
          debugPrint(
            'mediumThreeSeventyFiveIndex $mediumThreeSeventyFiveIndex',
          );
          debugPrint('wwwwwwwwww $mediumThreeSeventyData');
        }

        if (productSize == '750 ml') {
          debugPrint('mediumUniqueItems 750 $mediumUniqueItems');
          final desiredItemIndex = mediumUniqueItems.indexWhere(
            (item) => brandIndexCheck(item),
          );

          debugPrint('desiredItemIndex 750 $desiredItemIndex ');
          debugPrint('(item[0] == $productCode && item[1] == $brandName) 750');

          mdmSevenFiftyTotalOpeningBtls += opBtl;
          mdmSevenFiftyTotalReciptBtls += int.parse(inwardRetail);
          mdmSevenFiftyTotalOpAndReciptBtls += opWithPurchase;

          debugPrint(
            'mdmSevenFiftyTotalOpeningBtls $mdmSevenFiftyTotalOpeningBtls',
          );

          debugPrint(
            'mdmSevenFiftyTotalReciptBtls $mdmSevenFiftyTotalReciptBtls',
          );

          debugPrint(
            'mdmSevenFiftyTotalOpAndReciptBtls $mdmSevenFiftyTotalOpAndReciptBtls',
          );

          mdmSevenFiftyLastRowData = [
            [
              totalPrice ?? '',
              mdmSevenFiftyTotalOpeningBtls.toString() ?? '0',
              mdmSevenFiftyTotalReciptBtls.toString(),
              mdmSevenFiftyTotalOpAndReciptBtls.toString(),
            ],
          ];

          debugPrint(
            'mdmSevenFiftyTotalOpAndReciptBtls $mdmSevenFiftyTotalOpAndReciptBtls',
          );
          debugPrint('mdmSevenFiftyLastRowData $mdmSevenFiftyLastRowData');
          mediumSevenFiftyIndex.add(desiredItemIndex);
          mediumSevenFiftyData.add(dataList);
          debugPrint('mediumSevenFiftyIndex $mediumSevenFiftyIndex');
          debugPrint('mdm 750 data $dataList');
          debugPrint('wwwwwwwwww $mediumSevenFiftyData');
        }
      }

      if (matchedInwardItem![3] == 'PREMIUM' && productSize != '1000 ml') {
        premiumHeadingList.add(headingList!);

        lengthOfPremiumHeading = premiumHeadingList.length;

        premiumHeadingSizeList.add(headingSizeList);

        final g = filterBrands(
          premiumHeadingList,
          premiumHeadingSizeList,
          false,
        );

        premiumUniqueItems = g[0];
        premiumFinalUniqueItems = g[1];

        if (productSize == '180 ml') {
          final desiredItemIndex = premiumUniqueItems.indexWhere(
            (item) => brandIndexCheck(item),
          );

          debugPrint('desiredItemIndex $desiredItemIndex ');

          prmOneEightyTotalReciptBtls += int.parse(inwardRetail);
          prmOneEightyTotalOpeningBtls += opBtl;
          prmOneEightyTotalOpAndReciptBtls += opWithPurchase;

          prmOneEightyLastRowData = [
            [
              totalPrice,
              prmOneEightyTotalReciptBtls.toString(),
              prmOneEightyTotalOpeningBtls.toString(),
              prmOneEightyTotalOpAndReciptBtls.toString(),
            ],
          ];

          debugPrint(
            'prmOneEightyTotalOpAndReciptBtls $prmOneEightyTotalOpAndReciptBtls',
          );
          debugPrint('prmOneEightyLastRowData $prmOneEightyLastRowData');
          premiumOneEightyndex.add(desiredItemIndex);
          premiumOneEightyData.add(dataList);
          debugPrint('wwwwwwwwww $premiumOneEightyData');
        }

        if (productSize == '375 ml') {
          final desiredItemIndex = premiumUniqueItems.indexWhere(
            (item) => brandIndexCheck(item),
          );

          debugPrint('desiredItemIndex $desiredItemIndex ');

          premiumThreeSeventyFiveIndex.add(desiredItemIndex);
          premiumThreeSeventyData.add(dataList);
          debugPrint('wwwwwwwwww $premiumThreeSeventyData');
        }

        if (productSize == '750 ml') {
          final desiredItemIndex = premiumUniqueItems.indexWhere(
            (item) => brandIndexCheck(item),
          );

          debugPrint('desiredItemIndex $desiredItemIndex ');

          premiumSevenFiftyIndex.add(desiredItemIndex);
          premiumSevenFiftyData.add(dataList);
          debugPrint('wwwwwwwwww $premiumSevenFiftyData');
        }
      }

      if (productSize == '1000 ml') {
        oneThousandHeadingList.add(headingList!);

        oneThousandHeadingSizeList.add(headingSizeList);

        lengthOfOneThousandHeading = oneThousandHeadingList.length;

        final f = filterBrands(
          oneThousandHeadingList,
          oneThousandHeadingSizeList,
          true,
        );

        oneThousandUniqueItems = f[0];
        oneThousandFinalUniqueItems = f[1];

        if (matchedInwardItem[3] == 'ORDINARY') {
          final desiredItemIndex = oneThousandUniqueItems.indexWhere(
            (item) => brandIndexCheck(item),
          );

          debugPrint('desiredItemIndex $desiredItemIndex ');

          odinaryOneThousandIndex.add(desiredItemIndex);
          odinaryOneThousandData.add(dataList);
          debugPrint('wwwwwwwwww $odinaryOneThousandData');
        }

        if (matchedInwardItem[3] == 'MEDIUM') {
          final desiredItemIndex = oneThousandUniqueItems.indexWhere(
            (item) => brandIndexCheck(item),
          );

          debugPrint('desiredItemIndex $desiredItemIndex ');

          mediumOneThousandIndex.add(desiredItemIndex);
          mediumOneThousandData.add(dataList);
          debugPrint('wwwwwwwwww $mediumOneThousandData');
        }

        if (matchedInwardItem[3] == 'PREMIUM') {
          final desiredItemIndex = oneThousandUniqueItems.indexWhere(
            (item) => brandIndexCheck(item),
          );

          debugPrint('desiredItemIndex $desiredItemIndex ');

          premiumOneThousandIndex.add(desiredItemIndex);
          premiumOneThousandData.add(dataList);
          debugPrint('wwwwwwwwww $premiumOneThousandData');
        }
      }

      if (matchedInwardItem![3] == 'BEER') {
        debugPrint('productCode11 $productCode');
        debugPrint(
          'brandName $brandName, brandName length ${brandName.length} ',
        );

        List<String> beerHeadThreeTwentyFive = ['0', '0', '325 ml', '0'];
        List<String> beerHeadFiveHundred = ['0', '0', '500 ml', '0'];
        List<String> beerHeadSixFifty = ['0', '0', '650 ml', '0'];

        beerHeadingList.add(headingList!);
        lengthOfBeerHeading = beerHeadingList.length;

        debugPrint('initital beerHeadingList  $beerHeadingList');

        beerHeadingSizeList.add(headingSizeList);

        for (final item in beerHeadingList) {
          final trimmedBrandName = isUppercase(item[1]);
          List<String> newItems = [item[0], trimmedBrandName!];

          if (!removeDuplicate.contains(item[0])) {
            if (productSize == '325 ml') {
              beerTrimmedBrandNameListOne.add(newItems);
              beerDataListOne.add(dataList);
            }
            if (productSize == '500 ml') {
              beerTrimmedBrandNameListTwo.add(newItems);
              beerDataListTwo.add(dataList);
            }

            if (productSize == '650 ml') {
              beerTrimmedBrandNameListThree.add(newItems);
              beerDataListThree.add(dataList);
            }

            removeDuplicate.add(item[0]);
          }
        }

        final f = filterBrands(beerHeadingList, beerHeadingSizeList, true);

        beerUniqueItems = f[0];
        beerFinalUniqueItems = f[1];

        debugPrint('beerUniqueItems $beerUniqueItems');

        if (productSize == '325 ml') {
          final desiredItemIndex = beerUniqueItems.indexWhere(
            (item) => brandIndexCheck(item),
          );

          debugPrint('desiredItemIndex beer  $desiredItemIndex ');
          debugPrint('beer dataList 325 ml $dataList');

          beerThreeTwentyFiveIndex.add(desiredItemIndex);
          beerThreeTwentyFiveData.add(dataList);

          debugPrint('beerThreeTwentyFiveIndex beer $beerThreeTwentyFiveIndex');
          debugPrint('beerThreeTwentyFiveData beer $beerThreeTwentyFiveData');
        }

        if (productSize == '500 ml') {
          final desiredItemIndex = beerUniqueItems.indexWhere(
            (item) => brandIndexCheck(item),
          );

          debugPrint('500 ml brandName $brandName');
          debugPrint('500 ml desiredItemIndex $desiredItemIndex');
          debugPrint('beerHeadingList datas inside 500 ml $beerHeadingList');
          debugPrint('beer dataList 500 ml $dataList');

          beerFiveHundredFiveIndex.add(desiredItemIndex);
          beerFiveHundredFiveData.add(dataList);
        }

        if (productSize == '650 ml') {
          final desiredItemIndex = beerUniqueItems.indexWhere(
            (item) => brandIndexCheck(item),
          );
          if (desiredItemIndex != -1) {
            debugPrint('item[1] ${beerUniqueItems[desiredItemIndex][1]}');
          } else {
            debugPrint("Brand '$brandName' not found in the list.");
          }

          debugPrint('650 ml brandName $brandName');
          debugPrint('650 ml desiredItemIndex $desiredItemIndex');
          debugPrint('beerHeadingList datas inside 650 ml $beerHeadingList');
          debugPrint('beer dataList 650 ml $dataList');

          beerSixFiftyFiveIndex.add(desiredItemIndex);
          beerSixFiftyFiveData.add(dataList);
        }

        debugPrint('beerHeadingList datas $beerUniqueItems');

        debugPrint('beerDatasrrrrrrrr $beerDatas');
        debugPrint('beerFiveHundredFiveData555555 $beerFiveHundredFiveData');
        debugPrint(
          'beerSixFiftyFiveDatabeerSixFiftyFiveData $beerSixFiftyFiveData',
        );
        lengthOfBeerSizes = [
          beerThreeTwentyFiveData.length,
          beerFiveHundredFiveData.length,
          beerSixFiftyFiveData.length,
        ];

        debugPrint('lengthOfBeerSizes $lengthOfBeerSizes');
      }

      debugPrint('ordinaryHeadingList $ordinaryHeadingList');
      debugPrint('ordinaryHeadingSizeList $ordinaryHeadingSizeList');
      debugPrint('mediumHeadingList $mediumHeadingList');
      debugPrint('premiumHeadingList ${premiumHeadingList.length}');
      debugPrint('ordinaryOneEightyData $ordinaryOneEightyData');
      debugPrint('ordinaryThreeSeventyData $ordinaryThreeSeventyData');

      await assignValueList(
        ordinaryOneEightyndex,
        ordinaryOneEightyData,
        ordinaryThreeSeventyFiveIndex,
        ordinaryThreeSeventyData,
        ordinarySevenFiftyIndex,
        ordinarySevenFiftyData,
        mediumOneEightyndex,
        mediumOneEightyData,
        mediumThreeSeventyFiveIndex,
        mediumThreeSeventyData,
        mediumSevenFiftyIndex,
        mediumSevenFiftyData,
        premiumOneEightyndex,
        premiumOneEightyData,
        premiumThreeSeventyFiveIndex,
        premiumThreeSeventyData,
        premiumSevenFiftyIndex,
        premiumSevenFiftyData,
        beerThreeTwentyFiveIndex,
        beerThreeTwentyFiveData,
        beerFiveHundredFiveIndex,
        beerFiveHundredFiveData,
        beerSixFiftyFiveIndex,
        beerSixFiftyFiveData,
        odinaryOneThousandIndex,
        odinaryOneThousandData,
        mediumOneThousandIndex,
        mediumOneThousandData,
        premiumOneThousandIndex,
        premiumOneThousandData,
      );

      debugPrint('headingList $headingList');
      return [headingList!];
    }

    final Map<String, List<String>> salesDataMap = {};
    final Map<String, List<String>> beerSalesDataMap = {};
    final Map<String, List<String>> inwardDataMap = {};
    final Map<String, List<String>> beerInwardDataMap = {};
    final Map<String, List<String>> itemsDataMap = {};
    final Map<String, List<String>> beerItemsDataMap = {};

    final List<List<String>> rowData = [];
    final List<List<String>> beerRowData = [];
    final List<List<int>> totalOrdinaryOpeningValueList = [];
    final List<List<int>> totalMediumValueList = [];
    final List<List<int>> totalPremiumValueList = [];
    final List<List<int>> totalBeerValueList = [];

    int sixFiftyOpBtlsCount = 0;
    int sixFiftyReceiptBtlsCount = 0;
    int sixFiftyActualBtlsCount = 0;
    int sixFiftyClosingBtlsCount = 0;
    int sixFiftySalesBtlsCount = 0;

    int fiveHundredAndThreeTwentyFiveOpBtlsCount = 0;
    int fiveHundredAndThreeTwentyFiveReceiptBtlsCount = 0;
    int fiveHundredAndThreeTwentyFiveActualBtlsCount = 0;
    int fiveHundredAndThreeTwentyFiveClosingBtlsCount = 0;
    int fiveHundredAndThreeTwentyFiveSalesBtlsCount = 0;

    int totalOrdinaryOpBtls = 0;
    int totalOrdinaryReceiptBtls = 0;
    int totalOrdinaryActualBtls = 0;
    int totalOrdinaryClosingBtls = 0;
    int totalOrdinarySalesBtls = 0;
    int totalOrdinaryValue = 0;

    int totalOrdOpeningValue = 0;
    int totalOrdPurchaseValue = 0;
    int totalOrdActualValue = 0;
    int totalOrdClosingValue = 0;
    int totalOrdSalesValue = 0;

    int totalMdmOpeningValue = 0;
    int totalMdmPurchaseValue = 0;
    int totalMdmActualValue = 0;
    int totalMdmClosingValue = 0;
    int totalMdmSalesValue = 0;

    int totalPrmOpeningValue = 0;
    int totalPrmPurchaseValue = 0;
    int totalPrmActualValue = 0;
    int totalPrmClosingValue = 0;
    int totalPrmSalesValue = 0;

    int totalBeerOpValue = 0;
    int totalBeerReceiptValue = 0;
    int totalBeerActualValue = 0;
    int totalBeerCbValue = 0;
    int totalBeerSalesValue = 0;

    int totalMediumOpBtls = 0;
    int totalMediumReceiptBtls = 0;
    int totalMediumActualBtls = 0;
    int totalMediumClosingBtls = 0;
    int totalMediumSalesBtls = 0;
    int totalMediumValue = 0;

    int totalPremiumOpBtls = 0;
    int totalPremiumReceiptBtls = 0;
    int totalPremiumActualBtls = 0;
    int totalPremiumClosingBtls = 0;
    int totalPremiumSalesBtls = 0;
    int totalPremiumValue = 0;

    List<List<dynamic>> totalOrdinaryLastRow = [];
    List<List<dynamic>> totalMediumLastRow = [];
    List<List<dynamic>> totalPremiumLastRow = [];

    final List<int> ordinaryOneEightyOpBtls = [];
    final List<int> ordinaryThreeSeventyFiveOpBtls = [];
    final List<int> ordinarySevenFiftyOpBtls = [];
    final List<int> ordinaryOneThousandOpBtls = [];

    final List<int> ordinaryOneEightyPurchaseBtls = [];
    final List<int> ordinaryThreeSeventyFivePurchaseBtls = [];
    final List<int> ordinarySevenFiftyPurchaseBtls = [];
    final List<int> ordinaryOneThousandPurchaseBtls = [];

    final List<int> ordinaryOneEightyOpeingAndPurchaseBtls = [];
    final List<int> ordinaryThreeSeventyFiveOpeingAndPurchaseBtls = [];
    final List<int> ordinarySevenFiftyOpeingAndPurchaseBtls = [];
    final List<int> ordinaryOneThousandOpeingAndPurchaseBtls = [];

    final List<int> ordinaryOneEightyClosingBtls = [];
    final List<int> ordinaryThreeSeventyFiveClosingBtls = [];
    final List<int> ordinarySevenFiftyClosingBtls = [];
    final List<int> ordinaryOneThousandClosingBtls = [];

    final List<int> ordinaryOneEightySalesBtls = [];
    final List<int> ordinaryThreeSeventyFiveSalesBtls = [];
    final List<int> ordinarySevenFiftySalesBtls = [];
    final List<int> ordinaryOneThousandSalesBtls = [];

    final List<int> ordinaryOneEightyTotalValues = [];
    final List<int> ordinaryThreeSeventyFiveTotalValues = [];
    final List<int> ordinarySevenFiftyTotalValues = [];
    final List<int> ordinaryOneThousandTotalValues = [];

    final List<int> mediumOneEightyOpBtls = [];
    final List<int> mediumThreeSeventyFiveOpBtls = [];
    final List<int> mediumSevenFiftyOpBtls = [];
    final List<int> mediumOneThousandOpBtls = [];

    final List<int> mediumOneEightyPurchaseBtls = [];
    final List<int> mediumThreeSeventyFivePurchaseBtls = [];
    final List<int> mediumSevenFiftyPurchaseBtls = [];
    final List<int> mediumOneThousandPurchaseBtls = [];

    final List<int> mediumOneEightyOpeingAndPurchaseBtls = [];
    final List<int> mediumThreeSeventyFiveOpeingAndPurchaseBtls = [];
    final List<int> mediumSevenFiftyOpeingAndPurchaseBtls = [];
    final List<int> mediumOneThousandOpeingAndPurchaseBtls = [];

    final List<int> mediumOneEightyClosingBtls = [];
    final List<int> mediumThreeSeventyFiveClosingBtls = [];
    final List<int> mediumSevenFiftyClosingBtls = [];
    final List<int> mediumOneThousandClosingBtls = [];

    final List<int> mediumOneEightySalesBtls = [];
    final List<int> mediumThreeSeventyFiveSalesBtls = [];
    final List<int> mediumSevenFiftySalesBtls = [];
    final List<int> mediumOneThousandSalesBtls = [];

    final List<int> mediumOneEightyTotalValues = [];
    final List<int> mediumThreeSeventyFiveTotalValues = [];
    final List<int> mediumSevenFiftyTotalValues = [];
    final List<int> mediumOneThousandTotalValues = [];

    final List<int> premiumOneEightyOpBtls = [];
    final List<int> premiumThreeSeventyFiveOpBtls = [];
    final List<int> premiumSevenFiftyOpBtls = [];
    final List<int> premiumOneThousandOpBtls = [];

    final List<int> premiumOneEightyPurchaseBtls = [];
    final List<int> premiumThreeSeventyFivePurchaseBtls = [];
    final List<int> premiumSevenFiftyPurchaseBtls = [];
    final List<int> premiumOneThousandPurchaseBtls = [];

    final List<int> premiumOneEightyOpeingAndPurchaseBtls = [];
    final List<int> premiumThreeSeventyFiveOpeingAndPurchaseBtls = [];
    final List<int> premiumSevenFiftyOpeingAndPurchaseBtls = [];
    final List<int> premiumOneThousandOpeingAndPurchaseBtls = [];

    final List<int> premiumOneEightyClosingBtls = [];
    final List<int> premiumThreeSeventyFiveClosingBtls = [];
    final List<int> premiumSevenFiftyClosingBtls = [];
    final List<int> premiumOneThousandClosingBtls = [];

    final List<int> premiumOneEightySalesBtls = [];
    final List<int> premiumThreeSeventyFiveSalesBtls = [];
    final List<int> premiumSevenFiftySalesBtls = [];
    final List<int> premiumOneThousandSalesBtls = [];

    final List<int> premiumOneEightyTotalValues = [];
    final List<int> premiumThreeSeventyFiveTotalValues = [];
    final List<int> premiumSevenFiftyTotalValues = [];
    final List<int> premiumOneThousandTotalValues = [];

    final List<int> openingBtlCount = [];
    final List<int> beerOpeningBtlCount = [];
    final List<int> purchaseBtlCount = [];
    final List<int> beerPurchaseBtlCount = [];
    final List<int> totalOpeningAndPurchaseBtlCount = [];
    final List<int> totalBeerOpeningAndPurchaseBtlCount = [];
    final List<int> totalClosingBtlCount = [];
    final List<int> totalBeerClosingBtlCount = [];
    final List<int> totalSalesBtlCount = [];
    final List<int> totalBeerSalesBtlCount = [];
    final List<int> totalValue = [];
    final List<int> totalBeerValue = [];

    final List<int> mediumOpeningBtlCount = [];
    final List<int> mediumPurchaseBtlCount = [];
    final List<int> totalMediumOpeningAndPurchaseBtlCount = [];
    final List<int> totalMediumClosingBtlCount = [];
    final List<int> totalMediumSalesBtlCount = [];
    final List<int> mediumTotalValue = [];

    final List<int> premiumOpeningBtlCount = [];
    final List<int> premiumPurchaseBtlCount = [];
    final List<int> totalPremiumOpeningAndPurchaseBtlCount = [];
    final List<int> totalPremiumClosingBtlCount = [];
    final List<int> totalPremiumSalesBtlCount = [];
    final List<int> premiumTotalValue = [];

    final List<List<String>> ordinaryData = [];

    final List<List<String>> mediumData = [];
    final List<List<String>> premiumData = [];

    final List<dynamic> salesCumulative = [];

    final List<String> inwardDatas = [];

    final itemsDatas = [];

    final orderList = [];
    final orderItemMap = {};

    List<Map<String, dynamic>> orderItemsMaps = [];

    if (isDailyStatement == true) {
      if (isConnected == true) {
        debugPrint('bf get cumulaticvve');
        DocumentSnapshot getAdjustmentValue = await _firestore
            .collection('items')
            .doc(shopId.toString())
            .collection('cumulative')
            .doc('cumulative')
            .get();

        bool isSameMonthOf(DateTime lastDate, DateTime currentDate) {
          return lastDate.year == currentDate.year &&
              lastDate.month == currentDate.month;
        }

        Map<String, dynamic> adjustData =
            getAdjustmentValue.data() as Map<String, dynamic>;
        debugPrint('ddddaaa $dateList');
        for (String docId in dateList) {
          DocumentSnapshot oneMonthSaleInfo = await _firestore
              .collection('sales')
              .doc(shopId.toString())
              .collection('date')
              .doc(docId)
              .get();

          if (oneMonthSaleInfo.exists) {
            Map<String, dynamic> data =
                oneMonthSaleInfo.data() as Map<String, dynamic>;

            int adjustSalesCumulation = adjustData['salesAdjustment'] ?? 0;
            final validateSalesAdjustment = adjustData['lastDateOfMonth'];
            debugPrint('validateSalesAdjustment $validateSalesAdjustment');
            final lastDateTime = DateTime.fromMillisecondsSinceEpoch(
              validateSalesAdjustment.seconds * 1000 +
                  (validateSalesAdjustment.nanoseconds / 1000000).toInt(),
            );

            debugPrint('dateTime333 $lastDateTime');
            debugPrint('dateTime333fff ${dateList[0]}');

            DateTime todayDate = DateTime.parse(dateList[0]);
            bool isSameMonth = isSameMonthOf(lastDateTime, todayDate);

            debugPrint('isSameMonthisSameMonth $isSameMonth');

            data.forEach((productId, productData) {
              Map<String, dynamic> product =
                  productData as Map<String, dynamic>;
              int totalPrice = 0;
              if (product.containsKey('totalPrice')) {
                totalPrice = productData['totalPrice'] ?? 0;
              } else if (product.containsKey('totalPriceSales')) {
                totalPrice = productData['totalPriceSales'] ?? 0;
              }

              monthSales += totalPrice;
              if (isSameMonth == true) {
                currentMonthSales = adjustSalesCumulation + monthSales;
              } else {
                currentMonthSales = monthSales;
              }

              debugPrint('monthSales $monthSales');
              debugPrint('currentMonthSales $currentMonthSales');
              salesCumulative.add(currentMonthSales);
            });
          }
        }
      } else {
        salesCumulative.add(currentMonthSales);
      }
    }
    final posController = getIt<PosController>();
    final posDatas = await posController.getPosDataUsingDateInFirebase(
      currentDate,
      '3810',
    );

    posMachineValuePerDay = posDatas[0];
    posMonthlyCumulation = posDatas[1];

    debugPrint(
      'posMachineValuePerDay $posMachineValuePerDay, posMonthlyCumulation $posMonthlyCumulation',
    );
    // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // //
    // final List<Map<String, dynamic>> productIds = await db.rawQuery(
    //   'SELECT productId FROM brand ORDER BY id ASC',
    // );

    List<BrandModel> brandData = await _fireRepo.getBrandCollection(
      shopId.toString(),
    );
    List<String> uniqueBrandGroups = await _fireRepo.getBrandDetails(
      shopId: shopId.toString(),
      docId: 'group',
      key: 'groups',
    );
    List<String> uniqueBrandImflSize = await _fireRepo.getBrandDetails(
      shopId: shopId.toString(),
      docId: 'size',
      key: 'size',
    );
    List<String> uniqueBrandImflRange = await _fireRepo.getBrandDetails(
      shopId: shopId.toString(),
      docId: 'range',
      key: 'range',
    );

    List<ItemsViewModel> itemsData = await _fireRepo.getOpeningDoc(
      lastDate.toString(),
      '3810',
    );
    itemsDatas.addAll(itemsData);
    List<SalesViewModel> salesData = await _fireRepo.getSalesDoc(
      lastDate.toString(),
      '3810',
    );
    List<InwardViewModel> inwardData = await _fireRepo.getInwardDoc(
      lastDate.toString(),
      '3810',
    );

    //////////
    List<String> productIds = [];
    for (final group in uniqueBrandGroups) {
      for (final size in uniqueBrandImflSize) {
        for (final range in uniqueBrandImflRange) {
          productIds = brandData
              .where(
                (brand) =>
                    brand.groups == group &&
                    brand.size == size &&
                    brand.range == range,
              )
              .map((brand) => brand.productId.toString())
              .toList();

          if (productIds.isEmpty) continue;

          print(productIds);
        }
      }
    }

    for (final productId in productIds) {
      // items data
      ItemsViewModel item = itemsData.firstWhere(
        (data) => data.productId.toString() == productId,
      );

      final itemsProductId = item.productId.toString();

      List<String>? itemsRowData = [];

      if (isDailyStatement == true) {
        debugPrint('daily statement');
        itemsRowData = [
          item.productId.toString(),
          item.brand,
          item.category,
          item.size.toString(),
          item.range,
          item.price.toString(),
          item.totalOpenRetailUnits.toString(),
          item.totalCloseRetailUnits.toString(),
        ];
      } else {
        debugPrint('op stock statement pdf');
        itemsRowData = [
          item.productId.toString(),
          item.brand,
          item.size.toString(),
          item.range,
          item.price.toString(),
          item.totalOpenRetailUnits.toString(),
          item.totalPriceOpening.toString(),
        ];
      }

      if (item.itemsGroup == "IMFL") {
        itemsDataMap[itemsProductId] = itemsRowData;
      }

      if (item.itemsGroup == "BEER") {
        beerItemsDataMap[itemsProductId] = itemsRowData;
      }

      // sales Data
      if (isDailyStatement == true) {
        SalesViewModel item = salesData.firstWhere(
          (data) => data.productId.toString() == productId,
        );

        final salesProductId = item.productId.toString();

        final salesRowData = [
          item.totalSalesRetailUnits.toString(),
          item.totalPriceSales.toString(),
        ];
        if (item.group == "IMFL") {
          salesDataMap[salesProductId] = salesRowData;
        }

        if (item.group == "BEER") {
          beerSalesDataMap[salesProductId] = salesRowData;
        }
      }

      // inward data
      InwardViewModel inward = inwardData.firstWhere(
        (data) => data.productId.toString() == productId,
      );
      String inwardPrdouctId = inward.productId.toString();

      List<String> inwardRowData = [];

      if (isDailyStatement == true) {
        inwardRowData = [inward.totalInwardRetailUnits.toString()];
      } else {
        inwardRowData = [
          inward.totalInwardRetailUnits.toString(),
          inward.range,
          inward.price.toString(),
        ];

        debugPrint('op inward statement');
      }

      if (inward.inwardGroup == "IMFL") {
        inwardDataMap[inwardPrdouctId] = inwardRowData;
        debugPrint('inwardDataMap $inwardDataMap');
      }

      if (inward.inwardGroup == "BEER") {
        beerInwardDataMap[inwardPrdouctId] = inwardRowData;
      }

      inwardDatas.add(inwardRowData.toString());

      List<List<String>> allMatchedItems = [];

      debugPrint('itemsDataMap333333 $itemsDataMap');

      if (isDailyStatement == true) {
        if (item.itemsGroup == "IMFL") {
          for (final productId in itemsDataMap.keys) {
            if (salesDataMap.containsKey(productId) ||
                inwardDataMap.containsKey(productId)) {
              final salesRowData = salesDataMap[productId];
              final matchedItem = itemsDataMap[productId];
              debugPrint('matchedItemmatchedItem $matchedItem');
              allMatchedItems.add(matchedItem!);
              debugPrint('allMatchedItems $allMatchedItems');

              final totalSalesRetailUnits = salesRowData?[0] ?? '0';
              final totalPrice = salesRowData?[1] ?? '0';

              final matchedInwardData = inwardDataMap[productId];
              final matchedInwardItem = itemsDataMap[productId];

              String totalInwardRetailUnits = matchedInwardData?[0] ?? "0";

              matchedItem?.insert(7, totalInwardRetailUnits ?? '0');

              String openingBottle = matchedInwardItem![6];
              String purchaseBottle = matchedInwardItem[7];

              int opBottle = int.parse(openingBottle);
              int purchaseBtl = int.parse(purchaseBottle);
              int price = int.parse(matchedInwardItem[5]);
              int closingBtl = int.parse(matchedInwardItem[8]);

              if (matchedInwardItem[4] == 'ORDINARY') {
                int totalOpeningValue = price * opBottle;
                int totalPurchaseValue = price * purchaseBtl;
                int totalClosingValue = price * closingBtl;

                int totalOpeingAndPurchaseBottle = opBottle + purchaseBtl;

                int closingBottle = int.parse(matchedInwardItem[8]);

                int saleBottles = int.parse(salesRowData![0]);

                int totalVal;

                List<int> nestedList = [
                  totalOpeningValue,
                  totalPurchaseValue,
                  totalClosingValue,
                ];
                totalOrdinaryOpeningValueList.add(nestedList);

                openingBtlCount.add(opBottle);

                purchaseBtlCount.add(purchaseBtl);

                totalOpeningAndPurchaseBtlCount.add(
                  totalOpeingAndPurchaseBottle,
                );

                String totalOpAndPurchaseBtl = totalOpeingAndPurchaseBottle
                    .toString();

                matchedItem?.insert(8, totalOpAndPurchaseBtl ?? '0');

                totalClosingBtlCount.add(closingBottle);
                totalSalesBtlCount.add(saleBottles);

                matchedItem?.addAll([
                  totalSalesRetailUnits ?? '0',
                  totalPrice ?? "0",
                ]);

                debugPrint('matchedItem2222222 $matchedItem');

                totalVal = int.parse(matchedItem[11]);
                totalValue.add(totalVal);

                if (matchedInwardItem[3] == '180 ml') {
                  ordinaryOneEightyOpBtls.add(opBottle);
                  ordinaryOneEightyPurchaseBtls.add(purchaseBtl);
                  ordinaryOneEightyOpeingAndPurchaseBtls.add(
                    totalOpeingAndPurchaseBottle,
                  );
                  ordinaryOneEightyClosingBtls.add(closingBottle);
                  ordinaryOneEightySalesBtls.add(saleBottles);
                  ordinaryOneEightyTotalValues.add(totalVal);
                } else if (matchedInwardItem[3] == '375 ml') {
                  ordinaryThreeSeventyFiveOpBtls.add(opBottle);
                  ordinaryThreeSeventyFivePurchaseBtls.add(purchaseBtl);
                  ordinaryThreeSeventyFiveOpeingAndPurchaseBtls.add(
                    totalOpeingAndPurchaseBottle,
                  );
                  ordinaryThreeSeventyFiveClosingBtls.add(closingBottle);
                  ordinaryThreeSeventyFiveSalesBtls.add(saleBottles);
                  ordinaryThreeSeventyFiveTotalValues.add(totalVal);
                } else if (matchedInwardItem[3] == '750 ml') {
                  ordinarySevenFiftyOpBtls.add(opBottle);
                  ordinarySevenFiftyPurchaseBtls.add(purchaseBtl);
                  ordinarySevenFiftyOpeingAndPurchaseBtls.add(
                    totalOpeingAndPurchaseBottle,
                  );
                  ordinarySevenFiftyClosingBtls.add(closingBottle);
                  ordinarySevenFiftySalesBtls.add(saleBottles);
                  ordinarySevenFiftyTotalValues.add(totalVal);
                } else if (matchedInwardItem[3] == '1000 ml') {
                  ordinaryOneThousandOpBtls.add(opBottle);
                  ordinaryOneThousandPurchaseBtls.add(purchaseBtl);
                  ordinaryOneThousandOpeingAndPurchaseBtls.add(
                    totalOpeingAndPurchaseBottle,
                  );
                  ordinaryOneThousandClosingBtls.add(closingBottle);
                  ordinaryOneThousandSalesBtls.add(saleBottles);
                  ordinaryOneThousandTotalValues.add(totalVal);
                }
                if (closingPdfFormat == 'default') {
                  totalOrdinaryOpBtls += opBottle;
                  totalOrdinaryReceiptBtls += purchaseBtl;
                  totalOrdinaryActualBtls += totalOpeingAndPurchaseBottle;
                  totalOrdinaryClosingBtls += closingBottle;
                  totalOrdinarySalesBtls += saleBottles;
                  totalOrdinaryValue += totalVal;
                }
                totalOrdOpeningValue += (price * opBottle);
                totalOrdPurchaseValue += (price * purchaseBtl);
                totalOrdActualValue += (price * totalOpeingAndPurchaseBottle);
                totalOrdClosingValue += (price * closingBtl);
                totalOrdSalesValue += (price * saleBottles);

                totalOrdinaryLastRow = [
                  [
                    '',
                    '',
                    '',
                    '',
                    '',
                    totalOrdinaryOpBtls,
                    totalOrdinaryReceiptBtls,
                    totalOrdinaryActualBtls,
                    totalOrdinaryClosingBtls,
                    totalOrdinarySalesBtls,
                    totalOrdinaryValue,
                  ],
                ];
                ordinaryData.add(matchedInwardItem);
                debugPrint('ordinaryData $ordinaryData');
              }

              if (matchedInwardItem[4] == 'MEDIUM') {
                int totalMediumOpeningValue = price * opBottle;
                int totalMediumPurchaseValue = price * purchaseBtl;
                int totalMediumClosingValue = price * closingBtl;

                List<int> nestedList = [
                  totalMediumOpeningValue,
                  totalMediumPurchaseValue,
                  totalMediumClosingValue,
                ];

                totalMediumValueList.add(nestedList);
                mediumOpeningBtlCount.add(opBottle);

                mediumPurchaseBtlCount.add(purchaseBtl);

                int totalOpeingAndPurchaseBottle = opBottle + purchaseBtl;

                totalMediumOpeningAndPurchaseBtlCount.add(
                  totalOpeingAndPurchaseBottle,
                );

                String totalOpAndPurchaseBtl = totalOpeingAndPurchaseBottle
                    .toString();

                matchedItem?.insert(8, totalOpAndPurchaseBtl ?? '0');

                int closingBottle = int.parse(matchedInwardItem[9]);
                totalMediumClosingBtlCount.add(closingBottle);

                int saleBottles = int.parse(salesRowData![0]);
                totalMediumSalesBtlCount.add(saleBottles);

                matchedItem?.addAll([
                  totalSalesRetailUnits ?? '0',
                  totalPrice ?? "0",
                ]);

                int totalVal = int.parse(matchedItem[11]);
                mediumTotalValue.add(totalVal);

                if (matchedInwardItem[3] == '180 ml') {
                  mediumOneEightyOpBtls.add(opBottle);
                  mediumOneEightyPurchaseBtls.add(purchaseBtl);
                  mediumOneEightyOpeingAndPurchaseBtls.add(
                    totalOpeingAndPurchaseBottle,
                  );
                  mediumOneEightyClosingBtls.add(closingBottle);
                  mediumOneEightySalesBtls.add(saleBottles);
                  mediumOneEightyTotalValues.add(totalVal);
                } else if (matchedInwardItem[3] == '375 ml') {
                  mediumThreeSeventyFiveOpBtls.add(opBottle);
                  mediumThreeSeventyFivePurchaseBtls.add(purchaseBtl);
                  mediumThreeSeventyFiveOpeingAndPurchaseBtls.add(
                    totalOpeingAndPurchaseBottle,
                  );
                  mediumThreeSeventyFiveClosingBtls.add(closingBottle);
                  mediumThreeSeventyFiveSalesBtls.add(saleBottles);
                  mediumThreeSeventyFiveTotalValues.add(totalVal);
                } else if (matchedInwardItem[3] == '750 ml') {
                  mediumSevenFiftyOpBtls.add(opBottle);
                  mediumSevenFiftyPurchaseBtls.add(purchaseBtl);
                  mediumSevenFiftyOpeingAndPurchaseBtls.add(
                    totalOpeingAndPurchaseBottle,
                  );
                  mediumSevenFiftyClosingBtls.add(closingBottle);
                  mediumSevenFiftySalesBtls.add(saleBottles);
                  mediumSevenFiftyTotalValues.add(totalVal);
                } else if (matchedInwardItem[3] == '1000 ml') {
                  mediumOneThousandOpBtls.add(opBottle);
                  mediumOneThousandPurchaseBtls.add(purchaseBtl);
                  mediumOneThousandOpeingAndPurchaseBtls.add(
                    totalOpeingAndPurchaseBottle,
                  );
                  mediumOneThousandClosingBtls.add(closingBottle);
                  mediumOneThousandSalesBtls.add(saleBottles);
                  mediumOneThousandTotalValues.add(totalVal);
                }
                if (closingPdfFormat == 'default') {
                  totalMediumOpBtls += opBottle;
                  totalMediumReceiptBtls += purchaseBtl;
                  totalMediumActualBtls += totalOpeingAndPurchaseBottle;
                  totalMediumClosingBtls += closingBottle;
                  totalMediumSalesBtls += saleBottles;
                  totalMediumValue += totalVal;
                }

                totalMdmOpeningValue += (price * opBottle);
                totalMdmPurchaseValue += (price * purchaseBtl);
                totalMdmActualValue += (price * totalOpeingAndPurchaseBottle);
                totalMdmClosingValue += (price * closingBtl);
                totalMdmSalesValue += (price * saleBottles);

                totalMediumLastRow = [
                  [
                    '',
                    '',
                    '',
                    '',
                    '',
                    totalMediumOpBtls,
                    totalMediumReceiptBtls,
                    totalMediumActualBtls,
                    totalMediumClosingBtls,
                    totalMediumSalesBtls,
                    totalMediumValue,
                  ],
                ];

                mediumData.add(matchedInwardItem);
              }

              if (matchedInwardItem[4] == 'PREMIUM') {
                int totalPremiumOpeningValue = price * opBottle;
                int totalPremiumPurchaseValue = price * purchaseBtl;
                int totalPremiumClosingValue = price * closingBtl;

                List<int> nestedList = [
                  totalPremiumOpeningValue,
                  totalPremiumPurchaseValue,
                  totalPremiumClosingValue,
                ];

                totalPremiumValueList.add(nestedList);

                premiumOpeningBtlCount.add(opBottle);

                premiumPurchaseBtlCount.add(purchaseBtl);

                int totalOpeingAndPurchaseBottle = opBottle + purchaseBtl;

                totalPremiumOpeningAndPurchaseBtlCount.add(
                  totalOpeingAndPurchaseBottle,
                );

                String totalOpAndPurchaseBtl = totalOpeingAndPurchaseBottle
                    .toString();

                matchedItem?.insert(8, totalOpAndPurchaseBtl ?? '0');

                int closingBottle = int.parse(matchedInwardItem[9]);
                totalPremiumClosingBtlCount.add(closingBottle);

                int saleBottles = int.parse(salesRowData![0]);
                totalPremiumSalesBtlCount.add(saleBottles);

                matchedItem?.addAll([
                  totalSalesRetailUnits ?? '0',
                  totalPrice ?? "0",
                ]);

                int totalVal = int.parse(matchedItem[11]);
                premiumTotalValue.add(totalVal);

                if (matchedInwardItem[3] == '180 ml') {
                  premiumOneEightyOpBtls.add(opBottle);
                  premiumOneEightyPurchaseBtls.add(purchaseBtl);
                  premiumOneEightyOpeingAndPurchaseBtls.add(
                    totalOpeingAndPurchaseBottle,
                  );
                  premiumOneEightyClosingBtls.add(closingBottle);
                  premiumOneEightySalesBtls.add(saleBottles);
                  premiumOneEightyTotalValues.add(totalVal);
                } else if (matchedInwardItem[3] == '375 ml') {
                  premiumThreeSeventyFiveOpBtls.add(opBottle);
                  premiumThreeSeventyFivePurchaseBtls.add(purchaseBtl);
                  premiumThreeSeventyFiveOpeingAndPurchaseBtls.add(
                    totalOpeingAndPurchaseBottle,
                  );
                  premiumThreeSeventyFiveClosingBtls.add(closingBottle);
                  premiumThreeSeventyFiveSalesBtls.add(saleBottles);
                  premiumThreeSeventyFiveTotalValues.add(totalVal);
                } else if (matchedInwardItem[3] == '750 ml') {
                  premiumSevenFiftyOpBtls.add(opBottle);
                  premiumSevenFiftyPurchaseBtls.add(purchaseBtl);
                  premiumSevenFiftyOpeingAndPurchaseBtls.add(
                    totalOpeingAndPurchaseBottle,
                  );
                  premiumSevenFiftyClosingBtls.add(closingBottle);
                  premiumSevenFiftySalesBtls.add(saleBottles);
                  premiumSevenFiftyTotalValues.add(totalVal);
                } else if (matchedInwardItem[3] == '1000 ml') {
                  premiumOneThousandOpBtls.add(opBottle);
                  premiumOneThousandPurchaseBtls.add(purchaseBtl);
                  premiumOneThousandOpeingAndPurchaseBtls.add(
                    totalOpeingAndPurchaseBottle,
                  );
                  premiumOneThousandClosingBtls.add(closingBottle);
                  premiumOneThousandSalesBtls.add(saleBottles);
                  premiumOneThousandTotalValues.add(totalVal);
                }
                if (closingPdfFormat == 'default') {
                  totalPremiumOpBtls += opBottle;
                  totalPremiumReceiptBtls += purchaseBtl;
                  totalPremiumActualBtls += totalOpeingAndPurchaseBottle;
                  totalPremiumClosingBtls += closingBottle;
                  totalPremiumSalesBtls += saleBottles;
                  totalPremiumValue += totalVal;
                }

                totalPrmOpeningValue += (price * opBottle);
                totalPrmPurchaseValue += (price * purchaseBtl);
                totalPrmActualValue += (price * totalOpeingAndPurchaseBottle);
                totalPrmClosingValue += (price * closingBtl);
                totalPrmSalesValue += (price * saleBottles);

                totalPremiumLastRow = [
                  [
                    '',
                    '',
                    '',
                    '',
                    '',
                    totalPremiumOpBtls,
                    totalPremiumReceiptBtls,
                    totalPremiumActualBtls,
                    totalPremiumClosingBtls,
                    totalPremiumSalesBtls,
                    totalPremiumValue,
                  ],
                ];

                premiumData.add(matchedInwardItem);
              }

              rowData.add(matchedInwardItem);
            }
          }
        }
      } else {
        if (item.itemsGroup == "IMFL") {
          for (final productId in itemsDataMap.keys) {
            if (inwardDataMap.containsKey(productId)) {
              final matchedItem = itemsDataMap[productId];
              debugPrint('matchedItemmatchedItem33333333 $matchedItem');
              allMatchedItems.add(matchedItem!);
              debugPrint('allMatchedItems33333 $allMatchedItems');

              final matchedInwardData = inwardDataMap[productId];
              final matchedInwardItem = itemsDataMap[productId];

              String totalInwardRetailUnits = matchedInwardData?[0] ?? "0";

              debugPrint('matchedInwardData2222 $matchedInwardData');
              debugPrint('matchedInwardItem333 $matchedInwardItem');
              debugPrint('totalInwardRetailUnits $totalInwardRetailUnits');
              debugPrint('bf swapListVal');

              debugPrint('af swapListVal');

              debugPrint('matchedInwardItem#### ${matchedInwardItem![3]}');

              debugPrint('bf ORDINARY');
              final List<List<String>> data = await sperateImflList(
                matchedInwardItem,
                matchedInwardData,
              );
              debugPrint('data2222 $data');
              debugPrint('listlist $ordinaryHeadingList');
            } else {
              final matchedItem = itemsDataMap[productId];
              debugPrint('matchedItemmatchedItem33333333 $matchedItem');
              allMatchedItems.add(matchedItem!);
              debugPrint('allMatchedItems33333 $allMatchedItems');

              final matchedInwardData = inwardDataMap[productId];
              final matchedInwardItem = itemsDataMap[productId];

              String totalInwardRetailUnits = matchedInwardData?[0] ?? "0";

              debugPrint('matchedInwardData $matchedInwardData');
              debugPrint('matchedInwardItem $matchedInwardItem');
              debugPrint('totalInwardRetailUnits $totalInwardRetailUnits');
              debugPrint('bf swapListVal');
              debugPrint('af swapListVal');

              debugPrint('matchedInwardItem#### ${matchedInwardItem![3]}');

              debugPrint('bf ORDINARY');
              final List<List<String>> data = await sperateImflList(
                matchedInwardItem,
                matchedInwardData,
              );
              debugPrint('data2222 $data');
              debugPrint('listlist $ordinaryHeadingList');
            }
          }
        }
      }

      if (isDailyStatement == true) {
        if (item.itemsGroup == "BEER") {
          for (final productId in beerItemsDataMap.keys) {
            if (beerSalesDataMap.containsKey(productId) ||
                beerInwardDataMap.containsKey(productId)) {
              final salesRowData = beerSalesDataMap[productId];
              final matchedItem = beerItemsDataMap[productId];

              debugPrint('beermatchedItem $matchedItem');

              allMatchedItems.add(matchedItem!);

              final totalSalesRetailUnits = salesRowData?[0] ?? '0';
              final totalPrice = salesRowData?[1] ?? '0';

              final matchedInwardData = beerInwardDataMap[productId];
              final matchedInwardItem = beerItemsDataMap[productId];

              String totalInwardRetailUnits = matchedInwardData?[0] ?? "0";

              matchedItem?.insert(7, totalInwardRetailUnits ?? '0');

              String openingBottle = matchedInwardItem![6];
              String purchaseBottle = matchedInwardItem[7];

              int opBottle = int.parse(openingBottle);
              int purchaseBtl = int.parse(purchaseBottle);
              int price = int.parse(matchedInwardItem[5]);
              int closingBtl = int.parse(matchedInwardItem[8]);

              int totalBeerOpeningValue = price * opBottle;
              int totalBeerPurchaseValue = price * purchaseBtl;
              int totalBeerClosingValue = price * closingBtl;

              List<int> nestedList = [
                totalBeerOpeningValue,
                totalBeerPurchaseValue,
                totalBeerClosingValue,
              ];

              totalBeerValueList.add(nestedList);

              beerOpeningBtlCount.add(opBottle);

              beerPurchaseBtlCount.add(purchaseBtl);

              int totalOpeingAndPurchaseBottle = opBottle + purchaseBtl;

              totalBeerOpeningAndPurchaseBtlCount.add(
                totalOpeingAndPurchaseBottle,
              );

              String totalOpAndPurchaseBtl = totalOpeingAndPurchaseBottle
                  .toString();
              matchedItem?.insert(8, totalOpAndPurchaseBtl ?? '0');

              int closingBottle = int.parse(matchedInwardItem[9]);
              totalBeerClosingBtlCount.add(closingBottle);

              int saleBottles = int.parse(salesRowData![0]);
              totalBeerSalesBtlCount.add(saleBottles);

              matchedItem?.addAll([
                totalSalesRetailUnits ?? '0',
                totalPrice ?? "0",
              ]);

              int totalVal = int.parse(matchedItem[11]);
              totalBeerValue.add(totalVal);

              matchedInwardItem.removeAt(2);
              debugPrint('matchedInwardItem66666666$matchedInwardItem');

              if (matchedInwardItem[2] == '650 ml') {
                debugPrint(
                  '650 ml matchedInwardItem[2] ${matchedInwardItem[2]}',
                );

                sixFiftyOpBtlsCount += opBottle;
                sixFiftyReceiptBtlsCount += purchaseBtl;
                sixFiftyActualBtlsCount += totalOpeingAndPurchaseBottle;
                sixFiftyClosingBtlsCount += closingBottle;
                sixFiftySalesBtlsCount += saleBottles;
              } else {
                fiveHundredAndThreeTwentyFiveOpBtlsCount += opBottle;
                fiveHundredAndThreeTwentyFiveReceiptBtlsCount += purchaseBtl;
                fiveHundredAndThreeTwentyFiveActualBtlsCount +=
                    totalOpeingAndPurchaseBottle;
                fiveHundredAndThreeTwentyFiveClosingBtlsCount += closingBottle;
                fiveHundredAndThreeTwentyFiveSalesBtlsCount += saleBottles;
              }

              totalBeerOpValue += (price * opBottle);
              totalBeerReceiptValue += (price * purchaseBtl);
              totalBeerActualValue += (price * totalOpeingAndPurchaseBottle);
              totalBeerCbValue += (price * closingBottle);
              totalBeerSalesValue += (price * saleBottles);

              beerRowData.add(matchedInwardItem);
              debugPrint('beerRowData$beerRowData');
            }
          }
        }
      } else {
        debugPrint('beer op bottle ');
        if (item.itemsGroup == "BEER") {
          for (final productId in beerItemsDataMap.keys) {
            if (beerInwardDataMap.containsKey(productId)) {
              final matchedItem = beerItemsDataMap[productId];

              debugPrint('beermatchedItem $matchedItem');

              allMatchedItems.add(matchedItem!);

              final matchedInwardData = beerInwardDataMap[productId];
              final matchedInwardItem = beerItemsDataMap[productId];

              debugPrint('matchedInwardData beer $matchedInwardData');
              debugPrint('matchedInwardItem beer $matchedInwardItem');

              String totalInwardRetailUnits = matchedInwardData?[0] ?? "0";

              final List<List<String>> data = await sperateImflList(
                matchedInwardItem,
                matchedInwardData,
              );

              debugPrint('beer data 222 $data');
            } else {
              final matchedItem = beerItemsDataMap[productId];

              debugPrint('beermatchedItem $matchedItem');

              allMatchedItems.add(matchedItem!);

              final matchedInwardData = beerInwardDataMap[productId];
              final matchedInwardItem = beerItemsDataMap[productId];

              debugPrint('matchedInwardData beer $matchedInwardData');
              debugPrint('matchedInwardItem beer $matchedInwardItem');

              final List<List<String>> data = await sperateImflList(
                matchedInwardItem,
                matchedInwardData,
              );
            }
          }
        }
      }
    }

    //////////

    // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // // //
    List<List<String>> beerTrimmedBrandNameListOneConverted =
        beerTrimmedBrandNameListOne
            .map((sublist) => sublist.map((e) => e.toString()).toList())
            .toList();

    List<List<String>> beerTrimmedBrandNameListTwoConverted =
        beerTrimmedBrandNameListTwo
            .map((sublist) => sublist.map((e) => e.toString()).toList())
            .toList();

    List<List<String>> beerTrimmedBrandNameListThreeConverted =
        beerTrimmedBrandNameListThree
            .map((sublist) => sublist.map((e) => e.toString()).toList())
            .toList();

    beerTrimmedBrandNameList.addAll(beerTrimmedBrandNameListOneConverted);
    beerTrimmedBrandNameList.addAll(beerTrimmedBrandNameListTwoConverted);
    beerTrimmedBrandNameList.addAll(beerTrimmedBrandNameListThreeConverted);

    beerDatas.addAll(beerDataListOne);
    beerDatas.addAll(beerDataListTwo);
    beerDatas.addAll(beerDataListThree);

    debugPrint('beerDataListOne $beerDataListOne');
    debugPrint('beerDataListTwo $beerDataListTwo');
    debugPrint('beerDataListThree $beerDataListThree');

    debugPrint('beerTrimmedBrandNameListOne $beerTrimmedBrandNameListOne');
    debugPrint('beerTrimmedBrandNameListTwo $beerTrimmedBrandNameListTwo');
    debugPrint('beerTrimmedBrandNameListThree $beerTrimmedBrandNameListThree');
    debugPrint('beerTrimmedBrandNameList $beerTrimmedBrandNameList');
    debugPrint('beerDatasdddddd $beerDatas');

    debugPrint('ccccsalesCumulative $salesCumulative');

    debugPrint('ordinaryHeadingList222222 $ordinaryHeadingList');
    debugPrint('ordinaryOneEightyData222222 $ordinaryOneEightyData');

    debugPrint('itemsDataMap5555 $itemsDataMap');
    debugPrint('inwardDataMap5555 $inwardDataMap');

    debugPrint('itemsDatas33333 ${itemsDatas.toString()}');

    debugPrint('order list4444  $orderList');
    debugPrint('orderItemMap555 $orderItemMap');

    List<dynamic> createBottleDetail(String label, List<int> counts) {
      return [label, ...counts];
    }

    int safeReduce(List<int> numbers) {
      return numbers.isNotEmpty ? numbers.reduce((a, b) => a + b) : 0;
    }

    int oneEightyOpBtlsCount =
        safeReduce(ordinaryOneEightyOpBtls) +
        safeReduce(mediumOneEightyOpBtls) +
        safeReduce(premiumOneEightyOpBtls);

    int oneEightyPurchaseBtlsCount =
        safeReduce(ordinaryOneEightyPurchaseBtls) +
        safeReduce(mediumOneEightyPurchaseBtls) +
        safeReduce(premiumOneEightyPurchaseBtls);

    int oneEightyOpeingAndPurchaseBtlsCount =
        safeReduce(ordinaryOneEightyOpeingAndPurchaseBtls) +
        safeReduce(mediumOneEightyOpeingAndPurchaseBtls) +
        safeReduce(premiumOneEightyOpeingAndPurchaseBtls);

    int oneEightyClosingBtlsCount =
        safeReduce(ordinaryOneEightyClosingBtls) +
        safeReduce(mediumOneEightyClosingBtls) +
        safeReduce(premiumOneEightyClosingBtls);

    int oneEightySalesBtlsCount =
        safeReduce(ordinaryOneEightySalesBtls) +
        safeReduce(mediumOneEightySalesBtls) +
        safeReduce(premiumOneEightySalesBtls);

    int threeSeventyFiveOpBtlsCount =
        safeReduce(ordinaryThreeSeventyFiveOpBtls) +
        safeReduce(mediumThreeSeventyFiveOpBtls) +
        safeReduce(premiumThreeSeventyFiveOpBtls);

    int threeSeventyFivePurchaseBtlsCount =
        safeReduce(ordinaryThreeSeventyFivePurchaseBtls) +
        safeReduce(mediumThreeSeventyFivePurchaseBtls) +
        safeReduce(premiumThreeSeventyFivePurchaseBtls);

    int threeSeventyFiveOpeingAndPurchaseBtlsCount =
        safeReduce(ordinaryThreeSeventyFiveOpeingAndPurchaseBtls) +
        safeReduce(mediumThreeSeventyFiveOpeingAndPurchaseBtls) +
        safeReduce(premiumThreeSeventyFiveOpeingAndPurchaseBtls);

    int threeSeventyFiveClosingBtlsCount =
        safeReduce(ordinaryThreeSeventyFiveClosingBtls) +
        safeReduce(mediumThreeSeventyFiveClosingBtls) +
        safeReduce(premiumThreeSeventyFiveClosingBtls);

    int threeSeventyFiveSalesBtlsCount =
        safeReduce(ordinaryThreeSeventyFiveSalesBtls) +
        safeReduce(mediumThreeSeventyFiveSalesBtls) +
        safeReduce(premiumThreeSeventyFiveSalesBtls);

    int sevenFiftyOpBtlsCount =
        safeReduce(ordinarySevenFiftyOpBtls) +
        safeReduce(mediumSevenFiftyOpBtls) +
        safeReduce(premiumSevenFiftyOpBtls);

    int sevenFiftyPurchaseBtlsCount =
        safeReduce(ordinarySevenFiftyPurchaseBtls) +
        safeReduce(mediumSevenFiftyPurchaseBtls) +
        safeReduce(premiumSevenFiftyPurchaseBtls);

    int sevenFiftyOpeingAndPurchaseBtlsCount =
        safeReduce(ordinarySevenFiftyOpeingAndPurchaseBtls) +
        safeReduce(mediumSevenFiftyOpeingAndPurchaseBtls) +
        safeReduce(premiumSevenFiftyOpeingAndPurchaseBtls);

    int sevenFiftyClosingBtlsCount =
        safeReduce(ordinarySevenFiftyClosingBtls) +
        safeReduce(mediumSevenFiftyClosingBtls) +
        safeReduce(premiumSevenFiftyClosingBtls);

    int sevenFiftySalesBtlsCount =
        safeReduce(ordinarySevenFiftySalesBtls) +
        safeReduce(mediumSevenFiftySalesBtls) +
        safeReduce(premiumSevenFiftySalesBtls);

    int thousandOpBtlsCount =
        (ordinaryOneThousandOpBtls.isNotEmpty
            ? ordinaryOneThousandOpBtls.reduce((a, b) => a + b)
            : 0) +
        (mediumOneThousandOpBtls.isNotEmpty
            ? mediumOneThousandOpBtls.reduce((a, b) => a + b)
            : 0) +
        (premiumOneThousandOpBtls.isNotEmpty
            ? premiumOneThousandOpBtls.reduce((a, b) => a + b)
            : 0);

    int thousandPurchaseBtlsCount =
        safeReduce(ordinaryOneThousandPurchaseBtls) +
        safeReduce(mediumOneThousandPurchaseBtls) +
        safeReduce(premiumOneThousandPurchaseBtls);

    int thousandOpeingAndPurchaseBtlsCount =
        safeReduce(ordinaryOneThousandOpeingAndPurchaseBtls) +
        safeReduce(mediumOneThousandOpeingAndPurchaseBtls) +
        safeReduce(premiumOneThousandOpeingAndPurchaseBtls);

    int thousandClosingBtlsCount =
        safeReduce(ordinaryOneThousandClosingBtls) +
        safeReduce(mediumOneThousandClosingBtls) +
        safeReduce(premiumOneThousandClosingBtls);

    int thousandSalesBtlsCount =
        safeReduce(ordinaryOneThousandSalesBtls) +
        safeReduce(mediumOneThousandSalesBtls) +
        safeReduce(premiumOneThousandSalesBtls);

    List<dynamic> bottleOpCountDetail = createBottleDetail('OPENING', [
      thousandOpBtlsCount,
      sevenFiftyOpBtlsCount,
      threeSeventyFiveOpBtlsCount,
      oneEightyOpBtlsCount,
    ]);

    List<dynamic> bottleReceiptCountDetail = [
      'RECEIPT',
      thousandPurchaseBtlsCount,
      sevenFiftyPurchaseBtlsCount,
      threeSeventyFivePurchaseBtlsCount,
      oneEightyPurchaseBtlsCount,
    ];

    List<dynamic> bottleActualCountDetail = [
      'TOTAL',
      thousandOpeingAndPurchaseBtlsCount,
      sevenFiftyOpeingAndPurchaseBtlsCount,
      threeSeventyFiveOpeingAndPurchaseBtlsCount,
      oneEightyOpeingAndPurchaseBtlsCount,
    ];

    List<dynamic> bottleClosingCountDetail = [
      'CLOSING',
      thousandClosingBtlsCount,
      sevenFiftyClosingBtlsCount,
      threeSeventyFiveClosingBtlsCount,
      oneEightyClosingBtlsCount,
    ];

    List<dynamic> bottleSalesCountDetail = [
      'SALES',
      thousandSalesBtlsCount,
      sevenFiftySalesBtlsCount,
      threeSeventyFiveSalesBtlsCount,
      oneEightySalesBtlsCount,
    ];

    int imflOpvalues =
        totalOrdOpeningValue + totalMdmOpeningValue + totalPrmOpeningValue;
    int imflReceiptvalues =
        totalOrdPurchaseValue + totalMdmPurchaseValue + totalPrmPurchaseValue;
    int imflActualvalues =
        totalOrdActualValue + totalMdmActualValue + totalPrmActualValue;
    int imflClosingvalues =
        totalOrdClosingValue + totalMdmClosingValue + totalPrmClosingValue;
    int imflSalesvalues =
        totalOrdSalesValue + totalMdmSalesValue + totalPrmSalesValue;

    List<dynamic> imflValues = [
      'Rs',
      imflOpvalues,
      imflReceiptvalues,
      imflActualvalues,
      imflClosingvalues,
      imflSalesvalues,
    ];

    List<dynamic> beerValues = [
      'Rs',
      totalBeerOpValue,
      totalBeerReceiptValue,
      totalBeerActualValue,
      totalBeerCbValue,
      totalBeerSalesValue,
    ];

    List<dynamic> ImflAndBeerValues = [
      'Rs',
      imflOpvalues + totalBeerOpValue,
      imflReceiptvalues + totalBeerReceiptValue,
      imflActualvalues + totalBeerActualValue,
      imflClosingvalues + totalBeerCbValue,
      imflSalesvalues + totalBeerSalesValue,
    ];

    debugPrint('beerValues $beerValues');

    debugPrint('thousandOpBtlsCount444444 $thousandOpBtlsCount');

    if (isDailyStatement == true) {
      debugPrint('salesCumulative333 ${salesCumulative.last}');
      return [
        rowData,
        openingBtlCount,
        purchaseBtlCount,
        totalOpeningAndPurchaseBtlCount,
        totalClosingBtlCount,
        totalSalesBtlCount,
        totalValue,
        beerRowData,
        beerOpeningBtlCount,
        beerPurchaseBtlCount,
        totalBeerOpeningAndPurchaseBtlCount,
        totalBeerClosingBtlCount,
        totalBeerSalesBtlCount,
        totalBeerValue,
        ordinaryData,
        mediumData,
        premiumData,
        mediumTotalValue,
        totalMediumSalesBtlCount,
        totalMediumClosingBtlCount,
        totalMediumOpeningAndPurchaseBtlCount,
        mediumPurchaseBtlCount,
        mediumOpeningBtlCount,
        premiumOpeningBtlCount,
        premiumPurchaseBtlCount,
        totalPremiumOpeningAndPurchaseBtlCount,
        totalPremiumClosingBtlCount,
        totalPremiumSalesBtlCount,
        premiumTotalValue,
        totalOrdinaryOpeningValueList,
        totalMediumValueList,
        totalPremiumValueList,
        totalBeerValueList,
        salesCumulative,

        ordinaryOneEightyOpBtls,
        ordinaryThreeSeventyFiveOpBtls,
        ordinarySevenFiftyOpBtls,
        ordinaryOneThousandOpBtls,

        ordinaryOneEightyPurchaseBtls,
        ordinaryThreeSeventyFivePurchaseBtls,
        ordinarySevenFiftyPurchaseBtls,
        ordinaryOneThousandPurchaseBtls,

        ordinaryOneEightyOpeingAndPurchaseBtls,
        ordinaryThreeSeventyFiveOpeingAndPurchaseBtls,
        ordinarySevenFiftyOpeingAndPurchaseBtls,
        ordinaryOneThousandOpeingAndPurchaseBtls,

        ordinaryOneEightyClosingBtls,
        ordinaryThreeSeventyFiveClosingBtls,
        ordinarySevenFiftyClosingBtls,
        ordinaryOneThousandClosingBtls,

        ordinaryOneEightySalesBtls,
        ordinaryThreeSeventyFiveSalesBtls,
        ordinarySevenFiftySalesBtls,
        ordinaryOneThousandSalesBtls,

        ordinaryOneEightyTotalValues,
        ordinaryThreeSeventyFiveTotalValues,
        ordinarySevenFiftyTotalValues,
        ordinaryOneThousandTotalValues,

        mediumOneEightyOpBtls,
        mediumThreeSeventyFiveOpBtls,
        mediumSevenFiftyOpBtls,
        mediumOneThousandOpBtls,

        mediumOneEightyPurchaseBtls,
        mediumThreeSeventyFivePurchaseBtls,
        mediumSevenFiftyPurchaseBtls,
        mediumOneThousandPurchaseBtls,

        mediumOneEightyOpeingAndPurchaseBtls,
        mediumThreeSeventyFiveOpeingAndPurchaseBtls,
        mediumSevenFiftyOpeingAndPurchaseBtls,
        mediumOneThousandOpeingAndPurchaseBtls,

        mediumOneEightyClosingBtls,
        mediumThreeSeventyFiveClosingBtls,
        mediumSevenFiftyClosingBtls,
        mediumOneThousandClosingBtls,

        mediumOneEightySalesBtls,
        mediumThreeSeventyFiveSalesBtls,
        mediumSevenFiftySalesBtls,
        mediumOneThousandSalesBtls,

        mediumOneEightyTotalValues,
        mediumThreeSeventyFiveTotalValues,
        mediumSevenFiftyTotalValues,
        mediumOneThousandTotalValues,

        premiumOneEightyOpBtls,
        premiumThreeSeventyFiveOpBtls,
        premiumSevenFiftyOpBtls,
        premiumOneThousandOpBtls,

        premiumOneEightyPurchaseBtls,
        premiumThreeSeventyFivePurchaseBtls,
        premiumSevenFiftyPurchaseBtls,
        premiumOneThousandPurchaseBtls,

        premiumOneEightyOpeingAndPurchaseBtls,
        premiumThreeSeventyFiveOpeingAndPurchaseBtls,
        premiumSevenFiftyOpeingAndPurchaseBtls,
        premiumOneThousandOpeingAndPurchaseBtls,

        premiumOneEightyClosingBtls,
        premiumThreeSeventyFiveClosingBtls,
        premiumSevenFiftyClosingBtls,
        premiumOneThousandClosingBtls,

        premiumOneEightySalesBtls,
        premiumThreeSeventyFiveSalesBtls,
        premiumSevenFiftySalesBtls,
        premiumOneThousandSalesBtls,

        premiumOneEightyTotalValues,
        premiumThreeSeventyFiveTotalValues,
        premiumSevenFiftyTotalValues,
        premiumOneThousandTotalValues,

        posDatas!,

        [closingPdfFormat],
        productIds,
        totalOrdinaryLastRow,
        totalMediumLastRow,
        totalPremiumLastRow,

        bottleOpCountDetail,
        bottleReceiptCountDetail,
        bottleActualCountDetail,
        bottleClosingCountDetail,
        bottleSalesCountDetail,

        [sixFiftyOpBtlsCount, fiveHundredAndThreeTwentyFiveOpBtlsCount],
        [
          sixFiftyReceiptBtlsCount,
          fiveHundredAndThreeTwentyFiveReceiptBtlsCount,
        ],
        [sixFiftyActualBtlsCount, fiveHundredAndThreeTwentyFiveActualBtlsCount],
        [
          sixFiftyClosingBtlsCount,
          fiveHundredAndThreeTwentyFiveClosingBtlsCount,
        ],
        [sixFiftySalesBtlsCount, fiveHundredAndThreeTwentyFiveSalesBtlsCount],
        imflValues,
        beerValues,
        ImflAndBeerValues,
      ];
    } else {
      debugPrint('ordThreeSeventyFiveordThreeSeventyFive $ordThreeSeventyFive');
      debugPrint('ordSevenFifty $ordSevenFifty');

      debugPrint('prmOneEighty777 $prmOneEighty');

      debugPrint('opSummaryDataopSummaryData $opSummaryData');

      return [
        ordinaryFinalUniqueItems,
        ordOneEighty,
        ordThreeSeventyFive,
        ordSevenFifty,
        ordOneEightyLastRowData,
        ordThreeSevenFiveLastRowData,
        ordSevenFiftyLastRowData,

        mediumFinalUniqueItems,
        mdmOneEighty,
        mdmOneEightyLastRowData,
        mdmThreeSeventyFive,
        mdmThreeSevenFiveLastRowData,
        mdmSevenFifty,
        mdmSevenFiftyLastRowData,

        premiumFinalUniqueItems,
        prmOneEighty,
        prmOneEightyLastRowData,
        prmThreeSeventyFive,
        prmSevenFifty,

        beerFinalUniqueItems,
        beerThreeTwentyFive,
        beerFiveHundredFive,
        beerSixFiftyFive,
        opSummaryData,

        oneThousandFinalUniqueItems,
        ordinaryOneThousand,
        mediumOneThousand,
        premiumOneThousand,
        beerTrimmedBrandNameList,
        beerDatas,
        lengthOfBeerSizes,
      ];
    }
  }

  Future<List<String>> generatePassedDates(DateTime lastDateChanged) async {
    List<DateTime> passedDates = [];
    DateTime currentDate;
    List<String> formattedDates;

    if (lastDateChanged == null) {
      currentDate = DateTime.now();
    } else {
      currentDate = lastDateChanged;
    }

    DateTime firstDateOfMonth = DateTime(
      currentDate.year,
      currentDate.month,
      1,
    );

    if (currentDate == firstDateOfMonth) {
      String date = currentDate.toString().substring(0, 10);
      formattedDates = [date];
    } else {
      while (currentDate.isAfter(firstDateOfMonth)) {
        passedDates.add(currentDate);

        currentDate = currentDate.subtract(const Duration(days: 1));
      }

      passedDates.add(firstDateOfMonth);

      formattedDates = passedDates.map((e) {
        return DateFormat('yyyy-MM-dd').format(e);
      }).toList();
    }

    return formattedDates;
  }

  Future<String> getPdfFormat(int shopId) async {
    String pdfFormatName = 'default';

    DocumentReference formatRef = FirebaseFirestore.instance
        .collection('settings')
        .doc(shopId.toString());

    DocumentSnapshot formatSnapshot = await formatRef.get();

    if (formatSnapshot.exists) {
      Map<String, dynamic>? data =
          formatSnapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('closingPdfFormat')) {
        pdfFormatName = data['closingPdfFormat'];

        debugPrint('pdfFormatName444 $pdfFormatName');
      } else {
        debugPrint('clsoingPdfFormat not found or null in document');
      }
    } else {
      debugPrint('Document does not exist');
    }

    debugPrint('pdfFormatName $pdfFormatName');

    return pdfFormatName;
  }

  Future<List<dynamic>> filterPdfData(
    ordinaryTableData,
    mediumTableData,
    premiumTableData,
    closingPdfFormat,
    brandOrderDetails,
    beerTableData,
  ) async {
    debugPrint('ordinary table datas $ordinaryTableData');
    // debugPrint('beer table datas $beerTableData');
    debugPrint('closingPdfFormat filter $closingPdfFormat');

    debugPrint('beerTableData22 $beerTableData');

    final allDatas = [
      ordinaryTableData,
      mediumTableData,
      premiumTableData,
      beerTableData,
    ];

    List<dynamic> productOrder = brandOrderDetails
        .map((item) => item['productId'] as int)
        .toList();
    debugPrint('productIdOrder $productOrder');
    // allDatas.add(mediumTableData);
    debugPrint('all datasss $allDatas');

    final ordinaryOneEight = [];
    final mediumOneEight = [];
    final premiumOneEight = [];

    final ordinaryThreeSeventy = [];
    final mediumThreeSeventy = [];
    final premiumThreeSeventy = [];

    final ordinarySevenFifty = [];
    final mediumSevenFifty = [];
    final premiumSevenFifty = [];

    final ordinaryOneThousand = [];
    final mediumOneThousand = [];
    final premiumOneThousand = [];

    final beerSixFifty = [];
    final beerFiveHundred = [];
    final beerThreeTwentyFive = [];

    // FOR BRAND ORDER PDF FORMAT
    List<List<dynamic>> ordinaryDetails = [];
    List<List<dynamic>> mediumDetails = [];
    List<List<dynamic>> premiumDetails = [];
    List<List<dynamic>> beerDetails = [];

    List<List<dynamic>> ordinaryBrandOrder = [];
    List<List<dynamic>> mediumBrandOrder = [];
    List<List<dynamic>> premiumBrandOrder = [];
    List<List<dynamic>> beerBrandOrder = [];

    for (final val in allDatas) {
      debugPrint('valllll $val');
      for (final sublist in val) {
        if (sublist[3] == '180 ml' && sublist[4] == 'ORDINARY') {
          if (closingPdfFormat == 'size wise') {
            sublist.removeAt(4);
            sublist.removeAt(3);
            ordinaryOneEight.add(sublist);
            debugPrint('ordinary one eight ml $ordinaryOneEight');
          } else if (closingPdfFormat == 'default') {
            sublist[3] = 'Q';
            sublist.removeAt(4);
            ordinaryDetails.add(sublist);
          }
        } else if (sublist[3] == '375 ml' && sublist[4] == 'ORDINARY') {
          if (closingPdfFormat == 'size wise') {
            sublist.removeAt(4);
            sublist.removeAt(3);
            ordinaryThreeSeventy.add(sublist);
            debugPrint('ordinary 375 ml $ordinaryThreeSeventy');
          } else if (closingPdfFormat == 'default') {
            sublist[3] = 'H';
            sublist.removeAt(4);
            ordinaryDetails.add(sublist);
          }
        } else if (sublist[3] == '750 ml' && sublist[4] == 'ORDINARY') {
          if (closingPdfFormat == 'size wise') {
            sublist.removeAt(4);
            sublist.removeAt(3);
            ordinarySevenFifty.add(sublist);
            debugPrint('ordinary 750 ml $ordinarySevenFifty');
          } else if (closingPdfFormat == 'default') {
            sublist[3] = 'F';
            sublist.removeAt(4);
            ordinaryDetails.add(sublist);
          }
        } else if (sublist[3] == '1000 ml' && sublist[4] == 'ORDINARY') {
          if (closingPdfFormat == 'size wise') {
            sublist.removeAt(4);
            sublist.removeAt(3);
            ordinaryOneThousand.add(sublist);
          } else if (closingPdfFormat == 'default') {
            sublist[3] = 'L';
            sublist.removeAt(4);
            ordinaryDetails.add(sublist);
          }
        } else if (sublist[3] == '180 ml' && sublist[4] == 'MEDIUM') {
          if (closingPdfFormat == 'size wise') {
            sublist.removeAt(4);
            sublist.removeAt(3);
            mediumOneEight.add(sublist);
            debugPrint('mediumOneEightdddd$mediumOneEight');
          } else if (closingPdfFormat == 'default') {
            sublist[3] = 'Q';
            sublist.removeAt(4);
            mediumDetails.add(sublist);
          }
        } else if (sublist[3] == '375 ml' && sublist[4] == 'MEDIUM') {
          if (closingPdfFormat == 'size wise') {
            sublist.removeAt(4);
            sublist.removeAt(3);
            mediumThreeSeventy.add(sublist);
            debugPrint('mediumThreeSeventy$mediumThreeSeventy');
          } else if (closingPdfFormat == 'default') {
            sublist[3] = 'H';
            sublist.removeAt(4);
            mediumDetails.add(sublist);
          }
        } else if (sublist[3] == '750 ml' && sublist[4] == 'MEDIUM') {
          if (closingPdfFormat == 'size wise') {
            sublist.removeAt(4);
            sublist.removeAt(3);
            mediumSevenFifty.add(sublist);
            debugPrint('mediumSevenFifty$mediumSevenFifty');
          } else if (closingPdfFormat == 'default') {
            sublist[3] = 'F';
            sublist.removeAt(4);
            mediumDetails.add(sublist);
          }
        } else if (sublist[3] == '1000 ml' && sublist[4] == 'MEDIUM') {
          if (closingPdfFormat == 'size wise') {
            sublist.removeAt(4);
            sublist.removeAt(3);
            mediumOneThousand.add(sublist);
            debugPrint('mediumOneThousand$mediumOneThousand');
          } else if (closingPdfFormat == 'default') {
            sublist[3] = 'L';
            sublist.removeAt(4);
            mediumDetails.add(sublist);
          }
        } else if (sublist[3] == '180 ml' && sublist[4] == 'PREMIUM') {
          if (closingPdfFormat == 'size wise') {
            sublist.removeAt(4);
            sublist.removeAt(3);
            premiumOneEight.add(sublist);
            debugPrint('premiumOneEightdddd$premiumOneEight');
          } else if (closingPdfFormat == 'default') {
            sublist[3] = 'Q';
            sublist.removeAt(4);
            premiumDetails.add(sublist);
          }
        } else if (sublist[3] == '375 ml' && sublist[4] == 'PREMIUM') {
          if (closingPdfFormat == 'size wise') {
            sublist.removeAt(4);
            sublist.removeAt(3);
            premiumThreeSeventy.add(sublist);
            debugPrint('premiumThreeSeventy$premiumThreeSeventy');
          } else if (closingPdfFormat == 'default') {
            sublist[3] = 'H';
            sublist.removeAt(4);
            premiumDetails.add(sublist);
          }
        } else if (sublist[3] == '750 ml' && sublist[4] == 'PREMIUM') {
          if (closingPdfFormat == 'size wise') {
            sublist.removeAt(4);
            sublist.removeAt(3);
            premiumSevenFifty.add(sublist);
            debugPrint('premiumSevenFifty$premiumSevenFifty');
          } else if (closingPdfFormat == 'default') {
            sublist[3] = 'F';
            sublist.removeAt(4);
            premiumDetails.add(sublist);
          }
        } else if (sublist[3] == '1000 ml' && sublist[4] == 'PREMIUM') {
          if (closingPdfFormat == 'size wise') {
            sublist.removeAt(4);
            sublist.removeAt(3);
            premiumOneThousand.add(sublist);
            debugPrint('premiumOneThousand$premiumOneThousand');
          } else if (closingPdfFormat == 'default') {
            sublist[3] = 'L';
            sublist.removeAt(4);
            premiumDetails.add(sublist);
          }
        } else if (closingPdfFormat == 'default') {
          if (sublist[2] == '650 ml' && sublist[3] == 'BEER' ||
              sublist[3] == 'LEGAR BEER') {
            sublist[2] = 'F';
            beerDetails.add(sublist);
          } else if (sublist[2] == '500 ml' && sublist[3] == 'BEER' ||
              sublist[3] == 'LEGAR BEER' ||
              sublist[3] == 'CAN BEER') {
            sublist[2] = 'H';
            beerDetails.add(sublist);
          } else if (sublist[2] == '325 ml' && sublist[3] == 'BEER' ||
              sublist[3] == 'LEGAR BEER' ||
              sublist[3] == 'CAN BEER') {
            sublist[2] = 'C';
            beerDetails.add(sublist);
          }
        }
      }

      debugPrint("ordinaryDetails ordered $ordinaryDetails");
    }

    debugPrint('beerDetails4444 $beerDetails');

    ordinaryBrandOrder = await dataOrdering(productOrder, ordinaryDetails);

    mediumBrandOrder = await dataOrdering(productOrder, mediumDetails);

    premiumBrandOrder = await dataOrdering(productOrder, premiumDetails);

    beerBrandOrder = await dataOrdering(productOrder, beerDetails);

    debugPrint('ordinaryBrandOrder $ordinaryBrandOrder');

    debugPrint('beerBrandOrder22 $beerBrandOrder ');

    if (closingPdfFormat == 'size wise') {
      return [
        // 180 ml
        ordinaryOneEight, //0
        mediumOneEight, //1
        premiumOneEight, //2
        // 375 ml
        ordinaryThreeSeventy, // 3
        mediumThreeSeventy, // 4
        premiumThreeSeventy, // 5
        // 750 ml
        ordinarySevenFifty, // 6
        mediumSevenFifty, // 7
        premiumSevenFifty, // 8
        // 1000 ml
        ordinaryOneThousand, // 9
        mediumOneThousand, //10
        premiumOneThousand, //11
      ];
    } else if (closingPdfFormat == 'default') {
      return [
        ordinaryBrandOrder,
        mediumBrandOrder,
        premiumBrandOrder,
        beerBrandOrder,
      ];
    } else {
      return [
        ordinaryBrandOrder,
        mediumBrandOrder,
        premiumBrandOrder,
        beerBrandOrder,
      ];
    }
  }

  Future<List<List<dynamic>>> dataOrdering(
    productOrder,
    List<List<dynamic>> toOrderListDetails,
  ) async {
    debugPrint('Product Order Set: $productOrder');

    Map<int, List<dynamic>> detailsMap = {
      for (var subList in toOrderListDetails)
        int.tryParse(subList[0].toString()) ?? -1: subList,
    };

    // Use the productOrder to populate ordinaryBrandOrder
    List<List<dynamic>> ordinaryBrandOrder = productOrder
        .map((id) => detailsMap[id])
        .where((entry) => entry != null)
        .cast<List<dynamic>>()
        .toList();

    debugPrint('ordinaryBrandOrdereee $ordinaryBrandOrder');

    return ordinaryBrandOrder;
  }
}

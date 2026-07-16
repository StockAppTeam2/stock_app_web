import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stock_app_web/controllers/pos_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/brand_firestore_repo.dart';
import 'package:stock_app_web/core/repositories/firestore_repo.dart';
import 'package:stock_app_web/models/brand_model.dart';
import 'package:stock_app_web/models/items_table_model.dart';
import 'package:stock_app_web/models/sales_table_model.dart';

class SmsController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _fireRepo = getIt<FirestoreRepo>();
  final posController = getIt<PosController>();
  final _brandFirestoreRepo = getIt<BrandFirestoreRepo>();
  final _viewDateController = getIt<ViewDateController>();

  Future<List<List<dynamic>>> oneDayCalc() async {
    DateTime currentDate = DateTime.now();
    print('currentDatecurrentDate $currentDate');

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var shopId = prefs.getInt('shopId');
    int shopId = 3810;

    String value = await _viewDateController.getViewDateForUi();
    DateTime? lastDateChanged = DateTime.parse(value);
    // DateTime? lastDateChanged = await dateTimeController.getUserSelectedDate();

    List<String> dateList = await generatePassedDates(lastDateChanged);
    print('date00$dateList');

    String todayDate;
    DateTime date;
    DateTime currentSalesExDate;
    // date adjustment based date selection
    if (lastDateChanged == null) {
      currentSalesExDate = currentDate;
      todayDate = currentDate.toIso8601String().toString().substring(0, 10);
      date = currentDate;
      print('datedatevvv$date');
    } else {
      currentSalesExDate = lastDateChanged;
      todayDate = lastDateChanged.toIso8601String().substring(0, 10);
      date = lastDateChanged;
      print('datedate$date');
    }

    // NEW FIELDS
    int posBottle = 0;
    int ordSalesCases = 0;
    int preSalesCases = 0;
    int mdmSalesCases = 0;
    int beerSalesCases = 0;
    int posNumberOfBills = 0;
    int posNumberOfBottles = 0;
    int posImflSalesValues = 0;
    int posBeerSalesValues = 0;
    int posImflBottles = 0;
    int posBeerBottles = 0;

    // For sales

    int totalOrdSalesOneEightyBottle = 0;
    int totalOrdOneThousandBottle = 0;
    int totalOrdSevenFiftyBottle = 0;
    int totalOrdThreeTwentyFiveBottle = 0;

    int totalMdmSalesOneEightyBottle = 0;
    int totalMdmOneThousandBottle = 0;
    int totalMdmSevenFiftyBottle = 0;
    int totalMdmThreeTwentyFiveBottle = 0;

    int totalPreSalesOneEightyBottle = 0;
    int totalPreOneThousandBottle = 0;
    int totalPreSevenFiftyBottle = 0;
    int totalPreThreeTwentyFiveBottle = 0;

    int totalOneEightyBottle = 0;
    int totalOneThousandBottle = 0;
    int totalSevenFiftyBottle = 0;
    int totalSixFiftyBottle = 0;
    int totalFiveHundredBottle = 0;
    int totalSalesThreeTwentyFiveBottles = 0;
    int totalSalesFiveHunderedAndThreeTwentyFiveBottleCounts = 0;
    int totalThreeSeventyFiveBottle = 0;
    int totalSalesImflPrice = 0;

    // For closing
    int retail = 0;
    int totalRetails = 0;
    int totalClosingBeerPrice = 0;
    int totalClosingImflPrice = 0;
    int totalImflAndBeerPrice = 0;

    int totalClosingOdinaryBottle = 0;
    int roundedTotalOrdinaryCases = 0;

    int totalClosingMediumBottle = 0;
    int roundedTotalMediumCases = 0;

    int totalClosingPremiumBottle = 0;
    int roundedTotalPremiumCases = 0;

    int totalClosingBeerBottle = 0;
    int roundedTotalBeerCases = 0;
    int totalClosingBalance = 0;
    int totalClosingOneThousandBottle = 0;
    int totalClosingSevenFiftyBottle = 0;
    int totalClosingThreeSeventyFiveBottle = 0;
    int totalClosingOneEightyBottle = 0;
    int totalClosingSixFiftyBottle = 0;
    int totalClosingFiveHundredBottle = 0;
    int totalClosingThreeTwentyFiveBottle = 0;
    int totalFiveHundredAndThreeTwentyFiveBottleCount = 0;
    int totalOneMonthClosing = 0;
    int currentMonthSales = 0;
    int dummy = 0;
    int posMachineValuePerDay = 0;
    int posMonthlyCumulation = 0;
    int totalClosingBeerPriceMonth = 0;
    int totalClosingImflPriceMonth = 0;
    int totalClosingImflAndBeerPrice = 0;
    int totalClosing = 0;
    int monthSales = 0;
    int bankRemitance = 0;

    int totalSalesBeerPrice = 0;
    int totalBeerPrice = 0;
    int totalImflAndBeerSalesPrice = 0;

    //
    int totAdjustClosing = 0;

    // For range case calculation
    int totalOrdOneEightCasesCBValue = 0;
    int totalOrdThreeSeventyFiveCBValue = 0;
    int totalOrdSevenFiftyCBValue = 0;
    int totalOrdThousandCBValue = 0;
    int totalOrdCaseCBValue = 0;

    int totalMdmOneEightCasesCBValue = 0;
    int totalMdmThreeSeventyFiveCBValue = 0;
    int totalMdmSevenFiftyCBValue = 0;
    int totalMdmThousandCBValue = 0;
    int totalMdmCaseCBValue = 0;

    int totalPrmOneEightCasesCBValue = 0;
    int totalPrmThreeSeventyFiveCBValue = 0;
    int totalPrmSevenFiftyCBValue = 0;
    int totalPrmThousandCBValue = 0;
    int totalPreCaseCBValue = 0;

    int totalBeerSixFiftyCasesCBValue = 0;
    int totalBeerFiveHunderedCasesCBValue = 0;
    int totalBeerThreeTwentyFiveCasesCBValue = 0;
    int totalBeerCasesCBValue = 0;

    int roundedBeerSixFifyCases = 0;
    int roundedBeerfiveHundredAndThreeTwentyFiveCases = 0;

    int totalOneEightyClosingBottle = 0;
    double totalOneEightyCases = 0;
    int totalThreeSeventyFiveClosingBottle = 0;
    double totalThreeSevenTyFiveCases = 0;
    int totalSevenFiftyClosingBottle = 0;
    double totalSevenFiftyCases = 0;
    int totalOneThousandOrdinaryClosingBottle = 0;
    double totalOneThousandCases = 0;

    int totalOneEightyMediumClosingBottle = 0;
    double totalOneEightyMediumCases = 0;
    int totalThreeSeventyFiveMediumClosingBottle = 0;
    double totalThreeSevenTyFiveMediumCases = 0;
    int totalSevenFiftyMediumClosingBottle = 0;
    double totalSevenFiftyMediumCases = 0;
    int totalOneThousandMediumClosingBottle = 0;
    double totalOneThousandMediumCases = 0;

    int totalOneEightyPremiumClosingBottle = 0;
    double totalOneEightyPremiumCases = 0;
    int totalThreeSeventyFivePremiumClosingBottle = 0;
    double totalThreeSevenTyFivePremiumCases = 0;
    int totalSevenFiftyPremiumClosingBottle = 0;
    double totalSevenFiftyPremiumCases = 0;
    int totalOneThousandPremiumClosingBottle = 0;
    double totalOneThousandPremiumCases = 0;

    int totalSixFiftyBeerClosingBottle = 0;
    double totalSixFiftyBeerCases = 0;
    int totalFiveHundredBeerClosingBottle = 0;
    double totalFiveHundredBeerCases = 0;
    int totalThreeTwentyFiveBeerClosingBottle = 0;
    double totalThreeTwentyFiveBeerCases = 0;

    double totalOrdinaryCases = 0;

    // String todayDate = currentDate.toString().substring(0, 10);
    print('todayDate $todayDate');
    DocumentSnapshot saleInfo = await _firestore
        .collection('sales')
        .doc(shopId.toString())
        .collection('date')
        .doc(todayDate)
        .get();

    DocumentSnapshot closingInfo = await _firestore
        .collection('items')
        .doc(shopId.toString())
        .collection('date')
        .doc(todayDate)
        .get();

    // This for a one month closing data calculation
    DocumentSnapshot getAdjustmentValue = await _firestore
        .collection('items')
        .doc(shopId.toString())
        .collection('cumulative')
        .doc('cumulative')
        .get();

    Map<String, dynamic> adjustData =
        getAdjustmentValue.data() as Map<String, dynamic>;

    List<BrandModel> sqlBrandData = await _brandFirestoreRepo
        .getBrandCollection(shopId.toString());

    if (saleInfo.exists) {
      Map<String, dynamic> data = saleInfo.data() as Map<String, dynamic>;

      List<MapEntry<String, dynamic>> dataToList = data.entries.toList();

      List<SalesViewModel> salesViewModel = [];

      for (BrandModel brand in sqlBrandData) {
        for (final data in dataToList) {
          if (data.key == brand.productId.toString()) {
            Map<String, dynamic> nestedMap = data.value as Map<String, dynamic>;
            int? id;
            int? productId;
            int? phoneNumber;
            String? date;
            String? time;
            int? totalPriceSales;
            int? totalSalesRetailUnits;
            int? salesBundle;
            int? salesRetail;

            if (nestedMap.containsKey('bundle')) {
              id = nestedMap['id'];
              productId = nestedMap['productId'];
              phoneNumber = nestedMap['phoneNumber'];
              date = nestedMap['date'];
              time = nestedMap['time'];
              totalPriceSales = nestedMap['totalPrice'];
              totalSalesRetailUnits = nestedMap['totalSalesRetailUnits'];
              salesBundle = nestedMap['bundle'];
              salesRetail = nestedMap['retail'];
            } else {
              id = nestedMap['id'];
              productId = nestedMap['productId'];
              phoneNumber = nestedMap['phoneNumber'];
              date = nestedMap['date'];
              time = nestedMap['time'];
              totalPriceSales = nestedMap['totalPriceSales'];
              totalSalesRetailUnits = nestedMap['totalSalesRetailUnits'];
              salesBundle = nestedMap['salesBundle'];
              salesRetail = nestedMap['salesRetail'];
            }

            print('hi brand sales ${brand.productId}');
            //id !=null, productId !=null,phoneNumber !=null,date !=null,time !=null,totalPriceSales !=null,totalSalesRetailUnits !=null,salesBundle !=null,salesRetail !=null
            if (id != null) {
              SalesViewModel salesModel = SalesViewModel(
                id: id,
                productId: productId!,
                phoneNumber: phoneNumber!,
                date: date!,
                time: time!,
                category: brand.category,
                group: brand.groups,
                price: brand.price,
                totalPriceSales: totalPriceSales!,
                bottlePerBundle: brand.bottlePerBundle,
                totalSalesRetailUnits: totalSalesRetailUnits!,
                salesBundle: salesBundle!,
                salesRetail: salesRetail!,
                brand: brand.brand,
                size: brand.size,
                range: brand.range,
                isSynced: 0,
              );
              salesViewModel.add(salesModel);
            }
          }
        }
      }

      for (SalesViewModel salesData in salesViewModel) {
        String size = salesData.size;
        String salesGroup = salesData.group;
        int bottlePerBundle = salesData.bottlePerBundle;
        int totalRetailBottle = salesData.totalSalesRetailUnits;
        int totalSales = salesData.totalPriceSales;
        String range = salesData.range;

        if (size == '180 ml') {
          if (range == 'ORDINARY') {
            totalOrdSalesOneEightyBottle += totalRetailBottle;
          } else if (range == 'MEDIUM') {
            totalMdmSalesOneEightyBottle += totalRetailBottle;
          } else if (range == 'PREMIUM') {
            totalPreSalesOneEightyBottle += totalRetailBottle;
          }

          totalOneEightyBottle += totalRetailBottle;
        } else if (size == '1000 ml') {
          if (range == 'ORDINARY') {
            totalOrdOneThousandBottle += totalRetailBottle;
          } else if (range == 'MEDIUM') {
            totalMdmOneThousandBottle += totalRetailBottle;
          } else if (range == 'PREMIUM') {
            totalPreOneThousandBottle += totalRetailBottle;
          }
          totalOneThousandBottle += totalRetailBottle;
        } else if (size == '750 ml') {
          if (range == 'ORDINARY') {
            totalOrdSevenFiftyBottle += totalRetailBottle;
          } else if (range == 'MEDIUM') {
            totalMdmSevenFiftyBottle += totalRetailBottle;
          } else if (range == 'PREMIUM') {
            totalPreSevenFiftyBottle += totalRetailBottle;
          }
          totalSevenFiftyBottle += totalRetailBottle;
        } else if (size == '650 ml') {
          totalSixFiftyBottle += totalRetailBottle;
        } else if (size == '500 ml') {
          totalFiveHundredBottle += totalRetailBottle;
        } else if (size == '375 ml') {
          if (range == 'ORDINARY') {
            totalOrdThreeTwentyFiveBottle += totalRetailBottle;
          } else if (range == 'MEDIUM') {
            totalMdmThreeTwentyFiveBottle += totalRetailBottle;
          } else if (range == 'PREMIUM') {
            totalPreThreeTwentyFiveBottle += totalRetailBottle;
          }
          totalThreeSeventyFiveBottle += totalRetailBottle;
        } else if (size == '325 ml') {
          totalSalesThreeTwentyFiveBottles += totalRetailBottle;
        }

        // Adding 500 ml & 325 ml bottles
        totalSalesFiveHunderedAndThreeTwentyFiveBottleCounts =
            totalFiveHundredBottle + totalSalesThreeTwentyFiveBottles;
        // One day imfl sales price calc

        if (salesGroup == 'IMFL') {
          totalSalesImflPrice += totalSales;
          print('total imfl price $totalSalesImflPrice');
        }

        if (salesGroup == 'BEER') {
          totalSalesBeerPrice += totalSales;
          print('totalSalesBeerPrice $totalSalesBeerPrice');
        }

        totalImflAndBeerSalesPrice = totalSalesImflPrice + totalSalesBeerPrice;
      }
    } else {
      print('Sales doc not available');
    }

    // Closing Calculation
    if (closingInfo.exists) {
      Map<String, dynamic> data = closingInfo.data() as Map<String, dynamic>;

      List<MapEntry<String, dynamic>> dataToList = data.entries.toList();

      List<ItemsViewModel> itemsViewModel = [];

      for (BrandModel brand in sqlBrandData) {
        for (final data in dataToList) {
          if (data.key == brand.productId.toString()) {
            Map<String, dynamic> nestedMap = data.value as Map<String, dynamic>;
            int id = nestedMap['id'];
            int productId = nestedMap['productId'];
            int phoneNumber = nestedMap['phoneNumber'];
            String date = nestedMap['date'];
            String time = nestedMap['time'];
            int totalCloseRetailUnits = nestedMap['totalCloseRetailUnits'];
            int closingBundle = nestedMap['closingBundle'];
            int closingRetail = nestedMap['closingRetail'];
            int unscannedEntry = nestedMap['unscannedEntry'] ?? 0;

            print('hi brand items ${brand.productId}');
            ItemsViewModel itemsModel = ItemsViewModel(
              id: id,
              productId: productId,
              phoneNumber: phoneNumber,
              date: date,
              time: time,
              brand: brand.brand,
              itemsGroup: brand.groups,
              openingBundle: 0,
              openingRetail: 0,
              actualBundle: 0,
              actualRetail: 0,
              closingBundle: closingBundle,
              closingRetail: closingRetail,
              price: brand.price,
              bottlePerBundle: brand.bottlePerBundle,
              totalOpenRetailUnits: 0,
              totalCloseRetailUnits: totalCloseRetailUnits,
              totalActualRetailUnits: 0,
              totalPriceOpening: 0,
              totalPriceClosing: 0,
              totalPriceActual: 0,
              category: brand.category,
              range: brand.range,
              size: brand.size,
              isSynced: 0,
              unscannedEntry: unscannedEntry,
              checkOpeningCase: 0,
              checkOpeningBottle: 0,
              checkOpeningCaseBottle: 0,
              checkClosingCase: 0,
              checkClosingBottle: 0,
              checkClosingCaseBottle: 0,
              checkCurrentCase: 0,
              checkCurrentBottle: 0,
              checkCurrentCaseBottle: 0,
            );
            itemsViewModel.add(itemsModel);
          }
        }
      }

      for (ItemsViewModel data in itemsViewModel) {
        String itemGroup = data.itemsGroup;
        String closingRange = data.range;
        String closingSize = data.size;
        int bottlePerBundle = data.bottlePerBundle;
        int closingBundle = data.closingBundle;
        int closingRetail = data.closingRetail;
        int pricePerBottle = data.price;
        int totalClosingRetail = data.totalCloseRetailUnits;

        // DOUGHT NEED TO CLARIFY

        // retail = bottlePerBundle * closingBundle;
        // totalRetails = retail + closingRetail;
        // totalClosingBalance += totalRetails * pricePerBottle;
        // print('totalClosingBalance $totalClosingBalance');

        // Total beer and imfl price calculation per day

        if (itemGroup == 'BEER') {
          retail = bottlePerBundle * closingBundle;
          totalRetails = retail + closingRetail;
          totalClosingBeerPrice += totalRetails * pricePerBottle;
          totalClosingBeerBottle += totalRetails;
          print('totalClosingBeerBottle $totalClosingBeerBottle');
        } else if (itemGroup == 'IMFL') {
          retail = bottlePerBundle * closingBundle;
          totalRetails = retail + closingRetail;
          totalClosingImflPrice += totalRetails * pricePerBottle;
          totalImflAndBeerPrice = totalClosingImflPrice + totalClosingBeerPrice;
        }

        // Range Bottle calculation

        if (closingRange == 'ORDINARY') {
          if (closingSize == '180 ml') {
            totalOrdOneEightCasesCBValue += totalClosingRetail * pricePerBottle;
            totalOneEightyClosingBottle += totalClosingRetail;
            totalOneEightyCases = totalOneEightyClosingBottle / bottlePerBundle;
            print('totalOneEightyClosingBottle22 $totalOneEightyClosingBottle');
            print(
              'totalOrdOneEightCasesCBValue22 $totalOrdOneEightCasesCBValue',
            );
          } else if (closingSize == '375 ml') {
            totalOrdThreeSeventyFiveCBValue +=
                totalClosingRetail * pricePerBottle;
            totalThreeSeventyFiveClosingBottle += totalClosingRetail;
            int oneEightConverstion = totalThreeSeventyFiveClosingBottle * 2;
            totalThreeSevenTyFiveCases = oneEightConverstion / 48;

            print(
              'totalOrdThreeSeventyFiveCBValue33 $totalOrdThreeSeventyFiveCBValue',
            );
            // totalThreeSevenTyFiveCases =
            //     totalThreeSeventyFiveClosingBottle / bottlePerBundle;
          } else if (closingSize == '750 ml') {
            totalOrdSevenFiftyCBValue += totalClosingRetail * pricePerBottle;
            totalSevenFiftyClosingBottle += totalClosingRetail;
            int oneEightConverstion = totalSevenFiftyClosingBottle * 4;
            totalSevenFiftyCases = oneEightConverstion / 48;
            // totalSevenFiftyCases =
            //     totalSevenFiftyClosingBottle / bottlePerBundle;
            print('totalOrdSevenFiftyCBValue $totalOrdSevenFiftyCBValue');
            print('totalSevenFiftyCases 750 ml $totalSevenFiftyCases');
          } else if (closingSize == '1000 ml') {
            totalOrdThousandCBValue += totalClosingRetail * pricePerBottle;
            totalOneThousandOrdinaryClosingBottle += totalClosingRetail;
            int oneEightConverstion = totalOneThousandOrdinaryClosingBottle * 5;
            totalOneThousandCases = oneEightConverstion / 48;
            // totalOneThousandCases =
            //     totalOneThousandOrdinaryClosingBottle / bottlePerBundle;
            print('totalOrdThousandCBValue $totalOrdThousandCBValue');
          }
          // totalOrdCaseCBValue = totalOrdOneEightCasesCBValue +
          //     totalOrdThreeSeventyFiveCBValue +
          //     totalOrdSevenFiftyCBValue +
          //     totalOrdThousandCBValue;
          //
          // print('totalOrdCaseCBValue22 $totalOrdCaseCBValue');

          totalOrdCaseCBValue =
              totalOrdOneEightCasesCBValue +
              totalOrdThreeSeventyFiveCBValue +
              totalOrdSevenFiftyCBValue +
              totalOrdThousandCBValue;

          print('totalOrdCaseCBValue22 $totalOrdCaseCBValue');

          double totalOrdinaryCases =
              totalOneEightyCases +
              totalThreeSevenTyFiveCases +
              totalSevenFiftyCases +
              totalOneThousandCases;

          roundedTotalOrdinaryCases = totalOrdinaryCases.round();
          print('roundedTotalOrdinaryCases $roundedTotalOrdinaryCases');
        } else if (closingRange == 'MEDIUM') {
          if (closingSize == '180 ml') {
            totalMdmOneEightCasesCBValue += totalClosingRetail * pricePerBottle;
            totalOneEightyMediumClosingBottle += totalClosingRetail;
            print(
              'totalOneEightyMediumClosingBottle $totalOneEightyMediumClosingBottle',
            );
            totalOneEightyMediumCases =
                totalOneEightyMediumClosingBottle / bottlePerBundle;
          } else if (closingSize == '375 ml') {
            totalMdmThreeSeventyFiveCBValue +=
                totalClosingRetail * pricePerBottle;
            totalThreeSeventyFiveMediumClosingBottle += totalClosingRetail;
            print(
              'totalThreeSeventyFiveMediumClosingBottle $totalThreeSeventyFiveMediumClosingBottle',
            );
            int oneEightConverstion =
                totalThreeSeventyFiveMediumClosingBottle * 2;

            totalThreeSevenTyFiveMediumCases = oneEightConverstion / 48;

            // totalThreeSevenTyFiveMediumCases =
            //     totalThreeSeventyFiveMediumClosingBottle / bottlePerBundle;
          } else if (closingSize == '750 ml') {
            totalMdmSevenFiftyCBValue += totalClosingRetail * pricePerBottle;
            totalSevenFiftyMediumClosingBottle += totalClosingRetail;

            print(
              'totalSevenFiftyMediumClosingBottle $totalSevenFiftyMediumClosingBottle',
            );

            int oneEightConverstion = totalSevenFiftyMediumClosingBottle * 4;

            totalSevenFiftyMediumCases = oneEightConverstion / 48;

            // totalSevenFiftyMediumCases =
            //     totalSevenFiftyMediumClosingBottle / bottlePerBundle;
            print('totalSevenFiftyCases 750 ml $totalSevenFiftyCases');
          } else if (closingSize == '1000 ml') {
            totalMdmThousandCBValue += totalClosingRetail * pricePerBottle;
            totalOneThousandMediumClosingBottle += totalClosingRetail;

            print(
              'totalOneThousandMediumClosingBottle $totalOneThousandMediumClosingBottle',
            );

            int oneEightConverstion = totalOneThousandMediumClosingBottle * 5;

            totalOneThousandMediumCases = oneEightConverstion / 48;

            // totalOneThousandMediumCases =
            //     totalOneThousandMediumClosingBottle / bottlePerBundle;
          }

          totalMdmCaseCBValue =
              totalMdmOneEightCasesCBValue +
              totalMdmThreeSeventyFiveCBValue +
              totalMdmSevenFiftyCBValue +
              totalMdmThousandCBValue;

          print('totalMdmCaseCBValue555 $totalMdmCaseCBValue');

          double totalMediumCases =
              totalOneEightyMediumCases +
              totalThreeSevenTyFiveMediumCases +
              totalSevenFiftyMediumCases +
              totalOneThousandMediumCases;

          print('totalOneEightyMediumCases $totalOneEightyMediumCases');
          print(
            'totalThreeSevenTyFiveMediumCases $totalThreeSevenTyFiveMediumCases',
          );
          print('totalSevenFiftyMediumCases $totalSevenFiftyMediumCases');
          print('totalOneThousandMediumCases $totalOneThousandMediumCases');
          print('totalMediumCases $totalMediumCases');

          roundedTotalMediumCases = totalMediumCases.round();

          print('roundedTotalMediumCases $roundedTotalMediumCases');

          // retail = bottlePerBundle * closingBundle;
          // totalClosingMediumBottle += retail + closingRetail;
          //
        } else if (closingRange == 'PREMIUM') {
          if (closingSize == '180 ml') {
            totalPrmOneEightCasesCBValue += totalClosingRetail * pricePerBottle;
            totalOneEightyPremiumClosingBottle += totalClosingRetail;
            totalOneEightyPremiumCases =
                totalOneEightyPremiumClosingBottle / 48;
          } else if (closingSize == '375 ml') {
            totalPrmThreeSeventyFiveCBValue +=
                totalClosingRetail * pricePerBottle;
            totalThreeSeventyFivePremiumClosingBottle += totalClosingRetail;

            int oneEightConverstion =
                totalThreeSeventyFivePremiumClosingBottle * 2;

            totalThreeSevenTyFivePremiumCases = oneEightConverstion / 48;

            // totalThreeSevenTyFivePremiumCases =
            //     totalThreeSeventyFivePremiumClosingBottle / bottlePerBundle;
          } else if (closingSize == '750 ml') {
            totalPrmSevenFiftyCBValue += totalClosingRetail * pricePerBottle;
            totalSevenFiftyPremiumClosingBottle += totalClosingRetail;

            int oneEightConverstion = totalSevenFiftyPremiumClosingBottle * 4;

            totalSevenFiftyPremiumCases = oneEightConverstion / 48;

            // totalSevenFiftyPremiumCases =
            //     totalSevenFiftyPremiumClosingBottle / bottlePerBundle;
            print('totalSevenFiftyCases 750 ml $totalSevenFiftyCases');
          } else if (closingSize == '1000 ml') {
            totalPrmThousandCBValue += totalClosingRetail * pricePerBottle;
            totalOneThousandPremiumClosingBottle += totalClosingRetail;

            int oneEightConverstion = totalOneThousandPremiumClosingBottle * 5;

            totalOneThousandPremiumCases = oneEightConverstion / 48;

            // totalOneThousandPremiumCases =
            //     totalOneThousandPremiumClosingBottle / bottlePerBundle;
          }

          totalPreCaseCBValue =
              totalPrmOneEightCasesCBValue +
              totalPrmThreeSeventyFiveCBValue +
              totalPrmSevenFiftyCBValue +
              totalPrmThousandCBValue;

          print('totalPreCaseCBValue555 $totalPreCaseCBValue');

          double totalPremiumCases =
              totalOneEightyPremiumCases +
              totalThreeSevenTyFivePremiumCases +
              totalSevenFiftyPremiumCases +
              totalOneThousandPremiumCases;

          print('totalPremiumCases $totalPremiumCases');

          roundedTotalPremiumCases = totalPremiumCases.round();

          print('roundedTotalPremiumCases $roundedTotalPremiumCases');

          // retail = bottlePerBundle * closingBundle;
          // totalClosingPremiumBottle += retail + closingRetail;
        }

        //   Calculation for BEER cases

        if (itemGroup == 'BEER') {
          if (closingSize == '650 ml') {
            totalBeerSixFiftyCasesCBValue +=
                totalClosingRetail * pricePerBottle;
            totalSixFiftyBeerClosingBottle += totalClosingRetail;
            print(
              'totalSixFiftyBeerClosingBottle 650 ml $totalSixFiftyBeerClosingBottle',
            );

            int x = totalSixFiftyBeerClosingBottle * 2;

            totalSixFiftyBeerCases = x / 24;
            print('totalSixFiftyBeerCases $totalSixFiftyBeerCases');
          } else if (closingSize == '500 ml') {
            totalBeerFiveHunderedCasesCBValue +=
                totalClosingRetail * pricePerBottle;
            totalFiveHundredBeerClosingBottle += totalClosingRetail;
            print(
              'totalFiveHundredBeerClosingBottle $totalFiveHundredBeerClosingBottle',
            );

            totalFiveHundredBeerCases =
                totalFiveHundredBeerClosingBottle / bottlePerBundle;
            print('totalFiveHundredBeerCases$totalFiveHundredBeerCases');
          } else if (closingSize == '325 ml') {
            totalBeerThreeTwentyFiveCasesCBValue +=
                totalClosingRetail * pricePerBottle;
            totalThreeTwentyFiveBeerClosingBottle += totalClosingRetail;

            totalThreeTwentyFiveBeerCases =
                totalThreeTwentyFiveBeerClosingBottle / bottlePerBundle;
          }

          totalBeerCasesCBValue =
              totalBeerSixFiftyCasesCBValue +
              totalBeerFiveHunderedCasesCBValue +
              totalBeerThreeTwentyFiveCasesCBValue;

          print('totalBeerFiveCasesCBValue6666 $totalBeerCasesCBValue');

          double totalBeerCases =
              totalSixFiftyBeerCases +
              totalFiveHundredBeerCases +
              totalThreeTwentyFiveBeerCases;

          double totlaSixFiftyBeerCase = totalSixFiftyBeerCases;

          double totalFiveHundredAndThreeTwentyFive =
              totalFiveHundredBeerCases + totalThreeTwentyFiveBeerCases;

          roundedBeerSixFifyCases = totlaSixFiftyBeerCase.round();

          roundedBeerfiveHundredAndThreeTwentyFiveCases =
              totalFiveHundredAndThreeTwentyFive.round();

          roundedTotalBeerCases = totalBeerCases.round();
        }

        // Size Bottle Calculation
        if (closingSize == '1000 ml') {
          retail = bottlePerBundle * closingBundle;
          totalClosingOneThousandBottle += retail + closingRetail;
        } else if (closingSize == '750 ml') {
          retail = bottlePerBundle * closingBundle;
          totalClosingSevenFiftyBottle += retail + closingRetail;
          print('totalClosingSevenFiftyBottle $totalClosingSevenFiftyBottle');
        } else if (closingSize == '375 ml') {
          retail = bottlePerBundle * closingBundle;
          totalClosingThreeSeventyFiveBottle += retail + closingRetail;
        } else if (closingSize == '180 ml') {
          retail = bottlePerBundle * closingBundle;
          totalClosingOneEightyBottle += retail + closingRetail;
        } else if (closingSize == '650 ml' && itemGroup == 'BEER') {
          retail = bottlePerBundle * closingBundle;
          totalClosingSixFiftyBottle += retail + closingRetail;
        } else if (closingSize == '500 ml' && itemGroup == 'BEER') {
          retail = bottlePerBundle * closingBundle;
          totalClosingFiveHundredBottle += retail + closingRetail;
        } else if (closingSize == '325 ml' && itemGroup == 'BEER') {
          retail = bottlePerBundle * closingBundle;
          totalClosingThreeTwentyFiveBottle += retail + closingRetail;
        }

        // Adding 500 ml & 325 ml bottles
        totalFiveHundredAndThreeTwentyFiveBottleCount =
            totalClosingFiveHundredBottle + totalClosingThreeTwentyFiveBottle;
      }
    }

    // Last ONE DAY CLOSING BALANCE
    List<String> currentDay = [todayDate];
    print('currentDay $currentDay');
    for (String docId in currentDay) {
      print('docId333 $docId');
      DocumentSnapshot oneMonthInfo = await _firestore
          .collection('items')
          .doc(shopId.toString())
          .collection('date')
          .doc(docId)
          .get();

      if (oneMonthInfo.exists) {
        Map<String, dynamic> data = oneMonthInfo.data() as Map<String, dynamic>;

        // getting adjustment closing value
        int adjustClosingBalanceCumulation =
            adjustData['closingBalanceAdjustment'] ?? 0;
        // print('adjustClosingBalance $adjustClosingBalanceCumulation');
        int adjustBeerAtShopCumulation =
            adjustData['beerAtShopAdjustment'] ?? 0;
        int adjustImflAndBeerAtShopCumulation =
            adjustData['imflAndBeerAtShopAdjustment'] ?? 0;

        // Condition for effective date null check
        if (adjustData.containsKey('lastDateOfMonth')) {
          Timestamp adjustmentVariableLastDate = adjustData['lastDateOfMonth'];

          DateTime lastDateAdjustmentVariable = adjustmentVariableLastDate
              .toDate();

          List<MapEntry<String, dynamic>> dataToList = data.entries.toList();

          List<ItemsViewModel> itemsViewModel = [];

          for (BrandModel brand in sqlBrandData) {
            for (final data in dataToList) {
              if (data.key == brand.productId.toString()) {
                Map<String, dynamic> nestedMap =
                    data.value as Map<String, dynamic>;
                int id = nestedMap['id'];
                int productId = nestedMap['productId'];
                int phoneNumber = nestedMap['phoneNumber'];
                String date = nestedMap['date'];
                String time = nestedMap['time'];
                int closingBundle = nestedMap['closingBundle'];
                int closingRetail = nestedMap['closingRetail'];
                int totalCloseRetailUnits = nestedMap['totalCloseRetailUnits'];
                int unscannedEntry = nestedMap['unscannedEntry'] ?? 0;
                print('hi brand items one day ${brand.productId}');
                ItemsViewModel itemsModel = ItemsViewModel(
                  id: id,
                  productId: productId,
                  phoneNumber: phoneNumber,
                  date: date,
                  time: time,
                  brand: brand.brand,
                  itemsGroup: brand.groups,
                  openingBundle: 0,
                  openingRetail: 0,
                  actualBundle: 0,
                  actualRetail: 0,
                  closingBundle: closingBundle,
                  closingRetail: closingRetail,
                  price: brand.price,
                  bottlePerBundle: brand.bottlePerBundle,
                  totalOpenRetailUnits: 0,
                  totalCloseRetailUnits: totalCloseRetailUnits,
                  totalActualRetailUnits: 0,
                  totalPriceOpening: 0,
                  totalPriceClosing: 0,
                  totalPriceActual: 0,
                  category: brand.category,
                  range: brand.range,
                  size: brand.size,
                  isSynced: 0,
                  unscannedEntry: unscannedEntry,
                  checkOpeningCase: 0,
                  checkOpeningBottle: 0,
                  checkOpeningCaseBottle: 0,
                  checkClosingCase: 0,
                  checkClosingBottle: 0,
                  checkClosingCaseBottle: 0,
                  checkCurrentCase: 0,
                  checkCurrentBottle: 0,
                  checkCurrentCaseBottle: 0,
                );
                itemsViewModel.add(itemsModel);
              }
            }
          }

          for (ItemsViewModel data in itemsViewModel) {
            String closingGroup = data.itemsGroup;
            int bottlePerBundle = data.bottlePerBundle;
            int totalCloseRetailUnits = data.totalCloseRetailUnits;

            int closingBundle = data.closingBundle;
            int closingRetail = data.closingRetail;
            int pricePerBottle = data.price;

            // Skipping negative value here
            if (closingBundle.isNegative || closingRetail.isNegative) {
              break;
            }

            // Condition for adjustment variable value effective check
            if (date.isAfter(lastDateAdjustmentVariable)) {
              print('################################1');
              // This will execute when lastDateAdjustmentVariable passed
              int adjustClosingBalanceCumulation = 0;
              int adjustBeerAtShopCumulation = 0;
              int adjustImflAndBeerAtShopCumulation = 0;

              // retail = bottlePerBundle * closingBundle;
              // totalRetails = retail + closingRetail;
              // // Total closing balance with adjustment value

              totalClosing += totalCloseRetailUnits * pricePerBottle;

              totalOneMonthClosing =
                  totalClosing + adjustClosingBalanceCumulation;

              print('totalOneMonthClosing222 $totalOneMonthClosing');

              if (closingGroup == 'BEER' || closingGroup == 'beer') {
                retail = bottlePerBundle * closingBundle;
                totalRetails = retail + closingRetail;
                totalBeerPrice += totalRetails * pricePerBottle;
                totalClosingBeerPriceMonth =
                    totalBeerPrice + adjustBeerAtShopCumulation;
              } else if (closingGroup == 'IMFL' || closingGroup == 'imfl') {
                retail = bottlePerBundle * closingBundle;
                totalRetails = retail + closingRetail;
                totalClosingImflPriceMonth += totalRetails * pricePerBottle;
                totalClosingImflAndBeerPrice =
                    totalBeerPrice +
                    totalClosingImflPriceMonth +
                    adjustImflAndBeerAtShopCumulation;
              } else if (closingGroup != 'BEER' || closingGroup != 'beer') {
                totalClosingBeerPriceMonth = adjustBeerAtShopCumulation;
              } else if (closingGroup != 'IMFL' || closingGroup != 'imfl') {
                totalClosingImflAndBeerPrice =
                    adjustImflAndBeerAtShopCumulation;
              }
            } else if (date.isBefore(lastDateAdjustmentVariable)) {
              print('################################2');
              // This block will execute lastDateAdjustmentVariable is before current date
              retail = bottlePerBundle * closingBundle;
              totalRetails = retail + closingRetail;
              // Total closing balance with adjustment value

              totalClosing += totalCloseRetailUnits * pricePerBottle;

              totalOneMonthClosing =
                  totalClosing + adjustClosingBalanceCumulation;
              print('totalOneMonthClosing $totalOneMonthClosing');

              if (closingGroup == 'BEER' || closingGroup == 'beer') {
                retail = bottlePerBundle * closingBundle;
                totalRetails = retail + closingRetail;
                totalBeerPrice += totalRetails * pricePerBottle;
                totalClosingBeerPriceMonth =
                    totalBeerPrice + adjustBeerAtShopCumulation;
              } else if (closingGroup == 'IMFL' || closingGroup == 'imfl') {
                retail = bottlePerBundle * closingBundle;
                totalRetails = retail + closingRetail;
                totalClosingImflPriceMonth += totalRetails * pricePerBottle;
                totalClosingImflAndBeerPrice =
                    totalBeerPrice +
                    totalClosingImflPriceMonth +
                    adjustImflAndBeerAtShopCumulation;
              } else if (closingGroup != 'BEER' || closingGroup != 'beer') {
                totalClosingBeerPriceMonth = adjustBeerAtShopCumulation;
              } else if (closingGroup != 'IMFL' || closingGroup != 'imfl') {
                totalClosingImflAndBeerPrice =
                    adjustImflAndBeerAtShopCumulation;
              }
            }
          }
          totalClosingImflAndBeerPrice =
              totalClosingBeerPriceMonth + totalClosingImflPriceMonth;
          print(
            'totalClosingImflAndBeerPric333e $totalClosingImflAndBeerPrice xx ',
          );
          print('totalBeerPrice $totalBeerPrice');
        } else {
          print('Field not available');
        }
      }
    }

    // This is for one month sales calculation

    for (String docId in dateList) {
      print('docIddocId $docId');
      DocumentSnapshot oneMonthSaleInfo = await _firestore
          .collection('sales')
          .doc(shopId.toString())
          .collection('date')
          .doc(docId)
          .get();

      if (oneMonthSaleInfo.exists) {
        Map<String, dynamic> data =
            oneMonthSaleInfo.data() as Map<String, dynamic>;

        int adjustSalesCumulation;

        Timestamp lastDate = adjustData['lastDateOfMonth'];
        DateTime salesAdjustmentExpireDate = lastDate.toDate();

        if (currentSalesExDate.isAfter(salesAdjustmentExpireDate)) {
          adjustSalesCumulation = 0;
        } else {
          adjustSalesCumulation = adjustData['salesAdjustment'];
        }

        Map<String, dynamic> singleData =
            data.values.first as Map<String, dynamic>;
        if (singleData.containsKey('totalPrice')) {
          data.forEach((productId, productData) {
            int totalPrice = productData['totalPrice'] ?? 0;
            monthSales += totalPrice;
            currentMonthSales = adjustSalesCumulation + monthSales;
          });
        } else {
          data.forEach((productId, productData) {
            int totalPrice = productData['totalPriceSales'] ?? 0;
            monthSales += totalPrice;
            currentMonthSales = adjustSalesCumulation + monthSales;
          });
        }
      }
    }

    // POS VALUE FUNC
    // final posDatas =
    //     await posController.getPosDataUsingDateInFirebase(todayDate);

    // SALES CASE CALCULATION

    //   ORDINARY
    double ordOneEightySalesCases = totalOrdSalesOneEightyBottle / 48;
    double ordThreeSeventyCaseConversion = totalOrdThreeTwentyFiveBottle * 2;
    double ordThreeSeventySalesCases = ordThreeSeventyCaseConversion / 48;
    double ordSevenFiftyCaseConvertion = totalOrdSevenFiftyBottle * 4;
    double ordSevenFiftySalesCases = ordSevenFiftyCaseConvertion / 48;
    double ordOneThousandCaseConvertion = totalOrdOneThousandBottle * 5;
    double ordOneThousandSalesCases = ordOneThousandCaseConvertion / 48;

    // MEDIUM
    double mdmOneEightySalesCases = totalMdmSalesOneEightyBottle / 48;
    double mdmThreeSeventyCaseConversion = totalMdmThreeTwentyFiveBottle * 2;
    double mdmThreeSeventySalesCases = mdmThreeSeventyCaseConversion / 48;
    double mdmSevenFiftyCaseConvertion = totalMdmSevenFiftyBottle * 4;
    double mdmSevenFiftySalesCases = mdmSevenFiftyCaseConvertion / 48;
    double mdmOneThousandCaseConvertion = totalMdmOneThousandBottle * 5;
    double mdmOneThousandSalesCases = mdmOneThousandCaseConvertion / 48;

    // PREMIUM
    double preOneEightySalesCases = totalPreSalesOneEightyBottle / 48;
    double preThreeSeventyCaseConversion = totalPreThreeTwentyFiveBottle * 2;
    double preThreeSeventySalesCases = preThreeSeventyCaseConversion / 48;
    double preSevenFiftyCaseConvertion = totalPreSevenFiftyBottle * 4;
    double preSevenFiftySalesCases = preSevenFiftyCaseConvertion / 48;
    double preOneThousandCaseConvertion = totalPreOneThousandBottle * 5;
    double preOneThousandSalesCases = preOneThousandCaseConvertion / 48;

    // BEER SALES CASES
    double beerSixFifityCaseConversion = totalSixFiftyBottle * 2;
    double beerSixFiftySalesCases = beerSixFifityCaseConversion / 24;

    int totalFiveTwentyFiveAndThreeTwentyFiveBeerBottles =
        totalFiveHundredBottle + totalSalesThreeTwentyFiveBottles;

    double beerBothSalesCases =
        totalFiveTwentyFiveAndThreeTwentyFiveBeerBottles / 24;

    double totalBeerSalesCases = beerSixFiftySalesCases + beerBothSalesCases;

    double totalOrdSalesCases =
        ordOneEightySalesCases +
        ordThreeSeventySalesCases +
        ordSevenFiftySalesCases +
        ordOneThousandSalesCases;

    double totalMdmSalesCases =
        mdmOneEightySalesCases +
        mdmThreeSeventySalesCases +
        mdmSevenFiftySalesCases +
        mdmOneThousandSalesCases;

    double totalPreSalesCases =
        preOneEightySalesCases +
        preThreeSeventySalesCases +
        preSevenFiftySalesCases +
        preOneThousandSalesCases;

    // SALES CASES FINAL RETURN
    ordSalesCases = totalOrdSalesCases.round();
    mdmSalesCases = totalMdmSalesCases.round();
    preSalesCases = totalPreSalesCases.round();
    beerSalesCases = totalBeerSalesCases.round();

    print('beerSixFiftySalesCases , $beerSixFiftySalesCases');
    print(
      'totalFiveTwentyFiveAndThreeTwentyFiveBeerBottles , $totalFiveTwentyFiveAndThreeTwentyFiveBeerBottles',
    );
    print('beerBothSalesCases , $beerBothSalesCases');
    print('totalBeerSalesCases , $totalBeerSalesCases');
    print('totalBeerSalesCases round , ${totalBeerSalesCases.round()}');

    print('totalOrdSalesCasesssss $totalOrdSalesCases');
    print('totalMdmSalesCases $totalMdmSalesCases');
    print('totalPreSalesCases $totalPreSalesCases');
    print('totalOrdSalesCasesssss round ${totalOrdSalesCases.round()}');
    print('totalMdmSalesCases round ${totalMdmSalesCases.round()}');
    print('totalPreSalesCases round ${totalPreSalesCases.round()}');

    print('totalOrdSalesOneEightyBottle, $totalOrdSalesOneEightyBottle');
    print('totalOrdOneThousandBottle, $totalOrdOneThousandBottle');
    print('totalOrdSevenFiftyBottle, $totalOrdSevenFiftyBottle');
    print('totalOrdThreeTwentyFiveBottle, $totalOrdThreeTwentyFiveBottle');
    print('totalMdmSalesOneEightyBottle, $totalMdmSalesOneEightyBottle');
    print('totalMdmOneThousandBottle, $totalMdmOneThousandBottle');
    print('totalMdmSevenFiftyBottle, $totalMdmSevenFiftyBottle');
    print('totalMdmThreeTwentyFiveBottle, $totalMdmThreeTwentyFiveBottle');
    print('totalPreSalesOneEightyBottle, $totalPreSalesOneEightyBottle');
    print('totalPreOneThousandBottle, $totalPreOneThousandBottle');
    print('totalPreSevenFiftyBottle, $totalPreSevenFiftyBottle');
    print('totalPreThreeTwentyFiveBottle, $totalPreThreeTwentyFiveBottle');

    print('totalOneEightyBottle, $totalOneEightyBottle');
    print('totalOneThousandBottle, $totalOneThousandBottle');
    print('totalSevenFiftyBottle, $totalSevenFiftyBottle');
    print('totalSixFiftyBottle, $totalSixFiftyBottle');
    print('totalFiveHundredBottle, $totalFiveHundredBottle');
    print(
      'totalSalesThreeTwentyFiveBottles, $totalSalesThreeTwentyFiveBottles',
    );
    print(
      'totalSalesFiveHunderedAndThreeTwentyFiveBottleCounts, $totalSalesFiveHunderedAndThreeTwentyFiveBottleCounts',
    );
    print('totalThreeSeventyFiveBottle, $totalThreeSeventyFiveBottle');

    // final posDetails = await posController.getAllPosDataUsingMonthAndYear(
    //   todayDate,
    // );
    final posDetails = await posController.readAllItemsFirestoreUsingDate(
      todayDate,
    );

    for (var pos in posDetails) {
      posBottle = pos.posNumberOfBottles;
      posNumberOfBills = pos.posNumberOfBills;
      posNumberOfBottles = pos.posNumberOfBottles;
      posImflSalesValues = pos.posImflSalesValue;
      posBeerSalesValues = pos.posBeerSalesValue;
      posImflBottles = pos.posImflBottles;
      posBeerBottles = pos.posBeerBottles;
      posMachineValuePerDay = pos.posValue;
      posMonthlyCumulation = pos.posCumulative;
      print('ID: ${pos.id}');
      print('posValue: ${pos.posValue}');
      print('posNumberOfBottles: ${pos.posNumberOfBottles}');
      print('posNumberOfBills: ${pos.posNumberOfBills}');
      print('posImflBottles: ${pos.posImflBottles}');
      print('posBeerBottles: ${pos.posBeerBottles}');
      print('posImflSalesValue: ${pos.posImflSalesValue}');
      print('posBeerSalesValue: ${pos.posBeerSalesValue}');
      print('posCumulative: ${pos.posCumulative}');
      print('posDate: ${pos.posDate}');
    }

    bankRemitance = totalImflAndBeerSalesPrice - posMachineValuePerDay;

    return [
      [totalOneThousandBottle, '1000 ml'],
      [totalSevenFiftyBottle, '750 ml'],
      [totalSixFiftyBottle, '650 ml Beer'],
      [totalSalesFiveHunderedAndThreeTwentyFiveBottleCounts, '500 ml Din Beer'],
      // totalFiveHundredBottle,
      [totalThreeSeventyFiveBottle, '375 ml'],
      [totalOneEightyBottle, '180 ml'],
      [totalSalesImflPrice, 'Total IMFL Price'],
      [totalSalesBeerPrice, 'Total BEER Price'],
      [totalImflAndBeerSalesPrice, 'Total IMFL & BEER Price'],
      [roundedTotalOrdinaryCases, 'Total ORDINARY Cases'],
      [roundedTotalMediumCases, 'Total MEDIUM Cases'],
      [roundedTotalPremiumCases, 'Total PREMIUM Cases'],
      [roundedTotalBeerCases, 'Total BEER Cases'],
      [totalOneMonthClosing, 'Total Closing Balance'],
      [dummy, '90 Days Qty'],
      [currentMonthSales, 'Last 30 Days Sales'],
      [posMachineValuePerDay, 'POS Machine Value/Day'],
      [posMonthlyCumulation, 'POS Monthly Cumulation'],
      // add
      [totalClosingOneThousandBottle, '1000 ml Bottle Quantity'],
      [totalClosingSevenFiftyBottle, '750 ml Bottle Quantity'],
      [totalClosingThreeSeventyFiveBottle, '375 ml Qty'],
      [totalClosingBeerPriceMonth, 'Total BEER at Shop'],
      [totalClosingImflAndBeerPrice, 'Total IMFL & BEER at Shop'],
      // totalOneMonthClosing,
      [totalClosingOneEightyBottle, '180 ml CB Bottle Qty'],
      [totalClosingSixFiftyBottle, '650 ml BEER Bottle Qty'],
      [totalFiveHundredAndThreeTwentyFiveBottleCount, '500 ml BEER Bottle Qty'],
      // totalClosingFiveHundredBottle,
      [totalClosingImflPrice, 'Total IMFL Stock in Shop'],
      //   Extra datas
      [totalSalesThreeTwentyFiveBottles, '325 ml BEER Sales'],
      [totalFiveHundredBottle, '500 ml BEER Sales'],
      [totalClosingThreeTwentyFiveBottle, '325 ml BEER CB Bottle Qty'],
      [totalClosingFiveHundredBottle, '500 ml BEER CB Bottle Qty'],
      [bankRemitance, 'Bank Remitance'],
      [totalOrdCaseCBValue, 'CB ORDINARY value in Rs'],
      [totalMdmCaseCBValue, 'CB MEDIUM value in Rs'],
      [totalPreCaseCBValue, 'CB PREMIUM value in Rs'],
      [totalBeerCasesCBValue, 'CB BEER value in Rs'],
      [posBottle, 'POS Bottles'],
      [roundedBeerSixFifyCases, 'BEER 650 ml Cases'],
      [
        roundedBeerfiveHundredAndThreeTwentyFiveCases,
        'BEER 500 ml/ 325 ml Cases',
      ],
      [ordSalesCases, 'ORDINARY Sales Cases'],
      [mdmSalesCases, 'MEDIUM Sales Cases'],
      [preSalesCases, 'PREMIUM Sales Cases'],
      [beerSalesCases, 'BEER Sales Cases'],
      [posNumberOfBills, 'POS Number of bills'],
      [posNumberOfBottles, 'POS Number of Bottles'],
      [posImflSalesValues, 'POS IMFL Sales Value'],
      [posBeerSalesValues, 'POS BEER Sales Value'],
      [posImflBottles, 'POS IMFL Bottles'],
      [posBeerBottles, 'POS BEER Bottles'],
    ];
  }

  Future<List<String>> generatePassedDates(DateTime? lastDateChanged) async {
    List<DateTime> _passedDates = [];
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
        _passedDates.add(currentDate);

        currentDate = currentDate.subtract(const Duration(days: 1));
      }
      final c = _passedDates.length;

      _passedDates.add(firstDateOfMonth);

      formattedDates = _passedDates.map((e) {
        return DateFormat('yyyy-MM-dd').format(e);
      }).toList();
    }

    return formattedDates;
  }

  Future<List<dynamic>> getSmsFormat(int shopId) async {
    List<dynamic> format = [];

    bool removeFirstStarSms = false;
    bool removeEndStarSms = false;

    DocumentReference smsInfo = _firestore
        .collection('settings')
        .doc(shopId.toString());

    DocumentSnapshot smsSnapShot = await smsInfo.get();

    DocumentReference smsListInfo = _firestore
        .collection('settings')
        .doc('smsFormats');

    DocumentSnapshot smsListSnapShot = await smsListInfo.get();

    Map<String, dynamic>? formatData =
        smsListSnapShot.data() as Map<String, dynamic>;

    if (smsSnapShot.exists) {
      Map<String, dynamic>? data = smsSnapShot.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('smsFormat')) {
        String smsFormatName = smsSnapShot.get('smsFormat');
        print('smsFormatName $smsFormatName');

        if (formatData != null && formatData.containsKey(smsFormatName)) {
          format = smsListSnapShot.get(smsFormatName);
        } else {
          format = smsListSnapShot.get('default');
        }
      } else {
        format = smsListSnapShot.get('default');
      }

      if (data != null &&
          data.containsKey('removeFirstStarSms') &&
          data.containsKey('removeEndStarSms')) {
        removeFirstStarSms = smsSnapShot.get('removeFirstStarSms');
        removeEndStarSms = smsSnapShot.get('removeEndStarSms');
      }
    }
    print('smsFormat $format');
    return [format, removeFirstStarSms, removeEndStarSms];
  }
}

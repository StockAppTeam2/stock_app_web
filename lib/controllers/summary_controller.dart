import 'package:collection/collection.dart';
import 'package:stock_app_web/controllers/opening_page_controller.dart';
import 'package:stock_app_web/controllers/receipt_controller.dart';
import 'package:stock_app_web/controllers/sales_page_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/models/inward_table_model.dart';
import 'package:stock_app_web/models/items_table_model.dart';
import 'package:stock_app_web/models/sales_table_model.dart';

class SummaryController {
  final _viewDateController = getIt<ViewDateController>();
  final openingController = getIt<OpeningPageController>();
  final inwardController = getIt<ReceiptController>();
  final salesController = getIt<SalesPageController>();

  Future<List<List<List<String>>>> data() async {
    String viewDate = await _viewDateController.getViewDateForUi();
    String shopId = await getIt<ShopIdController>().getShopId();
    List<ItemsViewModel> itemsTableData = await openingController
        .getOpeningData(viewDate, shopId);

    List<SalesViewModel> saleTableData = await salesController.getSalesData(
      viewDate,
      shopId,
    );

    List<InwardViewModel> inwardTableData = await inwardController
        .getInwardData(viewDate, shopId);

    print('vvvv $itemsTableData');

    int totalPriceOdinaryOpening = 0;
    int totalPriceOdinaryClosing = 0;
    int totalPriceOrdinarySales = 0;
    int totalPriceOrdinaryReciept = 0;
    int totalPriceOrdinaryActual = 0;

    int totalPriceMediumOpening = 0;
    int totalPriceMediumReciept = 0;
    int totalPriceMediumActual = 0;
    int totalPriceMediumSales = 0;
    int totalPriceMediumClosing = 0;

    int totalPricePremiumOpening = 0;
    int totalPricePremiumReciept = 0;
    int totalPricePremiumActual = 0;
    int totalPricePremiumSales = 0;
    int totalPricePremiumClosing = 0;

    int totalPriceImflOpening = 0;
    int totalPriceImflReciept = 0;
    int totalPriceImflActual = 0;
    int totalPriceImflSales = 0;
    int totalPriceImflClosing = 0;

    int totalPriceBeerOpening = 0;
    int totalPriceBeerReciept = 0;
    int totalPriceBeerActual = 0;
    int totalPriceBeerSales = 0;
    int totalPriceBeerClosing = 0;

    int totalPriceImflAndBeerOpening = 0;
    int totalPriceImflAndBeerReciept = 0;
    int totalPriceImflAndBeerActual = 0;
    int totalPriceImflAndBeerSales = 0;
    int totalPriceImflAndBeerClosing = 0;

    int thousandOp = 0;
    int thousandRecpt = 0;
    int thousandActual = 0;
    int thousandSales = 0;
    int thousandCB = 0;

    int sevenFiftyOp = 0;
    int sevenFiftyRecpt = 0;
    int sevenFiftyActual = 0;
    int sevenFiftySales = 0;
    int sevenFiftyCB = 0;

    int threeSevenFiveOp = 0;
    int threeSevenFiveRecpt = 0;
    int threeSevenFiveActual = 0;
    int threeSevenFiveSales = 0;
    int threeSevenFiveCB = 0;

    int oneEightyOp = 0;
    int oneEightyRecpt = 0;
    int oneEightyActual = 0;
    int oneEightySales = 0;
    int oneEightyCB = 0;

    int sixFiftyOp = 0;
    int sixFiftyRecpt = 0;
    int sixFiftyActual = 0;
    int sixFiftySales = 0;
    int sixFiftyCB = 0;

    int fiveHundredOp = 0;
    int fiveHundredRecpt = 0;
    int fiveHundredActual = 0;
    int fiveHundredSales = 0;
    int fiveHundredCB = 0;

    int threeTwentyFiveOp = 0;
    int threeTwentyFiveRecpt = 0;
    int threeTwentyFiveActual = 0;
    int threeTwentyFiveSales = 0;
    int threeTwentyFiveCB = 0;

    int thousandOpOrd = 0;
    int thousandActualOrd = 0;
    int thousandCBOrd = 0;
    int thousandInOrd = 0;
    int sevenFiftyOpOrd = 0;
    int sevenFiftyActualOrd = 0;
    int sevenFiftyCBOrd = 0;
    int sevenFiftyInOrd = 0;
    int threeSevenFiveOpOrd = 0;
    int threeSevenFiveActualOrd = 0;
    int threeSevenFiveCBOrd = 0;
    int threeSevenFiveInOrd = 0;
    int oneEightyOpOrd = 0;
    int oneEightyActualOrd = 0;
    int oneEightyCBOrd = 0;
    int oneEightyInOrd = 0;

    int thousandOpMdm = 0;
    int thousandActualMdm = 0;
    int thousandCBMdm = 0;
    int thousandInMdm = 0;
    int sevenFiftyOpMdm = 0;
    int sevenFiftyActualMdm = 0;
    int sevenFiftyCBMdm = 0;
    int sevenFiftyInMdm = 0;
    int threeSevenFiveOpMdm = 0;
    int threeSevenFiveActualMdm = 0;
    int threeSevenFiveCBMdm = 0;
    int threeSevenFiveInMdm = 0;
    int oneEightyOpMdm = 0;
    int oneEightyActualMdm = 0;
    int oneEightyCBMdm = 0;
    int oneEightyInMdm = 0;

    int thousandOpPrm = 0;
    int thousandActualPrm = 0;
    int thousandCBPrm = 0;
    int thousandInPrm = 0;
    int sevenFiftyOpPrm = 0;
    int sevenFiftyActualPrm = 0;
    int sevenFiftyCBPrm = 0;
    int sevenFiftyInPrm = 0;
    int threeSevenFiveOpPrm = 0;
    int threeSevenFiveActualPrm = 0;
    int threeSevenFiveCBPrm = 0;
    int threeSevenFiveInPrm = 0;
    int oneEightyOpPrm = 0;
    int oneEightyActualPrm = 0;
    int oneEightyCBPrm = 0;
    int oneEightyInPrm = 0;

    //IMFL
    int thousandOpImfl = 0;
    int thousandActualImfl = 0;
    int thousandCBImfl = 0;
    int thousandInImfl = 0;
    int sevenFiftyOpImfl = 0;
    int sevenFiftyActualImfl = 0;
    int sevenFiftyCBImfl = 0;
    int sevenFiftyInImfl = 0;
    int threeSevenFiveOpImfl = 0;
    int threeSevenFiveActualImfl = 0;
    int threeSevenFiveCBImfl = 0;
    int threeSevenFiveInImfl = 0;
    int oneEightyOpImfl = 0;
    int oneEightyActualImfl = 0;
    int oneEightyCBImfl = 0;
    int oneEightyInImfl = 0;

    //BEER
    int sixFiftyOpBeer = 0;
    int sixFiftyActualBeer = 0;
    int sixFiftyCBBeer = 0;
    int sixFiftyInBeer = 0;
    int fiveHundredOpBeer = 0;
    int fiveHundredActualBeer = 0;
    int fiveHundredCBBeer = 0;
    int fiveHundredInBeer = 0;
    int threeTwentyFiveOpBeer = 0;
    int threeTwentyFiveActualBeer = 0;
    int threeTwentyFiveCBBeer = 0;
    int threeTwentyFiveInBeer = 0;

    int thousandSalesOrd = 0;
    int sevenFiftySalesOrd = 0;
    int threeSevenFiveSalesOrd = 0;
    int oneEightySalesOrd = 0;
    int thousandSalesMdm = 0;
    int sevenFiftySalesMdm = 0;
    int threeSevenFiveSalesMdm = 0;
    int oneEightySalesMdm = 0;
    int thousandSalesPrm = 0;
    int sevenFiftySalesPrm = 0;
    int threeSevenFiveSalesPrm = 0;
    int oneEightySalesPrm = 0;

    int thousandSalesImfl = 0;
    int sevenFiftySalesImfl = 0;
    int threeSevenFiveSalesImfl = 0;
    int oneEightySalesImfl = 0;

    int sixFiftySalesBeer = 0;
    int fiveHundredSalesBeer = 0;
    int threeTwentyFiveSalesBeer = 0;

    for (final val in itemsTableData) {
      String itemsGroup = val.itemsGroup;
      String Itemsrange = val.range;
      String ItemsSize = val.size;

      if (ItemsSize == '1000 ml') {
        thousandOp += val.totalOpenRetailUnits;
        thousandActual += val.totalActualRetailUnits;
        thousandCB += val.totalCloseRetailUnits;
      }

      if (ItemsSize == '750 ml') {
        sevenFiftyOp += val.totalOpenRetailUnits;
        sevenFiftyActual += val.totalActualRetailUnits;
        sevenFiftyCB += val.totalCloseRetailUnits;
      }

      if (ItemsSize == '375 ml') {
        threeSevenFiveOp += val.totalOpenRetailUnits;
        threeSevenFiveActual += val.totalActualRetailUnits;
        threeSevenFiveCB += val.totalCloseRetailUnits;
      }

      if (ItemsSize == '180 ml') {
        oneEightyOp += val.totalOpenRetailUnits;
        oneEightyActual += val.totalActualRetailUnits;
        oneEightyCB += val.totalCloseRetailUnits;
      }

      if (ItemsSize == '650 ml') {
        sixFiftyOp += val.totalOpenRetailUnits;
        sixFiftyActual += val.totalActualRetailUnits;
        sixFiftyCB += val.totalCloseRetailUnits;
      }

      if (ItemsSize == '500 ml') {
        fiveHundredOp += val.totalOpenRetailUnits;
        fiveHundredActual += val.totalActualRetailUnits;
        fiveHundredCB += val.totalCloseRetailUnits;
      }

      if (ItemsSize == '325 ml') {
        threeTwentyFiveOp += val.totalOpenRetailUnits;
        threeTwentyFiveActual += val.totalActualRetailUnits;
        threeTwentyFiveCB += val.totalCloseRetailUnits;
      }

      if (itemsGroup == 'IMFL' && Itemsrange == 'ORDINARY') {
        totalPriceOdinaryOpening += val.totalPriceOpening;
        totalPriceOdinaryClosing += val.totalPriceClosing;
        totalPriceOrdinaryActual += val.totalPriceActual;

        if (ItemsSize == '1000 ml') {
          thousandOpOrd += val.totalOpenRetailUnits;
          thousandActualOrd += val.totalActualRetailUnits;
          thousandCBOrd += val.totalCloseRetailUnits;
        }

        if (ItemsSize == '750 ml') {
          sevenFiftyOpOrd += val.totalOpenRetailUnits;
          sevenFiftyActualOrd += val.totalActualRetailUnits;
          sevenFiftyCBOrd += val.totalCloseRetailUnits;
        }

        if (ItemsSize == '375 ml') {
          threeSevenFiveOpOrd += val.totalOpenRetailUnits;
          threeSevenFiveActualOrd += val.totalActualRetailUnits;
          threeSevenFiveCBOrd += val.totalCloseRetailUnits;
        }

        if (ItemsSize == '180 ml') {
          oneEightyOpOrd += val.totalOpenRetailUnits;
          oneEightyActualOrd += val.totalActualRetailUnits;
          oneEightyCBOrd += val.totalCloseRetailUnits;
        }
      }

      if (itemsGroup == 'IMFL' && Itemsrange == 'MEDIUM') {
        totalPriceMediumOpening += val.totalPriceOpening;
        totalPriceMediumClosing += val.totalPriceClosing;
        totalPriceMediumActual += val.totalPriceActual;

        if (ItemsSize == '1000 ml') {
          thousandOpMdm += val.totalOpenRetailUnits;
          thousandActualMdm += val.totalActualRetailUnits;
          thousandCBMdm += val.totalCloseRetailUnits;
        }

        if (ItemsSize == '750 ml') {
          sevenFiftyOpMdm += val.totalOpenRetailUnits;
          sevenFiftyActualMdm += val.totalActualRetailUnits;
          sevenFiftyCBMdm += val.totalCloseRetailUnits;
        }

        if (ItemsSize == '375 ml') {
          threeSevenFiveOpMdm += val.totalOpenRetailUnits;
          threeSevenFiveActualMdm += val.totalActualRetailUnits;
          threeSevenFiveCBMdm += val.totalCloseRetailUnits;
        }

        if (ItemsSize == '180 ml') {
          oneEightyOpMdm += val.totalOpenRetailUnits;
          oneEightyActualMdm += val.totalActualRetailUnits;
          oneEightyCBMdm += val.totalCloseRetailUnits;
        }
      }

      if (itemsGroup == 'IMFL' && Itemsrange == 'PREMIUM') {
        totalPricePremiumOpening += val.totalPriceOpening;
        totalPricePremiumClosing += val.totalPriceClosing;
        totalPricePremiumActual += val.totalPriceActual;

        if (ItemsSize == '1000 ml') {
          thousandOpPrm += val.totalOpenRetailUnits;
          thousandActualPrm += val.totalActualRetailUnits;
          thousandCBPrm += val.totalCloseRetailUnits;
        }

        if (ItemsSize == '750 ml') {
          sevenFiftyOpPrm += val.totalOpenRetailUnits;
          sevenFiftyActualPrm += val.totalActualRetailUnits;
          sevenFiftyCBPrm += val.totalCloseRetailUnits;
        }

        if (ItemsSize == '375 ml') {
          threeSevenFiveOpPrm += val.totalOpenRetailUnits;
          threeSevenFiveActualPrm += val.totalActualRetailUnits;
          threeSevenFiveCBPrm += val.totalCloseRetailUnits;
        }

        if (ItemsSize == '180 ml') {
          oneEightyOpPrm += val.totalOpenRetailUnits;
          oneEightyActualPrm += val.totalActualRetailUnits;
          oneEightyCBPrm += val.totalCloseRetailUnits;
        }
      }

      if (itemsGroup == 'IMFL') {
        totalPriceImflOpening += val.totalPriceOpening;
        totalPriceImflClosing += val.totalPriceClosing;
        totalPriceImflActual += val.totalPriceActual;

        if (ItemsSize == '1000 ml') {
          thousandOpImfl += val.totalOpenRetailUnits;
          thousandActualImfl += val.totalActualRetailUnits;
          thousandCBImfl += val.totalCloseRetailUnits;
        }

        if (ItemsSize == '750 ml') {
          sevenFiftyOpImfl += val.totalOpenRetailUnits;
          sevenFiftyActualImfl += val.totalActualRetailUnits;
          sevenFiftyCBImfl += val.totalCloseRetailUnits;
        }

        if (ItemsSize == '375 ml') {
          threeSevenFiveOpImfl += val.totalOpenRetailUnits;
          threeSevenFiveActualImfl += val.totalActualRetailUnits;
          threeSevenFiveCBImfl += val.totalCloseRetailUnits;
        }

        if (ItemsSize == '180 ml') {
          oneEightyOpImfl += val.totalOpenRetailUnits;
          oneEightyActualImfl += val.totalActualRetailUnits;
          print(
            "🎆 oneEightyActualImfl $oneEightyActualImfl ${val.productId} ${val.totalActualRetailUnits}",
          );
          oneEightyCBImfl += val.totalCloseRetailUnits;
        }
      }

      if (itemsGroup == 'BEER') {
        totalPriceBeerOpening += val.totalPriceOpening;
        totalPriceBeerClosing += val.totalPriceClosing;
        totalPriceBeerActual += val.totalPriceActual;

        if (ItemsSize == '650 ml') {
          sixFiftyOpBeer += val.totalOpenRetailUnits;
          sixFiftyActualBeer += val.totalActualRetailUnits;
          sixFiftyCBBeer += val.totalCloseRetailUnits;
        }

        if (ItemsSize == '500 ml') {
          fiveHundredOpBeer += val.totalOpenRetailUnits;
          fiveHundredActualBeer += val.totalActualRetailUnits;
          fiveHundredCBBeer += val.totalCloseRetailUnits;
        }

        if (ItemsSize == '325 ml') {
          threeTwentyFiveOpBeer += val.totalOpenRetailUnits;
          threeTwentyFiveActualBeer += val.totalActualRetailUnits;
          threeTwentyFiveCBBeer += val.totalCloseRetailUnits;
        }
      }
    }

    for (final val in saleTableData) {
      String salesGroup = val.group;
      String salesrange = val.range;
      String salesSize = val.size;

      if (salesSize == '1000 ml') {
        thousandSales += val.totalSalesRetailUnits;
      }

      if (salesSize == '750 ml') {
        sevenFiftySales += val.totalSalesRetailUnits;
      }

      if (salesSize == '375 ml') {
        threeSevenFiveSales += val.totalSalesRetailUnits;
      }
      if (salesSize == '180 ml') {
        oneEightySales += val.totalSalesRetailUnits;
      }
      if (salesSize == '650 ml') {
        sixFiftySales += val.totalSalesRetailUnits;
      }
      if (salesSize == '500 ml') {
        fiveHundredSales += val.totalSalesRetailUnits;
      }
      if (salesSize == '325 ml') {
        threeTwentyFiveSales += val.totalSalesRetailUnits;
      }

      if (salesGroup == 'IMFL' && salesrange == 'ORDINARY') {
        totalPriceOrdinarySales += val.totalPriceSales;

        if (salesSize == '1000 ml') {
          thousandSalesOrd += val.totalSalesRetailUnits;
        }

        if (salesSize == '750 ml') {
          sevenFiftySalesOrd += val.totalSalesRetailUnits;
        }

        if (salesSize == '375 ml') {
          threeSevenFiveSalesOrd += val.totalSalesRetailUnits;
        }
        if (salesSize == '180 ml') {
          oneEightySalesOrd += val.totalSalesRetailUnits;
          print('oneEightySalesOrd $oneEightySalesOrd');
        }
      }

      if (salesGroup == 'IMFL' && salesrange == 'MEDIUM') {
        totalPriceMediumSales += val.totalPriceSales;

        if (salesSize == '1000 ml') {
          thousandSalesMdm += val.totalSalesRetailUnits;
        }

        if (salesSize == '750 ml') {
          sevenFiftySalesMdm += val.totalSalesRetailUnits;
        }

        if (salesSize == '375 ml') {
          threeSevenFiveSalesMdm += val.totalSalesRetailUnits;
        }
        if (salesSize == '180 ml') {
          oneEightySalesMdm += val.totalSalesRetailUnits;
        }
      }

      if (salesGroup == 'IMFL' && salesrange == 'PREMIUM') {
        totalPricePremiumSales += val.totalPriceSales;

        if (salesSize == '1000 ml') {
          thousandSalesPrm += val.totalSalesRetailUnits;
        }

        if (salesSize == '750 ml') {
          sevenFiftySalesPrm += val.totalSalesRetailUnits;
        }

        if (salesSize == '375 ml') {
          threeSevenFiveSalesPrm += val.totalSalesRetailUnits;
        }
        if (salesSize == '180 ml') {
          oneEightySalesPrm += val.totalSalesRetailUnits;
        }
      }

      if (salesGroup == 'IMFL') {
        totalPriceImflSales += val.totalPriceSales;

        if (salesSize == '1000 ml') {
          thousandSalesImfl += val.totalSalesRetailUnits;
        }

        if (salesSize == '750 ml') {
          sevenFiftySalesImfl += val.totalSalesRetailUnits;
        }

        if (salesSize == '375 ml') {
          threeSevenFiveSalesImfl += val.totalSalesRetailUnits;
        }
        if (salesSize == '180 ml') {
          oneEightySalesImfl += val.totalSalesRetailUnits;
        }
      }

      if (salesGroup == 'BEER') {
        totalPriceBeerSales += val.totalPriceSales;

        if (salesSize == '650 ml') {
          sixFiftySalesBeer += val.totalSalesRetailUnits;
        }
        if (salesSize == '500 ml') {
          fiveHundredSalesBeer += val.totalSalesRetailUnits;
        }
        if (salesSize == '325 ml') {
          threeTwentyFiveSalesBeer += val.totalSalesRetailUnits;
        }
      }
    }

    for (final val in inwardTableData) {
      String inwardGroup = val.inwardGroup;
      String inwardrange = val.range;
      String inwardSize = val.size;

      if (inwardSize == '1000 ml') {
        thousandRecpt += val.totalInwardRetailUnits;
      }

      if (inwardSize == '750 ml') {
        sevenFiftyRecpt += val.totalInwardRetailUnits;
      }
      if (inwardSize == '375 ml') {
        threeSevenFiveRecpt += val.totalInwardRetailUnits;
      }
      if (inwardSize == '180 ml') {
        oneEightyRecpt += val.totalInwardRetailUnits;
      }
      if (inwardSize == '650 ml') {
        sixFiftyRecpt += val.totalInwardRetailUnits;
      }
      if (inwardSize == '500 ml') {
        fiveHundredRecpt += val.totalInwardRetailUnits;
      }
      if (inwardSize == '325 ml') {
        threeTwentyFiveRecpt += val.totalInwardRetailUnits;
      }

      if (inwardGroup == 'IMFL' && inwardrange == 'ORDINARY') {
        totalPriceOrdinaryReciept += val.totalPriceInward;

        if (inwardSize == '1000 ml') {
          thousandInOrd += val.totalInwardRetailUnits;
        }

        if (inwardSize == '750 ml') {
          sevenFiftyInOrd += val.totalInwardRetailUnits;
        }

        if (inwardSize == '375 ml') {
          threeSevenFiveInOrd += val.totalInwardRetailUnits;
        }

        if (inwardSize == '180 ml') {
          oneEightyInOrd += val.totalInwardRetailUnits;
        }
      }

      if (inwardGroup == 'IMFL' && inwardrange == 'MEDIUM') {
        totalPriceMediumReciept += val.totalPriceInward;

        if (inwardSize == '1000 ml') {
          thousandInMdm += val.totalInwardRetailUnits;
        }

        if (inwardSize == '750 ml') {
          sevenFiftyInMdm += val.totalInwardRetailUnits;
        }

        if (inwardSize == '375 ml') {
          threeSevenFiveInMdm += val.totalInwardRetailUnits;
        }

        if (inwardSize == '180 ml') {
          oneEightyInMdm += val.totalInwardRetailUnits;
        }
      }

      if (inwardGroup == 'IMFL' && inwardrange == 'PREMIUM') {
        totalPricePremiumReciept += val.totalPriceInward;

        if (inwardSize == '1000 ml') {
          thousandInPrm += val.totalInwardRetailUnits;
        }

        if (inwardSize == '750 ml') {
          sevenFiftyInPrm += val.totalInwardRetailUnits;
        }

        if (inwardSize == '375 ml') {
          threeSevenFiveInPrm += val.totalInwardRetailUnits;
        }

        if (inwardSize == '180 ml') {
          oneEightyInPrm += val.totalInwardRetailUnits;
        }
      }

      if (inwardGroup == 'IMFL') {
        totalPriceImflReciept += val.totalPriceInward;

        if (inwardSize == '1000 ml') {
          thousandInImfl += val.totalInwardRetailUnits;
        }

        if (inwardSize == '750 ml') {
          sevenFiftyInImfl += val.totalInwardRetailUnits;
        }

        if (inwardSize == '375 ml') {
          threeSevenFiveInImfl += val.totalInwardRetailUnits;
        }

        if (inwardSize == '180 ml') {
          oneEightyInImfl += val.totalInwardRetailUnits;
        }
      }

      if (inwardGroup == 'BEER') {
        totalPriceBeerReciept += val.totalPriceInward;

        if (inwardSize == '650 ml') {
          sixFiftyInBeer += val.totalInwardRetailUnits;
        }

        if (inwardSize == '500 ml') {
          fiveHundredInBeer += val.totalInwardRetailUnits;
        }

        if (inwardSize == '325 ml') {
          threeTwentyFiveInBeer += val.totalInwardRetailUnits;
        }
      }
    }

    totalPriceImflAndBeerOpening =
        totalPriceImflOpening + totalPriceBeerOpening;
    totalPriceImflAndBeerReciept =
        totalPriceImflReciept + totalPriceBeerReciept;
    totalPriceImflAndBeerActual = totalPriceImflActual + totalPriceBeerActual;
    totalPriceImflAndBeerSales = totalPriceImflSales + totalPriceBeerSales;
    totalPriceImflAndBeerClosing =
        totalPriceImflClosing + totalPriceBeerClosing;

    print('totalPriceOpeningSum $totalPriceOdinaryOpening');
    print('totalPriceOdinaryClosing $totalPriceOdinaryClosing');
    print('totalPriceOrdinaryActual $totalPriceOrdinaryActual');
    print('totalPriceOrdinarySales $totalPriceOrdinarySales');
    print('totalPriceOrdinaryReciept $totalPriceOrdinaryReciept');
    List<String> row1 = [
      'OP',
      oneEightyOp.toString(),
      threeSevenFiveOp.toString(),
      sevenFiftyOp.toString(),
      thousandOp.toString(),
      sixFiftyOp.toString(),
      fiveHundredOp.toString(),
      threeTwentyFiveOp.toString(),
    ];
    List<String> row2 = [
      'RECEIPT',
      oneEightyRecpt.toString(),
      threeSevenFiveRecpt.toString(),
      sevenFiftyRecpt.toString(),
      thousandRecpt.toString(),
      sixFiftyRecpt.toString(),
      fiveHundredRecpt.toString(),
      threeTwentyFiveRecpt.toString(),
    ];
    List<String> row3 = [
      'TOTAL',
      oneEightyActual.toString(),
      threeSevenFiveActual.toString(),
      sevenFiftyActual.toString(),
      thousandActual.toString(),
      sixFiftyActual.toString(),
      fiveHundredActual.toString(),
      threeTwentyFiveActual.toString(),
    ];
    List<String> row4 = [
      'SALES',
      oneEightySales.toString(),
      threeSevenFiveSales.toString(),
      sevenFiftySales.toString(),
      thousandSales.toString(),
      sixFiftySales.toString(),
      fiveHundredSales.toString(),
      threeTwentyFiveSales.toString(),
    ];
    List<String> row5 = [
      'CB',
      oneEightyCB.toString(),
      threeSevenFiveCB.toString(),
      sevenFiftyCB.toString(),
      thousandCB.toString(),
      sixFiftyCB.toString(),
      fiveHundredCB.toString(),
      threeTwentyFiveCB.toString(),
    ];

    List<String> data = [
      // ORDINARY
      totalPriceOdinaryOpening.toString(),
      totalPriceOrdinaryReciept.toString(),
      totalPriceOrdinaryActual.toString(),
      totalPriceOrdinarySales.toString(),
      totalPriceOdinaryClosing.toString(),
      // MEDIUM
      totalPriceMediumOpening.toString(),
      totalPriceMediumReciept.toString(),
      totalPriceMediumActual.toString(),
      totalPriceMediumSales.toString(),
      totalPriceMediumClosing.toString(),
      //   PREMIUM
      totalPricePremiumOpening.toString(),
      totalPricePremiumReciept.toString(),
      totalPricePremiumActual.toString(),
      totalPricePremiumSales.toString(),
      totalPricePremiumClosing.toString(),
      //   IMFL
      totalPriceImflOpening.toString(),
      totalPriceImflReciept.toString(),
      totalPriceImflActual.toString(),
      totalPriceImflSales.toString(),
      totalPriceImflClosing.toString(),
      //   BEER
      totalPriceBeerOpening.toString(),
      totalPriceBeerReciept.toString(),
      totalPriceBeerActual.toString(),
      totalPriceBeerSales.toString(),
      totalPriceBeerClosing.toString(),
      //   IMFL + BEER
      totalPriceImflAndBeerOpening.toString(),
      totalPriceImflAndBeerReciept.toString(),
      totalPriceImflAndBeerActual.toString(),
      totalPriceImflAndBeerSales.toString(),
      totalPriceImflAndBeerClosing.toString(),
    ];

    int totalActualOrdBtls =
        oneEightyActualOrd +
        thousandActualOrd +
        sevenFiftyActualOrd +
        threeSevenFiveActualOrd;
    int totalSalesOrdBtls =
        thousandSalesOrd +
        sevenFiftySalesOrd +
        threeSevenFiveSalesOrd +
        oneEightySalesOrd;
    int totalCbOrdBtls =
        thousandCBOrd + sevenFiftyCBOrd + threeSevenFiveCBOrd + oneEightyCBOrd;

    int totalActualMdmBtls =
        oneEightyActualMdm +
        threeSevenFiveActualMdm +
        sevenFiftyActualMdm +
        thousandActualMdm;
    int totalSalesMdmBtls =
        thousandSalesMdm +
        sevenFiftySalesMdm +
        threeSevenFiveSalesMdm +
        oneEightySalesMdm;
    int totalCbMdmBtls =
        thousandCBMdm + sevenFiftyCBMdm + threeSevenFiveCBMdm + oneEightyCBMdm;

    int totalActaulPrmBtls =
        oneEightyActualPrm +
        threeSevenFiveActualPrm +
        sevenFiftyActualPrm +
        thousandActualPrm;
    int totalSalesPrmBtls =
        thousandSalesPrm +
        sevenFiftySalesPrm +
        threeSevenFiveSalesPrm +
        oneEightySalesPrm;
    int totalCbPrmBtls =
        thousandCBPrm + sevenFiftyCBPrm + threeSevenFiveCBPrm + oneEightyCBPrm;

    // ORDINARY TABLE DATA
    List<String> ordRow1 = [
      'OB',
      oneEightyActualOrd.toString(),
      threeSevenFiveActualOrd.toString(),
      sevenFiftyActualOrd.toString(),
      thousandActualOrd.toString(),
      totalActualOrdBtls.toString(),
      totalPriceOrdinaryActual.toString(),
    ];

    List<String> ordRow2 = [
      'SALES',
      oneEightySalesOrd.toString(),
      threeSevenFiveSalesOrd.toString(),
      sevenFiftySalesOrd.toString(),
      thousandSalesOrd.toString(),
      totalSalesOrdBtls.toString(),
      totalPriceOrdinarySales.toString(),
    ];

    List<String> ordRow3 = [
      'CB',
      oneEightyCBOrd.toString(),
      threeSevenFiveCBOrd.toString(),
      sevenFiftyCBOrd.toString(),
      thousandCBOrd.toString(),
      totalCbOrdBtls.toString(),
      totalPriceOdinaryClosing.toString(),
    ];

    // MEDIUM TABLE DATA
    List<String> mdmRow1 = [
      'OB',
      oneEightyActualMdm.toString(),
      threeSevenFiveActualMdm.toString(),
      sevenFiftyActualMdm.toString(),
      thousandActualMdm.toString(),
      totalActualMdmBtls.toString(),
      totalPriceMediumActual.toString(),
    ];

    print('mdmRow1 $mdmRow1');

    List<String> mdmRow2 = [
      'SALES',
      oneEightySalesMdm.toString(),
      threeSevenFiveSalesMdm.toString(),
      sevenFiftySalesMdm.toString(),
      thousandSalesMdm.toString(),
      totalSalesMdmBtls.toString(),
      totalPriceMediumSales.toString(),
    ];

    List<String> mdmRow3 = [
      'CB',
      oneEightyCBMdm.toString(),
      threeSevenFiveCBMdm.toString(),
      sevenFiftyCBMdm.toString(),
      thousandCBMdm.toString(),
      totalCbMdmBtls.toString(),
      totalPriceMediumClosing.toString(),
    ];

    // PREMIUM TABLE DATA
    List<String> prmRow1 = [
      'OB',
      oneEightyActualPrm.toString(),
      threeSevenFiveActualPrm.toString(),
      sevenFiftyActualPrm.toString(),
      thousandActualPrm.toString(),
      totalActaulPrmBtls.toString(),
      totalPricePremiumActual.toString(),
    ];

    List<String> prmRow2 = [
      'SALES',
      oneEightySalesPrm.toString(),
      threeSevenFiveSalesPrm.toString(),
      sevenFiftySalesPrm.toString(),
      thousandSalesPrm.toString(),
      totalSalesPrmBtls.toString(),
      totalPricePremiumSales.toString(),
    ];

    List<String> prmRow3 = [
      'CB',
      oneEightyCBPrm.toString(),
      threeSevenFiveCBPrm.toString(),
      sevenFiftyCBPrm.toString(),
      thousandCBPrm.toString(),
      totalCbPrmBtls.toString(),
      totalPricePremiumClosing.toString(),
    ];

    // IMFL TABLE DATA

    int totalImflActual =
        thousandActualImfl +
        sevenFiftyActualImfl +
        threeSevenFiveActualImfl +
        oneEightyActualImfl;
    int totalImflOpen =
        thousandOpImfl +
        sevenFiftyOpImfl +
        threeSevenFiveOpImfl +
        oneEightyOpImfl;
    int totalImflReceipt =
        thousandInImfl +
        sevenFiftyInImfl +
        threeSevenFiveInImfl +
        oneEightyInImfl;

    int totalImflSales =
        oneEightySalesImfl +
        threeSevenFiveSalesImfl +
        sevenFiftySalesImfl +
        thousandSalesImfl;

    int totalImflCB =
        oneEightyCBImfl +
        threeSevenFiveCBImfl +
        sevenFiftyCBImfl +
        thousandCBImfl;

    List<String> imflRow3 = [
      'TOTAL',
      oneEightyActualImfl.toString(),
      threeSevenFiveActualImfl.toString(),
      sevenFiftyActualImfl.toString(),
      thousandActualImfl.toString(),
      totalImflActual.toString(),
      totalPriceImflActual.toString(),
    ];
    List<String> imflRow1 = [
      'OP',
      oneEightyOpImfl.toString(),
      threeSevenFiveOpImfl.toString(),
      sevenFiftyOpImfl.toString(),
      thousandOpImfl.toString(),
      totalImflOpen.toString(),
      totalPriceImflOpening.toString(),
    ];
    List<String> imflRow2 = [
      'RECEIPT',
      oneEightyInImfl.toString(),
      threeSevenFiveInImfl.toString(),
      sevenFiftyInImfl.toString(),
      thousandInImfl.toString(),
      totalImflReceipt.toString(),
      totalPriceImflReciept.toString(),
    ];

    List<String> imflRow4 = [
      'SALES',
      oneEightySalesImfl.toString(),
      threeSevenFiveSalesImfl.toString(),
      sevenFiftySalesImfl.toString(),
      thousandSalesImfl.toString(),
      totalImflSales.toString(),
      totalPriceImflSales.toString(),
    ];
    List<String> imflRow5 = [
      'CB',
      oneEightyCBImfl.toString(),
      threeSevenFiveCBImfl.toString(),
      sevenFiftyCBImfl.toString(),
      thousandCBImfl.toString(),
      totalImflCB.toString(),
      totalPriceImflClosing.toString(),
    ];

    // BEER TABLE DATA

    int totalBeerOpen =
        sixFiftyOpBeer + fiveHundredOpBeer + threeTwentyFiveOpBeer;
    //inward
    int totalBeerInward =
        sixFiftyInBeer + fiveHundredInBeer + threeTwentyFiveInBeer;

    int totalBeerActual =
        sixFiftyActualBeer + fiveHundredActualBeer + threeTwentyFiveActualBeer;

    int totalBeerSales =
        sixFiftySalesBeer + fiveHundredSalesBeer + threeTwentyFiveSalesBeer;

    int totalBeerCB =
        sixFiftyCBBeer + fiveHundredCBBeer + threeTwentyFiveCBBeer;
    print('sixFiftyCBBeer $sixFiftyCBBeer');
    print('fiveHundredOpBeer $fiveHundredOpBeer');
    print('threeTwentyFiveCBBeer $threeTwentyFiveCBBeer');
    print('fiveHundredCBBeer $fiveHundredCBBeer');

    List<String> beerRow3 = [
      'TOTAL',
      sixFiftyActualBeer.toString(),
      fiveHundredActualBeer.toString(),
      threeTwentyFiveActualBeer.toString(),
      totalBeerActual.toString(),
      totalPriceBeerActual.toString(),
    ];

    List<String> beerRow1 = [
      'OP',
      sixFiftyOpBeer.toString(),
      fiveHundredOpBeer.toString(),
      threeTwentyFiveOpBeer.toString(),
      totalBeerOpen.toString(),
      totalPriceBeerOpening.toString(),
    ];
    List<String> beerRow2 = [
      'RECEIPT',
      sixFiftyInBeer.toString(),
      fiveHundredInBeer.toString(),
      threeTwentyFiveInBeer.toString(),
      totalBeerInward.toString(),
      totalPriceBeerReciept.toString(),
    ];

    List<String> beerRow4 = [
      'SALES',
      sixFiftySalesBeer.toString(),
      fiveHundredSalesBeer.toString(),
      threeTwentyFiveSalesBeer.toString(),
      totalBeerSales.toString(),
      totalPriceBeerSales.toString(),
    ];

    List<String> beerRow5 = [
      'CB',
      sixFiftyCBBeer.toString(),
      fiveHundredCBBeer.toString(),
      threeTwentyFiveCBBeer.toString(),
      totalBeerCB.toString(),
      totalPriceBeerClosing.toString(),
    ];

    // IMFL + BEER
    int totalImflAndBeerActualBtls =
        thousandActual +
        sevenFiftyActual +
        threeSevenFiveActual +
        oneEightyActual +
        sixFiftyActual +
        fiveHundredActual +
        threeTwentyFiveActual;

    int totalImflAndBeerOpenBtls =
        thousandOp +
        sevenFiftyOp +
        threeSevenFiveOp +
        oneEightyOp +
        sixFiftyOp +
        fiveHundredOp +
        threeTwentyFiveOp;
    int totalImflAndBeerInBtls =
        thousandRecpt +
        sevenFiftyRecpt +
        threeSevenFiveRecpt +
        oneEightyRecpt +
        sixFiftyRecpt +
        fiveHundredRecpt +
        threeTwentyFiveRecpt;

    int totalImflAndBeerSalesBtls =
        thousandSales +
        sevenFiftySales +
        threeSevenFiveSales +
        oneEightySales +
        sixFiftySales +
        fiveHundredSales +
        threeTwentyFiveSales;

    int totalImflAndBeerCBBtls =
        thousandCB +
        sevenFiftyCB +
        threeSevenFiveCB +
        oneEightyCB +
        sixFiftyCB +
        fiveHundredCB +
        threeTwentyFiveCB;

    List<String> imflAndBeerRow3 = [
      'TOTAL',
      oneEightyActual.toString(),
      threeSevenFiveActual.toString(),
      sevenFiftyActual.toString(),
      thousandActual.toString(),
      sixFiftyActual.toString(),
      fiveHundredActual.toString(),
      threeTwentyFiveActual.toString(),
      totalImflAndBeerActualBtls.toString(),
      totalPriceImflAndBeerActual.toString(),
    ];
    List<String> imflAndBeerRow1 = [
      'OP',
      oneEightyOp.toString(),
      threeSevenFiveOp.toString(),
      sevenFiftyOp.toString(),
      thousandOp.toString(),
      sixFiftyOp.toString(),
      fiveHundredOp.toString(),
      threeTwentyFiveOp.toString(),
      totalImflAndBeerOpenBtls.toString(),
      totalPriceImflAndBeerOpening.toString(),
    ];
    List<String> imflAndBeerRow2 = [
      'RECEIPT',
      oneEightyRecpt.toString(),
      threeSevenFiveRecpt.toString(),
      sevenFiftyRecpt.toString(),
      thousandRecpt.toString(),
      sixFiftyRecpt.toString(),
      fiveHundredRecpt.toString(),
      threeTwentyFiveRecpt.toString(),
      totalImflAndBeerInBtls.toString(),
      totalPriceImflAndBeerReciept.toString(),
    ];

    List<String> imflAndBeerRow4 = [
      'SALES',
      oneEightySales.toString(),
      threeSevenFiveSales.toString(),
      sevenFiftySales.toString(),
      thousandSales.toString(),
      sixFiftySales.toString(),
      fiveHundredSales.toString(),
      threeTwentyFiveSales.toString(),
      totalImflAndBeerSalesBtls.toString(),
      totalPriceImflAndBeerSales.toString(),
    ];
    List<String> imflAndBeerRow5 = [
      'CB',
      oneEightyCB.toString(),
      threeSevenFiveCB.toString(),
      sevenFiftyCB.toString(),
      thousandCB.toString(),
      sixFiftyCB.toString(),
      fiveHundredCB.toString(),
      threeTwentyFiveCB.toString(),
      totalImflAndBeerCBBtls.toString(),
      totalPriceImflAndBeerClosing.toString(),
    ];
    print('$oneEightyActualImfl   oneEightyActualImfl');
    print('$threeSevenFiveActualImfl   threeSevenFiveActualImfl');
    print('$sevenFiftyActualImfl   sevenFiftyActualImfl');
    print('$thousandActualImfl   thousandActualImfl');
    print('$totalImflActual   totalImflActual');

    return [
      // data,
      [row1, row2, row3, row4, row5],
      [ordRow1, ordRow2, ordRow3],
      [mdmRow1, mdmRow2, mdmRow3],
      [prmRow1, prmRow2, prmRow3],
      [imflRow1, imflRow2, imflRow3, imflRow4, imflRow5],
      [beerRow1, beerRow2, beerRow3, beerRow4, beerRow5],
      [
        imflAndBeerRow1,
        imflAndBeerRow2,
        imflAndBeerRow3,
        imflAndBeerRow4,
        imflAndBeerRow5,
      ],
    ];
  }

  Future<List<Map<String, dynamic>>> salesCompletedData() async {
    String viewDate = await _viewDateController.getViewDateForUi();

    String shopId = await getIt<ShopIdController>().getShopId();
    List<SalesViewModel> saleTableData = await salesController.getSalesData(
      viewDate,
      shopId,
    );

    final grouped = groupBy(
      saleTableData.where((e) => e.totalSalesRetailUnits != -1),
      (SalesViewModel e) => e.category,
    );

    List<Map<String, dynamic>> maps = grouped.entries.map((entry) {
      return {
        'category': entry.key,
        'totalRetailUnits': entry.value.fold(
          0,
          (sum, e) => sum + e.totalSalesRetailUnits,
        ),
        'totalPriceSales': entry.value.fold(
          0.0,
          (sum, e) => sum + e.totalPriceSales,
        ),
      };
    }).toList();

    List<Map<String, dynamic>> val = maps.map((e) {
      return {
        "category": capitalizeEachWord(e['category']),
        "units": e['totalRetailUnits'],
        "price": e['totalPriceSales'],
      };
    }).toList();

    int totalUnits = 0;
    double totalPrice = 0;

    for (var item in val) {
      totalUnits += (item['units'] as int? ?? 0);
      totalPrice += (item['price'] as int? ?? 0);
    }
    val.add({
      "category": "Total",
      "units": totalUnits,
      "price": totalPrice.toStringAsFixed(0),
    });

    return val;
  }

  String capitalizeEachWord(String text) {
    return text
        .toLowerCase()
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '',
        )
        .join(' ');
  }
}

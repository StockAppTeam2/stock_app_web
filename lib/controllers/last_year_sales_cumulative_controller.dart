import 'package:stock_app_web/core/repositories/last_year_sales_cumulative_repo.dart';
import 'package:stock_app_web/models/previous_year_sales_cumulative.dart';

import '../core/locator/service_locator.dart';

class LastYearSalesCumulativeController {
  final _lastYearSalesCumulativeRepo = getIt<LastYearSalesCumulativeRepo>();

  Future<List<String>> getLastYearCumulativeMonths() async {
    return await _lastYearSalesCumulativeRepo.getLastYearCumulativeMonths();
  }

  Future<void> addLastYearSalesCumulative(
    PreviousYearSalesCumulativeModel model,
  ) async {
    await _lastYearSalesCumulativeRepo.addLastYearSalesCumulative(model);
  }



  Future<List<PreviousYearSalesCumulativeModel>> getPreviousYearSalesCumulative(String monthAndYear) async {
    List<PreviousYearSalesCumulativeModel> data = await _lastYearSalesCumulativeRepo.getPreviousYearSalesCumulative(monthAndYear);
    return data;
  }

  Future<void> deletePreviousYearSalesCumulative(String date) async {
    await _lastYearSalesCumulativeRepo.deletePreviousYearSalesCumulative(date);
  }
}
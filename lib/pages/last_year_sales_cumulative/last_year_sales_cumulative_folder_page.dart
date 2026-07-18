import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stock_app_web/controllers/last_year_sales_cumulative_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';

class LastYearSalesCumulativeFolderPage extends StatefulWidget {
  const LastYearSalesCumulativeFolderPage({super.key});

  @override
  State<LastYearSalesCumulativeFolderPage> createState() =>
      _LastYearSalesCumulativeFolderPageState();
}

class _LastYearSalesCumulativeFolderPageState
    extends State<LastYearSalesCumulativeFolderPage> {
  final _lastYearSalesCumulativeController =
      getIt<LastYearSalesCumulativeController>();

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Last Year Details', style: TextStyle(fontSize: 20)),
              ElevatedButton(
                onPressed: () async {
                  String shopId = await getIt<ShopIdController>().getShopId();
                  if (!context.mounted) return;
                  context.go(
                    '/$shopId/${AppRoutes.addLastYearSalesCumulativePage}',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(children: [Text('Add Cumulative'), Icon(Icons.add)]),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<String>>(
              future: getLastYearSalesCumulativeMonths(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                final cumulativeDates = snapshot.data ?? [];

                if (cumulativeDates.isEmpty) {
                  return const Center(child: Text("No Data Found"));
                }

                return ListView.builder(
                  itemCount: cumulativeDates.length,
                  itemBuilder: (BuildContext context, int index) {
                    DateTime date = DateFormat(
                      'yyyy-MM',
                    ).parse(cumulativeDates[index]);
                    String output = DateFormat('MMMM yyyy').format(date);

                    return Card(
                      elevation: 1.0,
                      child: GestureDetector(
                        child: ListTile(
                          title: Text(output),
                          trailing: const Icon(Icons.navigate_next),
                          onTap: () async {
                            String shopId = await getIt<ShopIdController>()
                                .getShopId();

                            if (!context.mounted) return;
                            context.go(
                              '/$shopId/${AppRoutes.lastYearSalesCumulativePage}',
                              extra: {'monthAndYear': cumulativeDates[index]},
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<String>> getLastYearSalesCumulativeMonths() async {
    List<String> dates = await _lastYearSalesCumulativeController
        .getLastYearCumulativeMonths();
    return dates;
  }
}

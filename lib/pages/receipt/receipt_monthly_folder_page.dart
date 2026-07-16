import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_app_web/controllers/receipt_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
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
  final _receiptController = getIt<ReceiptController>();

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              YoutubeButton(url: ''),
              SizedBox(width: 15),
              ElevatedButton(
                onPressed: () async {
                  String shopId = await getIt<ShopIdController>().getShopId();
                  if (!context.mounted) return;
                  context.go('/$shopId/${AppRoutes.addReceiptStock}');
                },
                style: ElevatedButton.styleFrom(
                  // fixedSize: const Size(260, 50),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(children: [Text('Add Purchase'), Icon(Icons.add)]),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<String>>(
              future: getReceiptDates(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                final receiptDates = snapshot.data ?? [];

                if (receiptDates.isEmpty) {
                  return const Center(child: Text("No Data Found"));
                }

                return ListView.builder(
                  itemCount: receiptDates.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 1.0,
                      child: GestureDetector(
                        child: ListTile(
                          title: Text(receiptDates[index]),
                          trailing: const Icon(Icons.navigate_next),
                          onTap: () async {
                            String shopId = await getIt<ShopIdController>()
                                .getShopId();

                            if (!context.mounted) return;
                            context.go(
                              '/$shopId/${AppRoutes.receiptDailyFolder}',
                              extra: {'monthAndYear': receiptDates[index]},
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
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: receiptDates.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       return Card(
          //         elevation: 1.0,
          //         child: ListTile(
          //           title: Text(receiptDates[index]),
          //           trailing: const Icon(Icons.navigate_next),
          //           onTap: () {
          //             DateTime convert = DateFormat(
          //               'MMMM yyyy',
          //             ).parse(receiptDates[index]);
          //             String output = DateFormat('yyyy-MM').format(convert);
          //             // Outputs: 2024-05
          //             context.go(
          //               AppRoutes.receiptDailyFolder,
          //               extra: {'monthAndYear': output},
          //             );
          //           },
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<List<String>> getReceiptDates() async {
    List<String> dates = await _receiptController.getReceiptMonths();
    return dates;
  }
}

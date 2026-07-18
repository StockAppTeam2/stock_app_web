import 'package:flutter/material.dart';
import 'package:stock_app_web/controllers/opening_page_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';
import 'package:stock_app_web/models/items_table_model.dart';

class UnscannedClosingPage extends StatefulWidget {
  const UnscannedClosingPage({super.key});

  @override
  State<UnscannedClosingPage> createState() => _UnscannedClosingPageState();
}

class _UnscannedClosingPageState extends State<UnscannedClosingPage> {
  final _viewDateController = getIt<ViewDateController>();
  final _openingController = getIt<OpeningPageController>();

  List<ItemsViewModel> closingStockData = [];

  String viewDate = '';
  String closingDate = '';
  bool isSearchClicked = false;
  int totalBottles = 0;
  int totalAmount = 0;

  @override
  void initState() {
    super.initState();
    getViewDate();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final int itemCount = closingStockData.length;
    final int totalRows = itemCount + 3; // 3 total rows at the end
    return AppNavigatorWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            PageHeader(
              title: 'UnScanned Page',
              viewDate: viewDate,
              query: (String p1) {},
              videoLink: '',
              page: '',
              invoiceNo: '',
              showReport: false,
            ),

            const SizedBox(height: 20),
            closingStockData.isEmpty
                ? Center(child: Text('No Data Found'))
                : Expanded(
                    child: Column(
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                          color: Colors.grey.shade200,
                          child: const Row(
                            children: [
                              Expanded(
                                flex: 12,
                                child: Text(
                                  'Product',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(child: Text('=')),
                              ),
                              Expanded(
                                flex: 4,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Amount',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Divider(height: 1),

                        // Items
                        Expanded(
                          child: ListView.separated(
                            itemCount: closingStockData.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = closingStockData[index];
                              final amount = item.price * item.unscannedEntry;

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 12,
                                      child: RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(
                                            context,
                                          ).style.copyWith(fontSize: 18),
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${index + 1}. ${item.brand} ${item.size}\n',
                                            ),
                                            TextSpan(
                                              text: 'Rs.${item.price} × ',
                                            ),
                                            TextSpan(
                                              text: '${item.unscannedEntry}',
                                              style: const TextStyle(
                                                color: Color(0xFF0067FF),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    const Expanded(
                                      flex: 1,
                                      child: Center(child: Text('=')),
                                    ),

                                    Expanded(
                                      flex: 4,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          amount.toString(),
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        const Divider(thickness: 2),

                        // Totals
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              _totalRow('Values', totalAmount),
                              _totalRow(
                                'Bottle Return Cost ($totalBottles × 10)',
                                totalBottles * 10,
                              ),
                              const Divider(),
                              _totalRow(
                                'Total',
                                totalAmount + (totalBottles * 10),
                                bold: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void getViewDate() async {
    String value = await _viewDateController.getViewDateForUi();
    print('viewdate: $value');
    if (mounted) {
      setState(() => viewDate = value);
    }
  }

  void getData() async {
    String value = await _viewDateController.getViewDateForUi();
    String shopId = await getIt<ShopIdController>().getShopId();

    List<ItemsViewModel> itemData = await _openingController.getOpeningData(
      value,
      shopId,
    );

    setState(() {
      for (final data in itemData) {
        if (data.unscannedEntry != 0) {
          closingStockData.add(data);
          totalAmount += data.unscannedEntry * data.price;
          totalBottles += data.unscannedEntry;
        }
      }

      closingDate = itemData[0].date;
    });
  }

  Widget _totalRow(String title, num value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
          const Text('='),
          const SizedBox(width: 16),
          SizedBox(
            width: 120,
            child: Text(
              value.toString(),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 18,
                fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

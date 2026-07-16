import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_app_web/controllers/receipt_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/utils/format_date.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';
import 'package:stock_app_web/models/inward_table_model.dart';

class ReceiptDailyFolderPage extends StatefulWidget {
  final String monthAndYear;

  const ReceiptDailyFolderPage({super.key, required this.monthAndYear});

  @override
  State<ReceiptDailyFolderPage> createState() => _ReceiptDailyFolderPageState();
}

class _ReceiptDailyFolderPageState extends State<ReceiptDailyFolderPage> {
  final _receiptController = getIt<ReceiptController>();
  final _viewDateController = getIt<ViewDateController>();
  final ScrollController scrollController = ScrollController();

  String viewDate = '';
  List<InwardDailyFolderModel> dailyData = [];
  String? lastDate;

  bool isFirstLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;

  final int pageSize = 15;
  final int maxDocs = 45;

  @override
  void initState() {
    super.initState();
    getInwardDailyDetails();
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 300) {
        if (!_viewDateController.isLoading && _viewDateController.hasMore) {
          await getInwardDailyDetails();

          if (mounted) {
            setState(() {});
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            PageHeader(
              title: 'PURCHASE',
              viewDate: '',
              query: (String p1) {},
              videoLink: '',
              page: 'purchase_daily',
              invoiceNo: '',
              showReport: true,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: isFirstLoading
                  ? const Center(child: CircularProgressIndicator())
                  : dailyData.isEmpty
                  ? Center(child: Text('No Data Found'))
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: dailyData.length + (isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == dailyData.length) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final item = dailyData[index];

                        return Padding(
                          padding: const EdgeInsets.all(3),
                          child: InkWell(
                            onTap: () async {
                              final shopId = await getIt<ShopIdController>()
                                  .getShopId();

                              if (!context.mounted) return;

                              context.go(
                                '/$shopId/${AppRoutes.receiptStock}',
                                extra: {'date': item.date},
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 19,
                                    ),
                                    children: [
                                      const TextSpan(text: 'Invoice No : '),
                                      TextSpan(
                                        text: '${item.invoiceNo} ',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '(${formatYYYYMMDDToDDMMYYYY(item.date)})\n',
                                      ),
                                      const TextSpan(text: 'IMFL Rs. '),
                                      TextSpan(
                                        text: '${item.imfTotalPrice}\n',
                                        style: const TextStyle(
                                          color: Colors.purpleAccent,
                                        ),
                                      ),
                                      const TextSpan(text: 'BEER Rs. '),
                                      TextSpan(
                                        text: '${item.beerTotalPrice}\n',
                                        style: const TextStyle(
                                          color: Colors.purpleAccent,
                                        ),
                                      ),
                                      const TextSpan(text: 'TOTAL Rs. '),
                                      TextSpan(
                                        text: '${item.imflAndBeerTotal}',
                                        style: const TextStyle(
                                          color: Colors.purpleAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: const Icon(Icons.navigate_next),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getInwardDailyDetails() async {
    if (!hasMore || isLoadingMore) return;

    if (lastDate == null) {
      isFirstLoading = true;
    } else {
      isLoadingMore = true;
    }

    setState(() {});

    List<InwardDailyFolderModel> invoiceTotals = await _receiptController
        .getInwardDailyDetails(month: widget.monthAndYear, pageSize: pageSize);

    if (invoiceTotals.isEmpty) {
      hasMore = false;
    } else {
      if (lastDate == null) {
        dailyData = invoiceTotals;
      } else {
        dailyData.addAll(invoiceTotals);
      }

      lastDate = invoiceTotals.last.date;

      if (dailyData.length >= maxDocs) {
        dailyData = dailyData.take(maxDocs).toList();
        hasMore = false;
      }

      if (invoiceTotals.length < pageSize) {
        hasMore = false;
      }
    }

    isFirstLoading = false;
    isLoadingMore = false;

    setState(() {});
  }
}

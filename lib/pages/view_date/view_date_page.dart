import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/utils/format_date.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';

class ViewDatePage extends StatefulWidget {
  const ViewDatePage({super.key});

  @override
  State<ViewDatePage> createState() => _ViewDatePageState();
}

class _ViewDatePageState extends State<ViewDatePage> {
  final _viewDateController = getIt<ViewDateController>();
  final ScrollController scrollController = ScrollController();

  String viewDate = '';
  List<String> viewDates = [];
  String? lastDate;

  bool isFirstLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;

  final int pageSize = 10;
  final int maxDocs = 45;

  @override
  void initState() {
    super.initState();
    getViewDate();
    getViewDateList();
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 300) {
        if (!_viewDateController.isLoading && _viewDateController.hasMore) {
          await getViewDateList();

          if (mounted) {
            setState(() {});
          }
        }
      }
    });
  }

  void getViewDate() async {
    String date = await _viewDateController.getViewDateForUi();
    viewDate = date;
  }

  Future<void> getViewDateList() async {
    if (!hasMore || isLoadingMore) return;

    if (lastDate == null) {
      isFirstLoading = true;
    } else {
      isLoadingMore = true;
    }

    setState(() {});

    final dates = await _viewDateController.getDates(lastDate, pageSize);

    if (dates.isEmpty) {
      hasMore = false;
    } else {
      if (lastDate == null) {
        viewDates = dates;
      } else {
        viewDates.addAll(dates);
      }

      lastDate = dates.last;

      if (viewDates.length >= maxDocs) {
        viewDates = viewDates.take(maxDocs).toList();
        hasMore = false;
      }

      if (dates.length < pageSize) {
        hasMore = false;
      }
    }

    isFirstLoading = false;
    isLoadingMore = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: isFirstLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: scrollController,
              itemCount: viewDates.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == viewDates.length) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final item = viewDates[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month, color: Colors.blue),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Text(
                            formatYYYYMMDDToDDMMYYYY(item),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        FilledButton.icon(
                          onPressed: () async {
                            await _viewDateController.setViewDate(item);

                            String shopId = await getIt<ShopIdController>()
                                .getShopId();
                            if (context.mounted) {
                              context.go('/$shopId/${AppRoutes.home}');
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: viewDate.isNotEmpty
                                ? item == viewDate
                                      ? Colors.purple
                                      : Colors.green
                                : null,
                          ),
                          icon: Icon(Icons.remove_red_eye_outlined),

                          label: const Text("View"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

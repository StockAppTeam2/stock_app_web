import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_app_web/controllers/brand_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';
import 'package:stock_app_web/models/brand_model.dart';
import 'package:stock_app_web/pages/brand/widgets/brand_delete_popup.dart';
import 'package:stock_app_web/pages/brand/widgets/current_stock_error.dart';

class BrandPage extends StatefulWidget {
  const BrandPage({super.key});

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  final _brandController = getIt<BrandController>();

  final ScrollController scrollController = ScrollController();

  List<BrandModel> allData = [];
  List<BrandModel> visibleData = [];
  List<BrandModel> filterData = [];

  final int pageSize = 20;
  int currentPage = 0;
  bool hasMore = true;

  bool isFirstLoading = true;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    loadBrandData();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        loadNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            PageHeader(
              title: 'BRAND',
              viewDate: '',
              query: (String query) {
                search(query);
              },
              videoLink: '',
              page: 'brand_stock',
              invoiceNo: '',
              showReport: true,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: isFirstLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: visibleData.length + (isLoadingMore ? 1 : 0),
                      itemBuilder: (context, rowIndex) {
                        final product = visibleData[rowIndex];

                        final isGrey = rowIndex % 2 == 0;
                        // Header row (static)
                        if (rowIndex == 0) {
                          return Row(
                            children: [
                              _columnContainer(context, 0, 'Enable'),
                              _columnContainer(context, 1, 'Sno'),
                              _columnContainer(context, 2, 'ProductId'),
                              _columnContainer(context, 3, 'Brand'),
                              _columnContainer(context, 4, 'Category'),
                              _columnContainer(context, 5, 'Size'),
                              _columnContainer(context, 6, 'Group'),
                              _columnContainer(context, 7, 'Range'),
                              // Visibility(
                              //   visible: showBuyingPriceColumn,
                              //   child: _columnContainer(
                              //     context,
                              //     8,
                              //     'Buying Price',
                              //   ),
                              // ),
                              _columnContainer(context, 9, 'MRP'),
                              _columnContainer(context, 10, 'Bottle Per Case'),
                              _columnContainer(context, 11, 'Edit'),
                              _columnContainer(context, 12, 'Delete'),
                            ],
                          );
                        }
                        // Data rows (scrollable)
                        return Row(
                          children: [
                            Container(
                              width: columnWidths[0],
                              height: 55.0,
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: isGrey == true
                                    ? Colors.grey
                                    : Colors.white,
                              ),
                              child: Center(
                                child: IconButton(
                                  // Edit Icon/Button
                                  icon: product.isActive == 0
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        )
                                      : const Icon(
                                          Icons.dangerous,
                                          color: Colors.red,
                                        ),
                                  onPressed: () async {
                                    if (product.isActive == 0) {
                                      // enableDisableBrandItems(product, 1);
                                    } else if (product.isActive == 1) {
                                      // enableDisableBrandItems(product, 0);
                                    }
                                  },
                                ),
                              ),
                            ),
                            // _rowContainerIconIsActive(product, 0, product.id.toString(), isGrey),
                            _rowContainer(
                              product,
                              1,
                              product.id.toString(),
                              isGrey,
                            ),
                            _rowContainer(
                              product,
                              2,
                              product.productId.toString(),
                              isGrey,
                            ),
                            _rowContainer(
                              product,
                              3,
                              product.brand.toString(),
                              isGrey,
                            ),
                            _rowContainer(
                              product,
                              4,
                              product.category.toString(),
                              isGrey,
                            ),
                            _rowContainer(
                              product,
                              5,
                              product.size.toString(),
                              isGrey,
                            ),
                            _rowContainer(
                              product,
                              6,
                              product.groups.toString(),
                              isGrey,
                            ),
                            _rowContainer(
                              product,
                              7,
                              product.range.toString(),
                              isGrey,
                            ),
                            // Visibility(
                            //   visible: showBuyingPriceColumn,
                            //   child: _rowContainer(
                            //     product,
                            //     8,
                            //     product.buyingPrice.toStringAsFixed(2),
                            //     isGrey,
                            //   ),
                            // ),
                            _rowContainer(
                              product,
                              9,
                              product.price.toString(),
                              isGrey,
                            ),
                            _rowContainer(
                              product,
                              10,
                              product.bottlePerBundle.toString(),
                              isGrey,
                            ),

                            Container(
                              width: columnWidths[11],
                              height: 55.0,
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                // border: Border(top: BorderSide(color: Colors.grey))
                                color: isGrey == true
                                    ? Colors.grey
                                    : Colors.white,
                              ),
                              child: Center(
                                child: IconButton(
                                  onPressed: () async {
                                    String shopId =
                                        await getIt<ShopIdController>()
                                            .getShopId();
                                    if (context.mounted) {
                                      context.go(
                                        '/$shopId/${AppRoutes.editBrandStock}',
                                        extra: {"brandModel": product},
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            // _rowContainerIconEdit(product, 10, product.id.toString(), isGrey),
                            Container(
                              width: columnWidths[12],
                              height: 55.0,
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                // border: Border(top: BorderSide(color: Colors.grey))
                                color: isGrey == true
                                    ? Colors.grey
                                    : Colors.white,
                              ),
                              child: Center(
                                child: IconButton(
                                  onPressed: () async {
                                    await deleteBrand(
                                      context,
                                      product.productId.toString(),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            // _rowContainerDelete(product, 11, product.id.toString(), isGrey),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Container _columnContainer(BuildContext context, int index, String title) {
    return Container(
      width: columnWidths[index],
      height: 50.0,
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        // border: Border.all(color: Colors.grey),
        color: Color(0xFF22C72A),
      ),
      child: Center(
        child: FittedBox(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Container _rowContainer(
    BrandModel row,
    int index,
    String title,
    bool isGrey,
  ) {
    return Container(
      width: columnWidths[index],
      height: 55.0,
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        // border: Border(top: BorderSide(color: Colors.grey))
        color: isGrey == true ? Colors.grey : Colors.white,
      ),
      child: Center(child: Text(title, style: const TextStyle(fontSize: 14))),
    );
  }

  final List<double> columnWidths = [
    80.0, //enable
    60.0, //s no
    90.0, //product id
    150.0, //brand
    100.0, //cate
    100.0, //size
    90.0, //group
    110.0, //range
    130.0, //buying price
    70.0, // price
    120.0, //bottle
    70.0, //edit
    70.0, //delete
  ];

  Future<void> loadBrandData() async {
    isFirstLoading = true;
    setState(() {});

    allData = await _brandController.loadBrands();
    filterData = List.from(allData); // <-- Add this

    currentPage = 0;
    visibleData.clear();

    loadNextPage(showLoader: false);

    await loadNextPage(showLoader: false);

    isFirstLoading = false;
    setState(() {});
  }

  Future<void> loadNextPage({bool showLoader = true}) async {
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = showLoader;
    if (showLoader) setState(() {});

    final start = currentPage * pageSize;

    if (start >= filterData.length) {
      hasMore = false;
      isLoadingMore = false;
      setState(() {});
      return;
    }

    final end = (start + pageSize).clamp(0, filterData.length);

    visibleData.addAll(filterData.sublist(start, end));

    currentPage++;
    isLoadingMore = false;

    setState(() {});
  }

  Future<List<BrandModel>> loadFilteredBrand(String query) async {
    List<BrandModel> data = [];
    print('filtered data1 $filterData');
    data = filterData
        .where(
          (card) =>
              card.productId.toString().toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              card.brand.toString().toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    print('filtered data2 $filterData');
    return data;
  }

  void search(String text) {
    text = text.trim();

    if (text.isEmpty) {
      filterData = List.from(allData);
    } else {
      filterData = allData.where((e) {
        return e.brand.toLowerCase().contains(text.toLowerCase()) ||
            e.productId.toString().contains(text);
      }).toList();
    }

    // Reset pagination
    currentPage = 0;
    visibleData.clear();
    hasMore = true;
    isLoadingMore = false;

    loadNextPage(showLoader: false);
  }

  Future<void> deleteBrand(BuildContext context, String productId) async {
    bool checkActualIsZero = await _brandController.checkCurrentStockIsZero(
      productId,
    );

    if (checkActualIsZero) {
      if (context.mounted) {
        bool isDeleted = await showDeleteDialog(context, productId);

        if (isDeleted) {
          loadBrandData();
        }
      }
      loadBrandData();
    } else {
      if (context.mounted) {
        currentStockError(context);
      }
    }
  }
}

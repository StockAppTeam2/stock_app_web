import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_app_web/controllers/home_page_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/constants/app_assets.dart';
import 'package:stock_app_web/core/constants/pages_card_colors.dart';
import 'package:stock_app_web/core/constants/pages_constants.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/Internet_connection_repo.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/utils/format_date.dart';
import 'package:stock_app_web/core/utils/responsive.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/pages/home/widgets/card_widget.dart';
import 'package:stock_app_web/pages/home/widgets/first_opening_popup.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _viewDateController = getIt<ViewDateController>();
  final homePageController = getIt<HomePageController>();
  final _internetConnectionRepo = getIt<InternetConnectionRepo>();

  String viewDate = '';

  @override
  void initState() {
    super.initState();
    _viewDateController.getViewDateForUi().then((value) {
      if (mounted) {
        print('viewDate home: $value');
        setState(() => viewDate = value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: ListView(
        children: [
          Row(
            children: [
              if (!Responsive.isDesktop(context))
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              const SizedBox(width: 10),
              const Text(
                "Stock Chitta",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              if (viewDate != '')
                Text(
                  formatYYYYMMDDToDDMMYYYY(viewDate),
                  style: TextStyle(fontSize: 20),
                ),
              SizedBox(width: 10),
            ],
          ),

          const SizedBox(height: 20),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: PagesConstants.pagesList.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              return CardWidget(
                color1: PagesCardColors.colour1[index],
                color2: PagesCardColors.colour2[index],
                icon: AppAssets.pagesImages[index],
                name: PagesConstants.pagesList[index],
                onTap: () async {
                  bool isFirstOpening = await homePageController
                      .checkFirstOpening();
                  if (isFirstOpening) {
                    if (context.mounted) {
                      firstOpeningPopup(context);
                    }
                  } else {
                    String shopId = await getIt<ShopIdController>().getShopId();
                    print('shopId HomePage: $shopId');
                    if (context.mounted) {
                      if (PagesConstants.pagesRouteList[index] ==
                          AppRoutes.salesStock) {
                        checkSalseOrCb();
                      } else {
                        context.go(
                          '/$shopId/${PagesConstants.pagesRouteList[index]}',
                        );
                      }
                    }
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void checkSalseOrCb() async {
    bool isConnected = await _internetConnectionRepo.checkInternetConnection();
    String shopId = await getIt<ShopIdController>().getShopId();

    if (isConnected) {
      DocumentReference salesOrCb = FirebaseFirestore.instance
          .collection('items')
          .doc(shopId);
      DocumentSnapshot salesOrCbData = await salesOrCb.get();

      if (salesOrCbData.exists) {
        Map<String, dynamic> data =
            salesOrCbData.data() as Map<String, dynamic>;

        if (data.containsKey('EnterSales')) {
          bool salesEntryType = data['EnterSales'] as bool;

          if (salesEntryType == true) {
            context.go('/$shopId/${AppRoutes.addSalesStock}');
          } else {
            context.go('/$shopId/${AppRoutes.salesStock}');
          }
        }
      }
    } else {
      showErrorToast('No Internet Connection');
    }
  }
}

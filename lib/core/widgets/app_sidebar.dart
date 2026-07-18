import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/utils/guid_video_links.dart';
import 'package:stock_app_web/core/widgets/drawer_tail.dart';
import 'package:stock_app_web/core/widgets/logout_popup.dart';
import 'package:web/web.dart' as web;

class AppSidebar extends StatefulWidget {
  const AppSidebar({super.key});

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: isExpanded ? 190 : 50,
      child: Column(
        children: [
          const SizedBox(height: 10),

          Row(
            children: [
              Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                icon: Icon(isExpanded ? Icons.menu_open : Icons.menu),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              children: [
                DrawerListTail(
                  title: isExpanded ? 'Home Page' : '',
                  icon: Icons.home,
                  onTap: () async {
                    String shopId = await getIt<ShopIdController>().getShopId();
                    if (context.mounted) {
                      context.go('/$shopId/${AppRoutes.home}');
                    }
                  },
                ),
                Container(height: 1, color: Colors.black12),
                DrawerListTail(
                  title: isExpanded ? 'View Date' : '',
                  icon: Icons.date_range,
                  onTap: () async {
                    String shopId = await getIt<ShopIdController>().getShopId();
                    if (context.mounted) {
                      context.go('/$shopId/${AppRoutes.viewDate}');
                    }
                  },
                ),
                Container(height: 1, color: Colors.black12),
                DrawerListTail(
                  title: isExpanded ? "Brand" : '',
                  icon: Icons.pending_actions_rounded,
                  onTap: () async {
                    String shopId = await getIt<ShopIdController>().getShopId();
                    if (context.mounted) {
                      context.go('/$shopId/${AppRoutes.brandStock}');
                    }
                  },
                ),
                Container(height: 1, color: Colors.black12),
                DrawerListTail(
                  title: isExpanded ? 'Settings' : '',
                  icon: Icons.settings,
                  onTap: () async {
                    String shopId = await getIt<ShopIdController>().getShopId();
                    if (context.mounted) {
                      context.go('/$shopId/${AppRoutes.settings}');
                    }
                  },
                ),
                Container(height: 1, color: Colors.black12),
                DrawerListTail(
                  title: isExpanded ? 'Support' : '',
                  icon: Icons.phone,
                  iconColor: Colors.pink,
                  onTap: () async {
                    String shopId = await getIt<ShopIdController>().getShopId();
                    if (context.mounted) {
                      context.go('/$shopId/${AppRoutes.supportPage}');
                    }
                  },
                ),
                Container(height: 1, color: Colors.black12),
                DrawerListTail(
                  title: isExpanded ? 'Guide' : '',
                  icon: Icons.play_circle_fill_outlined,
                  iconColor: Colors.red,
                  onTap: () {
                    print('youtubeUrl $stockChittaPage');
                    final Uri youtubeUrl = Uri.parse(stockChittaPage);
                    web.window.open(youtubeUrl.toString(), '_blank');
                  },
                ),
                Container(height: 1, color: Colors.black12),
                DrawerListTail(
                  title: isExpanded ? 'Logout' : '',
                  icon: Icons.logout,
                  onTap: () {
                    logOutPopup(context);
                  },
                ),
                Container(height: 1, color: Colors.black12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

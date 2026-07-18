import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/utils/guid_video_links.dart';
import 'package:stock_app_web/core/widgets/drawer_tail.dart';
import 'package:stock_app_web/core/widgets/logout_popup.dart';
import 'package:web/web.dart' as web;

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // DrawerHeader(
          //   accountName: 'Mesavaraj',
          //   accountEmail: 'mesavdev@gmiail.com',
          // ),
          // DrawerListTail(
          //   title: 'Home Page',
          //   icon: Icons.home,
          //   onTap: () async {
          //     String shopId = await getIt<ShopIdController>().getShopId();
          //     if (context.mounted) {
          //       context.go('/$shopId/${AppRoutes.home}');
          //     }
          //   },
          // ),
          Container(height: 1, color: Colors.black12),
          DrawerListTail(
            title: 'View Date',
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
            title: "Brand",
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
            title: 'Settings',
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
            title: 'Support',
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
            title: 'Guide',
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
            title: 'Logout',
            icon: Icons.logout,
            onTap: () {
              logOutPopup(context);
            },
          ),
          Container(height: 1, color: Colors.black12),
        ],
      ),
    );
  }
}

class DrawerHeader extends StatelessWidget {
  const DrawerHeader({
    super.key,
    required this.accountName,
    required this.accountEmail,
  });

  final String accountName;
  final String accountEmail;

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(color: Colors.blueAccent),
      accountName: Text(accountName),
      accountEmail: Text(accountEmail),
      currentAccountPicture: FutureBuilder<dynamic>(
        future: null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final url = snapshot.data![0];
            final isOnline = snapshot.data![1];

            if (url != null) {
              if (isOnline == true) {
                return CircleAvatar(backgroundImage: NetworkImage(url));
              }

              if (isOnline == false) {
                return CircleAvatar(backgroundImage: FileImage(url));
              }
            }
          }

          return const CircleAvatar(
            backgroundImage: AssetImage('assets/images/images.jpeg'),
          );
        },
      ),
      otherAccountsPictures: [
        IconButton(
          onPressed: () {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const ProfilePage()),
            // );
          },
          icon: const Icon(Icons.edit, color: Colors.white),
        ),
      ],
    );
  }
}

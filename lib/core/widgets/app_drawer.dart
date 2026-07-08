import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/widgets/drawer_tail.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            accountName: 'Mesavaraj',
            accountEmail: 'mesavdev@gmiail.com',
          ),
          DrawerListTail(
            title: 'HOME PAGE',
            icon: Icons.home,
            onTap: () {
              context.go(AppRoutes.home);
            },
          ),
          Container(height: 1, color: Colors.black12),
          DrawerListTail(
            title: 'VIEW DATE',
            icon: Icons.date_range,
            onTap: () async {
              context.go(AppRoutes.viewDate);
            },
          ),
          Container(height: 1, color: Colors.black12),
          DrawerListTail(
            title: "BRAND",
            icon: Icons.pending_actions_rounded,
            onTap: () async {},
          ),
          Container(height: 1, color: Colors.black12),
          DrawerListTail(
            title: 'Settings',
            icon: Icons.settings,
            onTap: () async {},
          ),
          Container(height: 1, color: Colors.black12),
          DrawerListTail(
            title: 'Support',
            icon: Icons.phone,
            iconColor: Colors.pink,
            onTap: () {},
          ),
          Container(height: 1, color: Colors.black12),
          DrawerListTail(
            title: 'Guide',
            icon: Icons.play_circle_fill_outlined,
            iconColor: Colors.red,
            onTap: () {},
          ),
          Container(height: 1, color: Colors.black12),
          DrawerListTail(title: 'Logout', icon: Icons.logout, onTap: () {}),
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

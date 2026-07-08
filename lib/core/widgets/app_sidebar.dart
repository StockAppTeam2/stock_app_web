import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/widgets/drawer_tail.dart';

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
                  title: isExpanded ? 'HOME PAGE' : '',
                  icon: Icons.home,
                  onTap: () {
                    context.go(AppRoutes.home);
                  },
                ),
                Container(height: 1, color: Colors.black12),
                DrawerListTail(
                  title: isExpanded ? 'VIEW DATE' : '',
                  icon: Icons.date_range,
                  onTap: () async {
                    context.go(AppRoutes.viewDate);
                  },
                ),
                Container(height: 1, color: Colors.black12),
                DrawerListTail(
                  title: isExpanded ? "BRAND" : '',
                  icon: Icons.pending_actions_rounded,
                  onTap: () async {},
                ),
                Container(height: 1, color: Colors.black12),
                DrawerListTail(
                  title: isExpanded ? 'Settings' : '',
                  icon: Icons.settings,
                  onTap: () async {},
                ),
                Container(height: 1, color: Colors.black12),
                DrawerListTail(
                  title: isExpanded ? 'Support' : '',
                  icon: Icons.phone,
                  iconColor: Colors.pink,
                  onTap: () {},
                ),
                Container(height: 1, color: Colors.black12),
                DrawerListTail(
                  title: isExpanded ? 'Guide' : '',
                  icon: Icons.play_circle_fill_outlined,
                  iconColor: Colors.red,
                  onTap: () {},
                ),
                Container(height: 1, color: Colors.black12),
                DrawerListTail(
                  title: isExpanded ? 'Logout' : '',
                  icon: Icons.logout,
                  onTap: () {},
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

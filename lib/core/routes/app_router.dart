import 'package:go_router/go_router.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/pages/closing/closing_stock_page.dart';
import 'package:stock_app_web/pages/closing/closing_view_type.dart';
import 'package:stock_app_web/pages/current/current_stock_page.dart';
import 'package:stock_app_web/pages/form_49/form_49_page.dart';
import 'package:stock_app_web/pages/home/home_page.dart';
import 'package:stock_app_web/pages/indent_plan/indent_plan_page.dart';
import 'package:stock_app_web/pages/login/login_page.dart';
import 'package:stock_app_web/pages/opening/opening_stock_page.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_app_web/pages/opening/opening_view_type.dart';
import 'package:stock_app_web/pages/pos/pos_monthly_folder_page.dart';
import 'package:stock_app_web/pages/pos/pos_page.dart';
import 'package:stock_app_web/pages/pv_report/pv_report_page.dart';
import 'package:stock_app_web/pages/receipt/receipt_daily_folder_page.dart';
import 'package:stock_app_web/pages/receipt/receipt_monthly_folder_page.dart';
import 'package:stock_app_web/pages/receipt/receipt_stock_page.dart';
import 'package:stock_app_web/pages/reports/reports_page.dart';
import 'package:stock_app_web/pages/return_stock/return_stock_page.dart';
import 'package:stock_app_web/pages/sales/sales_stock_page.dart';
import 'package:stock_app_web/pages/shop_creation/shop_creation_page.dart';
import 'package:stock_app_web/pages/sms/sms_page.dart';
import 'package:stock_app_web/pages/summary/summary_page.dart';
import 'package:stock_app_web/pages/view_date/view_date_page.dart';
import 'package:stock_app_web/pages/welcome/welcome_page.dart';

final GoRouter appRouter = GoRouter(
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();

    final loggedIn = prefs.getBool('is_logged_in') ?? true;

    final isLoginPage = state.matchedLocation == AppRoutes.login;

    if (!loggedIn && !isLoginPage) {
      return AppRoutes.login;
    }

    if (loggedIn && isLoginPage) {
      return AppRoutes.home;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.welcome,
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: AppRoutes.shopCreation,
      builder: (context, state) => const ShopCreationPage(),
    ),
    GoRoute(
      path: AppRoutes.openingViewType,
      builder: (context, state) => const OpeningViewType(),
    ),
    GoRoute(
      path: AppRoutes.openingStock,
      builder: (context, state) => const OpeningStockPage(),
    ),
    GoRoute(
      path: AppRoutes.currentStock,
      builder: (context, state) => const CurrentStockPage(),
    ),
    GoRoute(
      path: AppRoutes.closingViewType,
      builder: (context, state) => const ClosingViewType(),
    ),
    GoRoute(
      path: AppRoutes.closingStock,
      builder: (context, state) => const ClosingStockPage(),
    ),
    GoRoute(
      path: AppRoutes.receiptMonthlyFolder,
      builder: (context, state) => const ReceiptMonthlyFolderPage(),
    ),
    GoRoute(
      path: AppRoutes.receiptDailyFolder,
      builder: (context, state) {
        Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return ReceiptDailyFolderPage(monthAndYear: data['monthAndYear']);
      },
    ),
    GoRoute(
      path: AppRoutes.receiptStock,
      builder: (context, state) => const ReceiptStockPage(),
    ),
    GoRoute(
      path: AppRoutes.salesStock,
      builder: (context, state) => const SalesStockPage(),
    ),
    GoRoute(
      path: AppRoutes.report,
      builder: (context, state) => const ReportsPage(),
    ),
    GoRoute(
      path: AppRoutes.form49,
      builder: (context, state) => const Form49Page(),
    ),
    GoRoute(
      path: AppRoutes.summary,
      builder: (context, state) => const SummaryPage(),
    ),
    GoRoute(path: AppRoutes.sms, builder: (context, state) => const SmsPage()),
    GoRoute(
      path: AppRoutes.pos,
      builder: (context, state) {
        Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return PosPage(monthAndYear: data['monthAndYear']);
      },
    ),
    GoRoute(
      path: AppRoutes.posMonthlyFolder,
      builder: (context, state) => const PosMonthlyFolderPage(),
    ),
    GoRoute(
      path: AppRoutes.pvReport,
      builder: (context, state) => const PvReportPage(),
    ),
    GoRoute(
      path: AppRoutes.indentPlan,
      builder: (context, state) => const IndentPlanPage(),
    ),
    GoRoute(
      path: AppRoutes.returnStock,
      builder: (context, state) => const ReturnStockPage(),
    ),
    GoRoute(
      path: AppRoutes.viewDate,
      builder: (context, state) => const ViewDatePage(),
    ),
  ],
);

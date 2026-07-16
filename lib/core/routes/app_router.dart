import 'package:go_router/go_router.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/pages/brand/add_brand_page.dart';
import 'package:stock_app_web/pages/brand/brand_page.dart';
import 'package:stock_app_web/pages/brand/edit_brand_page.dart';
import 'package:stock_app_web/pages/closing/add_closing_page.dart';
import 'package:stock_app_web/pages/closing/closing_stock_page.dart';
import 'package:stock_app_web/pages/closing/closing_view_type.dart';
import 'package:stock_app_web/pages/current/current_stock_page.dart';
import 'package:stock_app_web/pages/form_49/form_49_page.dart';
import 'package:stock_app_web/pages/home/home_page.dart';
import 'package:stock_app_web/pages/indent_plan/indent_plan_page.dart';
import 'package:stock_app_web/pages/login/login_page.dart';
import 'package:stock_app_web/pages/match_e2e_sales/match_e2e_sales_page.dart';
import 'package:stock_app_web/pages/opening/add_opening_page.dart';
import 'package:stock_app_web/pages/opening/edit_opening_page.dart';
import 'package:stock_app_web/pages/opening/opening_stock_page.dart';
import 'package:stock_app_web/pages/opening/opening_view_type.dart';
import 'package:stock_app_web/pages/pos/pos_monthly_folder_page.dart';
import 'package:stock_app_web/pages/pos/pos_page.dart';
import 'package:stock_app_web/pages/previous_day_cumulative/previous_day_cumulative_page.dart';
import 'package:stock_app_web/pages/pv_report/pv_report_page.dart';
import 'package:stock_app_web/pages/receipt/add_receipt_page.dart';
import 'package:stock_app_web/pages/receipt/edit_receipt_page.dart';
import 'package:stock_app_web/pages/receipt/receipt_daily_folder_page.dart';
import 'package:stock_app_web/pages/receipt/receipt_monthly_folder_page.dart';
import 'package:stock_app_web/pages/receipt/receipt_stock_page.dart';
import 'package:stock_app_web/pages/reports/reports_page.dart';
import 'package:stock_app_web/pages/return_stock/return_stock_page.dart';
import 'package:stock_app_web/pages/sales/add_sales_page.dart';
import 'package:stock_app_web/pages/sales/sales_stock_page.dart';
import 'package:stock_app_web/pages/settings/settings_page.dart';
import 'package:stock_app_web/pages/shop_creation/shop_creation_page.dart';
import 'package:stock_app_web/pages/sms/sms_page.dart';
import 'package:stock_app_web/pages/summary/summary_page.dart';
import 'package:stock_app_web/pages/support/support_page.dart';
import 'package:stock_app_web/pages/view_date/view_date_page.dart';
import 'package:stock_app_web/pages/welcome/welcome_page.dart';

final GoRouter appRouter = GoRouter(
  redirect: (context, state) async {
    String shopId = await getIt<ShopIdController>().getShopId();

    final isLoginPage = state.matchedLocation == AppRoutes.login;
    final isWelcomePage = state.matchedLocation == AppRoutes.welcome;
    final isShopCreation = state.matchedLocation == AppRoutes.shopCreation;

    if (shopId == '' && !isLoginPage && !isWelcomePage && !isShopCreation) {
      return AppRoutes.login;
    }

    if (shopId != '' && isLoginPage) {
      return '/$shopId/${AppRoutes.home}';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.home}',

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
      path: '/:shopId/${AppRoutes.openingViewType}',
      builder: (context, state) => const OpeningViewType(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.openingStock}',
      builder: (context, state) => const OpeningStockPage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.addOpeningStock}',
      builder: (context, state) => const AddOpeningPage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.editOpeningStock}',
      builder: (context, state) {
        Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return EditOpeningPage(editItem: data['data']);
      },
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.currentStock}',
      builder: (context, state) => const CurrentStockPage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.closingViewType}',
      builder: (context, state) => const ClosingViewType(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.closingStock}',
      builder: (context, state) => const ClosingStockPage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.addClosingStock}',
      builder: (context, state) => const AddClosingPage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.receiptMonthlyFolder}',
      builder: (context, state) => const ReceiptMonthlyFolderPage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.receiptDailyFolder}',
      builder: (context, state) {
        Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return ReceiptDailyFolderPage(monthAndYear: data['monthAndYear']);
      },
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.receiptStock}',
      builder: (context, state) {
        Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return ReceiptStockPage(date: data['date']);
      },
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.addReceiptStock}',
      builder: (context, state) => const AddReceiptPage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.editReceiptStock}',
      builder: (context, state) {
        Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return EditReceiptPage(product: data['product']);
      },
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.salesStock}',
      builder: (context, state) => const SalesStockPage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.addSalesStock}',
      builder: (context, state) => const AddSalesPage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.report}',
      builder: (context, state) => const ReportsPage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.form49}',
      builder: (context, state) => const Form49Page(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.summary}',
      builder: (context, state) => const SummaryPage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.sms}',
      builder: (context, state) => const SmsPage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.pos}',
      builder: (context, state) {
        Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return PosPage(monthAndYear: data['monthAndYear']);
      },
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.posMonthlyFolder}',
      builder: (context, state) => const PosMonthlyFolderPage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.pvReport}',
      builder: (context, state) => const PvReportPage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.indentPlan}',
      builder: (context, state) => const IndentPlanPage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.returnStock}',
      builder: (context, state) => const ReturnStockPage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.viewDate}',
      builder: (context, state) => const ViewDatePage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.brandStock}',
      builder: (context, state) => const BrandPage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.addBrandStock}',
      builder: (context, state) => const AddBrandPage(),
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.editBrandStock}',
      builder: (context, state) {
        Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return EditBrandPage(brandModel: data['brandModel']);
      },
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.previousDayCumulative}',
      builder: (context, state) {
        return PreviousDayCumulativePage();
      },
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.settings}',
      builder: (context, state) {
        return SettingsPage();
      },
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.matchE2ESalesPage}',
      builder: (context, state) {
        return MatchE2eSalesPage();
      },
    ),
    GoRoute(
      path: '/:shopId/${AppRoutes.supportPage}',
      builder: (context, state) {
        return SupportPage();
      },
    ),
  ],
);

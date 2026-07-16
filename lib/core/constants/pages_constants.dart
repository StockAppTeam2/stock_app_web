import 'package:stock_app_web/core/routes/app_routes.dart';

class PagesConstants {
  static const List pagesList = [
    'OPENING STOCK',
    'RECEIPT',
    'CLOSING STOCK',
    'SALES',
    'REPORTS',
    'FORM 49',
    'SMS',
    'SUMMARY',
    'POS',
    'PV REPORT',
    'MONTHLY DETAILS',
    'INDENT - PLAN',
    'RETURN STOCK',
  ];

  static const List pagesRouteList = [
    AppRoutes.openingViewType,
    AppRoutes.receiptMonthlyFolder,
    AppRoutes.closingViewType,
    AppRoutes.salesStock,
    AppRoutes.report,
    AppRoutes.form49,
    AppRoutes.sms,
    AppRoutes.summary,
    AppRoutes.posMonthlyFolder,
    AppRoutes.pvReport,
    AppRoutes.monthlyDetails,
    AppRoutes.indentPlan,
    AppRoutes.returnStock,
  ];
}

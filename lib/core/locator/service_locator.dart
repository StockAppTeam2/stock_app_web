import 'package:get_it/get_it.dart';
import 'package:stock_app_web/controllers/closing_page_controller.dart';
import 'package:stock_app_web/controllers/current_page_controller.dart';
import 'package:stock_app_web/controllers/home_page_controller.dart';
import 'package:stock_app_web/controllers/indent_controller.dart';
import 'package:stock_app_web/controllers/login_page_controller.dart';
import 'package:stock_app_web/controllers/opening_page_controller.dart';
import 'package:stock_app_web/controllers/pos_controller.dart';
import 'package:stock_app_web/controllers/previous_year_sales_cumulative_controller.dart';
import 'package:stock_app_web/controllers/pv_report_controller.dart';
import 'package:stock_app_web/controllers/receipt_controller.dart';
import 'package:stock_app_web/controllers/report_controller.dart';
import 'package:stock_app_web/controllers/return_stock_controller.dart';
import 'package:stock_app_web/controllers/sales_cumulative_controller.dart';
import 'package:stock_app_web/controllers/sales_page_controller.dart';
import 'package:stock_app_web/controllers/sms_controller.dart';
import 'package:stock_app_web/controllers/summary_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';
import 'package:stock_app_web/core/repositories/device_info_repository.dart';
import 'package:stock_app_web/core/repositories/download_pdf_repo.dart';
import 'package:stock_app_web/core/repositories/firestore_repo.dart';
import 'package:stock_app_web/core/repositories/user_repository.dart';
import 'package:stock_app_web/core/services/cache_service.dart';
import 'package:stock_app_web/core/services/device_info_service.dart';
import 'package:stock_app_web/core/services/firestore_service.dart';
import 'package:stock_app_web/core/services/firestore_service_items.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  //service
  getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());
  getIt.registerLazySingleton<FirestoreServiceItems>(
    () => FirestoreServiceItems(),
  );
  getIt.registerLazySingleton<DeviceInfoService>(() => DeviceInfoService());
  getIt.registerLazySingleton<CacheService>(() => CacheService());

  //repo
  getIt.registerLazySingleton<UserRepository>(() => UserRepository());
  getIt.registerLazySingleton<DeviceInfoRepository>(
    () => DeviceInfoRepository(),
  );
  getIt.registerLazySingleton<CacheRepository>(() => CacheRepository());
  getIt.registerLazySingleton<FirestoreRepo>(() => FirestoreRepo());
  getIt.registerLazySingleton<DownloadPdfRepo>(() => DownloadPdfRepo());

  // controller
  getIt.registerLazySingleton<LoginPageController>(() => LoginPageController());
  getIt.registerLazySingleton<ViewDateController>(() => ViewDateController());
  getIt.registerLazySingleton<HomePageController>(() => HomePageController());
  getIt.registerFactory<OpeningPageController>(() => OpeningPageController());
  getIt.registerLazySingleton<ClosingPageController>(
    () => ClosingPageController(),
  );
  getIt.registerLazySingleton<CurrentPageController>(
    () => CurrentPageController(),
  );
  getIt.registerLazySingleton<ReceiptController>(() => ReceiptController());
  getIt.registerLazySingleton<SalesPageController>(() => SalesPageController());
  getIt.registerLazySingleton<ReportController>(() => ReportController());
  getIt.registerLazySingleton<PosController>(() => PosController());
  getIt.registerLazySingleton<PreviousYearSalesCumulativeController>(
    () => PreviousYearSalesCumulativeController(),
  );
  getIt.registerLazySingleton<ReturnStockController>(
    () => ReturnStockController(),
  );
  getIt.registerLazySingleton<SalesCumulativeController>(
    () => SalesCumulativeController(),
  );
  getIt.registerLazySingleton<SummaryController>(() => SummaryController());
  getIt.registerLazySingleton<SmsController>(() => SmsController());
  getIt.registerLazySingleton<PvReportController>(() => PvReportController());
  getIt.registerLazySingleton<IndentController>(() => IndentController());
}

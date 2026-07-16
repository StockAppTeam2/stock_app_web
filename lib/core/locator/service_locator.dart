import 'package:get_it/get_it.dart';
import 'package:stock_app_web/controllers/brand_controller.dart';
import 'package:stock_app_web/controllers/closing_page_controller.dart';
import 'package:stock_app_web/controllers/current_page_controller.dart';
import 'package:stock_app_web/controllers/home_page_controller.dart';
import 'package:stock_app_web/controllers/indent_controller.dart';
import 'package:stock_app_web/controllers/login_page_controller.dart';
import 'package:stock_app_web/controllers/match_e2e_controller.dart';
import 'package:stock_app_web/controllers/opening_page_controller.dart';
import 'package:stock_app_web/controllers/pos_controller.dart';
import 'package:stock_app_web/controllers/previous_day_cumulative_controller.dart';
import 'package:stock_app_web/controllers/previous_year_sales_cumulative_controller.dart';
import 'package:stock_app_web/controllers/pv_report_controller.dart';
import 'package:stock_app_web/controllers/receipt_controller.dart';
import 'package:stock_app_web/controllers/report_controller.dart';
import 'package:stock_app_web/controllers/return_stock_controller.dart';
import 'package:stock_app_web/controllers/sales_cumulative_controller.dart';
import 'package:stock_app_web/controllers/sales_page_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/sms_controller.dart';
import 'package:stock_app_web/controllers/summary_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/repositories/Internet_connection_repo.dart';
import 'package:stock_app_web/core/repositories/brand_firestore_repo.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';
import 'package:stock_app_web/core/repositories/device_info_repository.dart';
import 'package:stock_app_web/core/repositories/download_pdf_repo.dart';
import 'package:stock_app_web/core/repositories/firestore_repo.dart';
import 'package:stock_app_web/core/repositories/opening_firestore_repo.dart';
import 'package:stock_app_web/core/repositories/purchase_firestore_repo.dart';
import 'package:stock_app_web/core/repositories/sales_firestore_repo.dart';
import 'package:stock_app_web/core/repositories/user_repository.dart';
import 'package:stock_app_web/core/services/local_cache_service.dart';
import 'package:stock_app_web/core/services/device_info_service.dart';
import 'package:stock_app_web/core/services/firestore_cache_service.dart';
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
  getIt.registerLazySingleton<LocalCacheService>(() => LocalCacheService());
  getIt.registerLazySingleton<FirestoreCacheService>(
    () => FirestoreCacheService(),
  );

  //repo
  getIt.registerLazySingleton<UserRepository>(() => UserRepository());
  getIt.registerLazySingleton<DeviceInfoRepository>(
    () => DeviceInfoRepository(),
  );
  getIt.registerLazySingleton<CacheRepository>(() => CacheRepository());
  getIt.registerLazySingleton<FirestoreRepo>(() => FirestoreRepo());
  getIt.registerLazySingleton<DownloadPdfRepo>(() => DownloadPdfRepo());
  getIt.registerLazySingleton<BrandFirestoreRepo>(() => BrandFirestoreRepo());
  getIt.registerLazySingleton<InternetConnectionRepo>(
    () => InternetConnectionRepo(),
  );
  getIt.registerLazySingleton<OpeningFirestoreRepo>(
    () => OpeningFirestoreRepo(),
  );
  getIt.registerLazySingleton<PurchaseFirestoreRepo>(
    () => PurchaseFirestoreRepo(),
  );
  getIt.registerLazySingleton<SalesFirestoreRepo>(() => SalesFirestoreRepo());

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
  getIt.registerLazySingleton<ShopIdController>(() => ShopIdController());
  getIt.registerLazySingleton<BrandController>(() => BrandController());
  getIt.registerLazySingleton<PreviousDayCumulativeController>(
    () => PreviousDayCumulativeController(),
  );
  getIt.registerLazySingleton<MatchE2eController>(() => MatchE2eController());
}

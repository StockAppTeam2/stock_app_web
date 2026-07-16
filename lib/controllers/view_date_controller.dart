import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';
import 'package:stock_app_web/core/repositories/firestore_repo.dart';

class ViewDateController {
  final fireRepo = getIt<FirestoreRepo>();
  final cacheRepo = getIt<CacheRepository>();

  List<String> viewDates = [];
  String? lastDate;

  bool isLoading = false;
  bool hasMore = true;

  final int pageSize = 15;
  final int maxDocs = 45;

  Future<String> getViewDateForUi() async {
    String viewDate = await cacheRepo.getStringCacheLocalAndFirebase(
      key: 'viewDateUi',
    );

    return viewDate;
  }

  Future<void> setViewDate(String date) async {
    await cacheRepo.addStringCacheLocalAndFirebase('viewDateUi', date);
  }

  Future<String> getMobileNumber() async {
    String viewDate = await cacheRepo.getStringCacheLocalAndFirebase(
      key: 'mobile_number',
    );

    return viewDate;
  }

  Future<List<String>> getDates(String? lastDate, int pageSize) async {
    final dates = await fireRepo.loadFirstPageViewDate(
      lastDate: lastDate,
      limit: pageSize,
    );
    return dates;
  }
}

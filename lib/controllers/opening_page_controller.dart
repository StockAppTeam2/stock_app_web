import 'package:flutter/material.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/cache_repository.dart';
import 'package:stock_app_web/core/repositories/download_pdf_repo.dart';
import 'package:stock_app_web/core/repositories/firestore_repo.dart';
import 'package:stock_app_web/models/items_table_model.dart';

class OpeningPageController {
  final _cache = getIt<CacheRepository>();
  final _fireRepo = getIt<FirestoreRepo>();
  final _downloadPdf = getIt<DownloadPdfRepo>();

  Future<void> addViewType(String key, String value) async {
    await _cache.addStringCache(key, value);
  }

  Future<String> getViewType(String key) async {
    return await _cache.getStringCache(key: key);
  }

  Future<List<ItemsViewModel>> getOpeningData(
    String date,
    String shopId,
  ) async {
    List<ItemsViewModel> data = await _fireRepo.getOpeningDoc(date, shopId);
    return data;
  }

  Future<void> downloadPdf(
    BuildContext context,
    bool isDailyStatement,
    bool isSmsPage,
  ) async {
    await _downloadPdf.downloadEmptyPdf(context, isDailyStatement, isSmsPage);
  }
}

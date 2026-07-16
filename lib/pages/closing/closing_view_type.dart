import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_app_web/controllers/closing_page_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/Internet_connection_repo.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class ClosingViewType extends StatefulWidget {
  const ClosingViewType({super.key});

  @override
  State<ClosingViewType> createState() => _OpeningViewTypeState();
}

class _OpeningViewTypeState extends State<ClosingViewType> {
  final _viewDateController = getIt<ViewDateController>();
  final _closingController = getIt<ClosingPageController>();
  final _internetConnectionRepo = getIt<InternetConnectionRepo>();

  String viewDate = '';

  @override
  void initState() {
    super.initState();
    checkSalseOrCb();
    _viewDateController.getViewDateForUi().then((value) {
      if (mounted) {
        setState(() => viewDate = value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Wrap(
              children: [
                const Text(
                  "CLOSING STOCK  ",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                Text('Date: $viewDate', style: TextStyle(fontSize: 28)),
              ],
            ),

            const SizedBox(height: 20),
            const SizedBox(height: 100),
            _buildTypeButton('CB Cases', 'cbCases'),
            _buildTypeButton('CB Bottles', 'cbBottles'),
            _buildTypeButton('CB Cases + Bottles', 'cbCasesBottles'),
            _buildTypeButton('CB Cases Bottles Total', 'cbCasesBottlesTotal'),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () => _navigateToOpeningStock(context, value),
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(260, 50),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(label, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  void checkSalseOrCb() async {
    bool isConnected = await _internetConnectionRepo.checkInternetConnection();
    String shopId = await getIt<ShopIdController>().getShopId();

    if (isConnected) {
      DocumentReference salesOrCb = FirebaseFirestore.instance
          .collection('items')
          .doc(shopId);
      DocumentSnapshot salesOrCbData = await salesOrCb.get();

      if (salesOrCbData.exists) {
        Map<String, dynamic> data =
            salesOrCbData.data() as Map<String, dynamic>;

        if (data.containsKey('EnterSales')) {
          bool salesEntryType = data['EnterSales'] as bool;

          if (salesEntryType == false) {
            context.go('/$shopId/${AppRoutes.addClosingStock}');
          }
        }
      }
    } else {
      showErrorToast('No Internet Connection');
    }
  }

  Future<void> _navigateToOpeningStock(
    BuildContext context,
    String viewType,
  ) async {
    String shopId = await getIt<ShopIdController>().getShopId();
    await _closingController.addViewType('cbViewType', viewType);
    if (!context.mounted) return;
    context.go('/$shopId/${AppRoutes.closingStock}');
  }
}

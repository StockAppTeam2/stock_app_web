import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_app_web/controllers/opening_page_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/utils/format_date.dart';

class OpeningViewType extends StatefulWidget {
  const OpeningViewType({super.key});

  @override
  State<OpeningViewType> createState() => _OpeningViewTypeState();
}

class _OpeningViewTypeState extends State<OpeningViewType> {
  final _viewDateController = getIt<ViewDateController>();
  final _openingController = getIt<OpeningPageController>();

  String viewDate = '';

  @override
  void initState() {
    super.initState();
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
                  "Opening Stock  ",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                if (viewDate != '')
                  Text(
                    'Date: ${formatYYYYMMDDToDDMMYYYY(viewDate)}',
                    style: TextStyle(fontSize: 28),
                  ),
              ],
            ),

            const SizedBox(height: 20),
            const SizedBox(height: 100),
            _buildTypeButton('OB Cases', 'obCases'),
            _buildTypeButton('OB Bottles', 'obBottles'),
            _buildTypeButton('OB Cases + Bottles', 'obCasesBottles'),
            _buildTypeButton('OB Cases Bottles Total', 'obCasesBottlesTotal'),
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

  Future<void> _navigateToOpeningStock(
    BuildContext context,
    String viewType,
  ) async {
    await _openingController.addViewType('obViewType', viewType);
    if (!context.mounted) return;
    context.go(AppRoutes.openingStock);
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_app_web/controllers/opening_page_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/utils/format_date.dart';
import 'package:stock_app_web/core/utils/responsive.dart';
import 'package:stock_app_web/pages/widgets/youtube_button.dart';

class PageHeader extends StatelessWidget {
  final String page;
  final String title;
  final Function(String) query;
  final String viewDate;
  final String videoLink;
  final String invoiceNo;
  final bool showReport;

  const PageHeader({
    super.key,
    required this.page,
    required this.title,
    required this.query,
    required this.viewDate,
    required this.videoLink,
    required this.invoiceNo,
    required this.showReport,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        return Responsive.isDesktop(context)
            ? Row(
                children: [
                  _title(title),

                  const Spacer(),

                  _buttons(context),

                  const SizedBox(width: 20),
                  if (showReport)
                    SearchBox(
                      onChanged: (String value) {
                        query(value);
                      },
                    ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(title),

                  const SizedBox(height: 15),

                  _buttons(context),

                  const SizedBox(height: 15),
                  if (showReport)
                    SearchBox(
                      onChanged: (String value) {
                        query(value);
                      },
                    ),
                ],
              );
      },
    );
  }

  Widget _title(String title) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        if (viewDate != '')
          Text(
            formatYYYYMMDDToDDMMYYYY(viewDate),
            style: TextStyle(fontSize: 22),
          ),
        if (page == 'receipt_stock')
          Text('  Invoice No: $invoiceNo', style: TextStyle(fontSize: 22)),
      ],
    );
  }

  Widget _buttons(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (page == 'opening_stock')
          AppButton(
            title: "PDF",
            icon: Icons.picture_as_pdf,
            onPressed: () async {
              final openingController = getIt<OpeningPageController>();
              await openingController.downloadPdf(context, false, false);
            },
          ),
        if (page == 'report')
          AppButton(
            title: "PDF",
            icon: Icons.picture_as_pdf,
            onPressed: () async {
              final openingController = getIt<OpeningPageController>();
              await openingController.downloadPdf(context, true, false);
            },
          ),
        if (page == 'form_49')
          AppButton(
            title: "Add Last Year Cumulative",
            icon: Icons.add,
            onPressed: () async {
              //
            },
          ),
        if (page == 'opening_stock')
          AppButton(
            title: "View OB + Receipt",
            icon: Icons.receipt_long,
            onPressed: () {
              context.go(AppRoutes.currentStock);
            },
          ),
        if (page == 'closing_stock')
          AppButton(
            title: "Total Unscanned",
            icon: Icons.receipt_long,
            onPressed: () {
              //
            },
          ),
        if (page == 'sales_stock')
          AppButton(
            title: "view O - S = CB",
            icon: Icons.receipt_long,
            onPressed: () {
              //
            },
          ),
        if (videoLink != '') YoutubeButton(url: videoLink),
      ],
    );
  }
}

class SearchBox extends StatefulWidget {
  final Function(String value) onChanged;

  const SearchBox({super.key, required this.onChanged});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 42,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: "Search Brand",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () {
              _controller.clear();
              widget.onChanged("");
            },
            icon: const Icon(Icons.close),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onChanged: (value) {
          widget.onChanged(value);
        },
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const AppButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 18), const SizedBox(width: 6), Text(title)],
    );

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
      ),
      child: child,
    );
  }
}

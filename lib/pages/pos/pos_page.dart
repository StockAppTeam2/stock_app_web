import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_app_web/controllers/pos_controller.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/controllers/view_date_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/utils/format_date.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/models/pos_model.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class PosPage extends StatefulWidget {
  final String monthAndYear;

  const PosPage({super.key, required this.monthAndYear});

  @override
  State<PosPage> createState() => _PosPageState();
}

class _PosPageState extends State<PosPage> {
  final posController = getIt<PosController>();
  final _viewDateController = getIt<ViewDateController>();

  String viewDate = '';

  @override
  void initState() {
    super.initState();
    getViewDate();
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<NewPosModel>>(
                future: getPosData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  final pos = snapshot.data ?? [];

                  if (pos.isEmpty) {
                    return const Center(child: Text("No Data Found"));
                  }

                  return GridView.builder(
                    itemCount: pos.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 500,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 2.3,
                    ),
                    itemBuilder: (_, index) {
                      final item = pos[index];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                            // color: Colors.black,
                            // width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(formatYYYYMMDDToDDMMYYYY(item.posDate)),
                                  if (index == 0)
                                    PopupMenuButton<String>(
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: Colors.blue,
                                      ),
                                      onSelected: (value) async {
                                        if (value == "Edit") {
                                          String shopId =
                                              await getIt<ShopIdController>()
                                                  .getShopId();
                                          if (!context.mounted) return;
                                          context.go(
                                            '/$shopId/${AppRoutes.editPos}',
                                            extra: {'posData': item},
                                          );
                                        } else {
                                          deletePopup(context, item);
                                        }
                                      },
                                      itemBuilder: (_) => [
                                        const PopupMenuItem(
                                          value: "Edit",
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                color: Colors.green,
                                              ),
                                              SizedBox(width: 10),
                                              Text("Edit"),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: "Delete",
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              SizedBox(width: 10),
                                              Text("Delete"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildRow('POS Value', '${item.posValue}'),
                              const SizedBox(height: 12),
                              item.posCumulative == 0
                                  ? Text('data')
                                  : _buildRow(
                                      'POS Cumulative',
                                      '${item.posCumulative}',
                                    ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<NewPosModel>> getPosData() async {
    List<NewPosModel> posData = await posController.getPosData(
      widget.monthAndYear,
    );
    return posData.reversed.toList();
  }

  Widget _buildRow(String title, String value) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const Text(':'),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Text nameText(String text) {
    return Text(text, style: TextStyle(fontSize: 20, color: Colors.black));
  }

  Text colonText() {
    return Text(
      '  :  ',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  TableRow spaceRow() {
    return const TableRow(
      children: [SizedBox(height: 2), SizedBox(height: 2), SizedBox(height: 2)],
    );
  }

  RichText valueText(String text) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Rs. ',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          TextSpan(
            text: text,
            style: TextStyle(fontSize: 20, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  TableRow emptyTableRow() =>
      const TableRow(children: [SizedBox(), SizedBox(), SizedBox()]);

  void getViewDate() async {
    String value = await _viewDateController.getViewDateForUi();
    print('viewdate: $value');
    if (mounted) {
      setState(() => viewDate = value);
    }
  }

  void deletePopup(BuildContext context, NewPosModel product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Do You Want To Delete The Product?'),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await posController.deletePos(product);
                if (!context.mounted) return;
                Navigator.pop(context);

                showSuccessToast('Item Deleted Successfully');
                getPosData();
                setState(() {});
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stock_app_web/controllers/shop_id_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/Internet_connection_repo.dart';
import 'package:stock_app_web/models/items_table_model.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

Widget buildClosingCard({
  required String title,
  required String value,
  required bool checked,
  required ValueChanged<bool> onChanged,
}) {
  return Column(
    children: [
      Text(title, style: const TextStyle(fontSize: 20)),

      Text(
        value,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedScale(
            scale: 1.8,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
            child: Checkbox(
              value: checked,
              activeColor: Colors.green,
              onChanged: (v) {
                if (v != null) {
                  onChanged(v);
                }
              },
            ),
          ),
        ],
      ),
    ],
  );
}

Widget buildCaseBottleCard({
  required BuildContext context,
  required ItemsViewModel item,
  required ValueChanged<bool> onChanged,
  required bool checked,
}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                const Text("CASE", style: TextStyle(fontSize: 18)),
                FittedBox(
                  child: Text(
                    item.closingBundle == -1
                        ? ""
                        : item.closingBundle.toString(),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              children: [
                const FittedBox(
                  child: Text("BOTTLE", style: TextStyle(fontSize: 18)),
                ),
                FittedBox(
                  child: Text(
                    item.closingRetail == -1
                        ? ""
                        : item.closingRetail.toString(),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedScale(
            scale: 1.8,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
            child: Checkbox(
              value: checked,
              activeColor: Colors.green,
              onChanged: (v) {
                if (v != null) {
                  onChanged(v);
                }
              },
            ),
          ),
        ],
      ),
    ],
  );
}

Widget buildTotalCard({
  required BuildContext context,
  required ItemsViewModel item,
  required double width,
  required bool showMenu,
  required VoidCallback onEdit,
  required VoidCallback onDelete,
}) {
  return Column(
    spacing: 0.0,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 18),
              children: [
                TextSpan(text: 'Case : '),
                TextSpan(
                  text: item.closingBundle.toString(),
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          if (showMenu)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.blue),
              onSelected: (value) {
                if (value == "Edit") {
                  onEdit();
                } else {
                  onDelete();
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: "Edit",
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.green),
                      SizedBox(width: 10),
                      Text("Edit"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: "Delete",
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 10),
                      Text("Delete"),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),

      RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 18),
          children: [
            TextSpan(text: 'Bottle : '),
            TextSpan(
              text: item.closingRetail.toString(),
              style: TextStyle(
                color: Colors.green,

                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 5),

      RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 18),
          children: [
            TextSpan(text: "Total Bottle : "),
            TextSpan(
              text: item.totalCloseRetailUnits.toString(),
              style: TextStyle(
                color: Colors.purple,

                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      const Divider(),

      Row(
        children: [
          Text('Rs.', style: TextStyle(color: Colors.black, fontSize: 18)),
          Text(
            (item.totalPriceClosing).toString(),
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    ],
  );
}

class UnscannedButton extends StatelessWidget {
  final TextEditingController controller;
  final ItemsViewModel closingStockData;
  final GlobalKey<FormState> formKey;
  final Function(int) onUpdated;

  const UnscannedButton({
    super.key,
    required this.controller,
    required this.closingStockData,
    required this.formKey,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final internetConnectionRepo = getIt<InternetConnectionRepo>();
        bool isConnected = await internetConnectionRepo
            .checkInternetConnection();

        if (isConnected) {
          controller.text = closingStockData.unscannedEntry == 0
              ? ''
              : closingStockData.unscannedEntry.toString();

          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text('Enter Unscanned Bottles'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Form(
                          key: formKey,
                          child: TextFormField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            validator: (val) {
                              if (val == null ||
                                  val.isEmpty ||
                                  int.tryParse(val) == null ||
                                  int.tryParse(val)!.isNegative) {
                                return 'please Enter Value';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    actionsAlignment: MainAxisAlignment.spaceBetween,
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          // setState(() {
                          //   loadingUnscanned = true;
                          // });
                          if (formKey.currentState!.validate()) {
                            if (closingStockData.totalCloseRetailUnits >=
                                int.parse(controller.text)) {
                              String shopId = await getIt<ShopIdController>()
                                  .getShopId();
                              //fire
                              DocumentReference documentReference =
                                  FirebaseFirestore.instance
                                      .collection('items')
                                      .doc(shopId)
                                      .collection('date')
                                      .doc(closingStockData.date);
                              DocumentSnapshot documentSnap =
                                  await documentReference.get();
                              if (documentSnap.exists) {
                                Map<String, dynamic> data =
                                    documentSnap.data() as Map<String, dynamic>;
                                if (data.isNotEmpty) {
                                  if (data.containsKey(
                                    closingStockData.productId.toString(),
                                  )) {
                                    Map<String, dynamic> newData = {};
                                    newData[closingStockData.productId
                                        .toString()] = {
                                      'unscannedEntry': int.parse(
                                        controller.text,
                                      ),
                                    };
                                    await documentReference.set(
                                      newData,
                                      SetOptions(merge: true),
                                    );
                                  }
                                }
                              }
                              showSuccessToast('Data Added Successfully');
                              onUpdated(int.tryParse(controller.text)!);
                              Navigator.of(context).pop();
                            } else {
                              showErrorToast('Please Check The Values');
                            }
                          }
                          // setState(() {
                          //   loadingUnscanned = false;
                          // });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Ok'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        } else {
          showErrorToast('No Internet Connection');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6), // adjust radius here
        ),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 20),
          children: [
            const TextSpan(
              text: 'unscanned ',
              style: TextStyle(color: Colors.blue),
            ),
            closingStockData.unscannedEntry != 0
                ? TextSpan(
                    text: '(${closingStockData.unscannedEntry})',
                    style: TextStyle(color: Colors.brown.shade900),
                  )
                : const TextSpan(text: ''),
          ],
        ),
      ),
    );
  }
}

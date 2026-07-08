import 'package:flutter/material.dart';
import 'package:stock_app_web/models/items_table_model.dart';

Widget buildOpeningCard({
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

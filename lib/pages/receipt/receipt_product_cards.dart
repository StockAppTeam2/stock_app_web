import 'package:flutter/material.dart';
import 'package:stock_app_web/models/inward_table_model.dart';

Widget buildTotalCard({
  required BuildContext context,
  required InwardViewModel item,
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
                  text: item.inwardBundle.toString(),
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
              text: item.inwardRetail.toString(),
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
              text: item.totalInwardRetailUnits.toString(),
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
            (item.totalPriceInward).toString(),
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

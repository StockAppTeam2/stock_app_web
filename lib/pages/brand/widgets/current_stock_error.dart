import 'package:flutter/material.dart';

void currentStockError(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Note !'),
        content: const Text(
          "The user is allowed to Delete the item when there is no stock available.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

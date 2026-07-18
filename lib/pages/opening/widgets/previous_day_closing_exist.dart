import 'package:flutter/material.dart';

void showPreviousDayClosingIsMissing(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Previous Day Closing is Missing",
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("ok", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

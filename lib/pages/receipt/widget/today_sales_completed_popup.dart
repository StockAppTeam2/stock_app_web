import 'package:flutter/material.dart';

void todaySalesCompleted(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Today Sales Is Started Or Completed.\nUser Not Allowed to Add Purchase.',
                style: const TextStyle(fontSize: 22),
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
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

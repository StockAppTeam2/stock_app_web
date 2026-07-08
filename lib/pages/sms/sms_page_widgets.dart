import 'package:flutter/material.dart';

Text nameText(String text) {
  return Text(text, style: TextStyle(fontSize: 18, color: Colors.black54));
}

Text colonText() {
  return Text(':', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
}

Text valueText(int number) {
  print('number1 $number');
  return Text(
    number.isNegative ? '0' : number.toString(),
    textAlign: TextAlign.end,
    style: TextStyle(fontSize: 18, color: Colors.blue[900]),
  );
}

String formatValue(String value) {
  return value.startsWith('Rs') ? value : 'Rs $value';
}

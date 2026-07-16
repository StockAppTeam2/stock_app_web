import 'package:flutter/services.dart';

class UppercaseNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Convert to uppercase
    String newText = newValue.text.toUpperCase();
    // Keep only uppercase letters and numbers
    newText = newText.replaceAll(RegExp(r'[^A-Z0-9]'), '');

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

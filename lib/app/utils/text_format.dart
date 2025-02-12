import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    String formattedText = text.replaceAllMapped(
        RegExp(r'^(\d{1,3})(\d{1,3})?(\d{1,4})?'), (Match match) {
      String result = match.group(1)!;
      if (match.group(2) != null) result += ' ${match.group(2)}';
      if (match.group(3) != null) result += ' ${match.group(3)}';
      return result;
    });
    return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length));
  }

  String formatPhoneNumber(String phone) {
    // Format with spaces for readability
    return phone.replaceAllMapped(RegExp(r'^(\d{1,3})(\d{1,3})?(\d{1,4})?'),
        (Match match) {
      String result = match.group(1)!;
      if (match.group(2) != null) result += ' ${match.group(2)}';
      if (match.group(3) != null) result += ' ${match.group(3)}';
      return result;
    });
  }
}

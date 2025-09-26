import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final String currency;

  CurrencyInputFormatter(this.currency);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Split integer and decimal parts
    final parts = newText.split('.');
    final intPart = parts[0];
    final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    // Choose formatter based on currency
    final formatter = NumberFormat.currency(
      locale: currency == '₹' ? 'en_IN' : 'en_US',
      symbol: '',
      decimalDigits: 0,
    );

    // Format only integer part
    final formattedInt = formatter.format(int.parse(intPart)).trim();

    final formatted = formattedInt + decimalPart;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'en_KE',
    symbol: 'KSH ',
    decimalDigits: 2,
  );

  static final NumberFormat _compactFormatter = NumberFormat.currency(
    locale: 'en_KE',
    symbol: 'KSH ',
    decimalDigits: 0,
  );

  /// Format amount with KSH symbol and 2 decimal places
  /// Example: 1234.56 -> "KSH 1,234.56"
  static String format(double amount) {
    return _formatter.format(amount);
  }

  /// Format amount with KSH symbol but no decimals
  /// Example: 1234.56 -> "KSH 1,235"
  static String formatCompact(double amount) {
    return _compactFormatter.format(amount);
  }

  /// Format amount with KSH symbol, useful for large amounts
  /// Example: 1234567.89 -> "KSH 1.23M"
  static String formatShort(double amount) {
    if (amount >= 1000000) {
      return 'KSH ${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return 'KSH ${(amount / 1000).toStringAsFixed(1)}K';
    }
    return format(amount);
  }

  /// Get just the symbol
  static String get symbol => 'KSH ';
}

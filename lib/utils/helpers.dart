import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/colors.dart';

class Helpers {
  // Format Currency
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: 'KSH ',
      decimalDigits: 2,
      locale: 'en_KE',
    );
    return formatter.format(amount);
  }
  
  // Format Currency Compact (no decimals)
  static String formatCurrencyCompact(double amount) {
    final formatter = NumberFormat.currency(
      symbol: 'KSH ',
      decimalDigits: 0,
      locale: 'en_KE',
    );
    return formatter.format(amount);
  }
  
  // Format Date
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
  
  // Format Date with Time
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy hh:mm a').format(date);
  }
  
  // Format Time
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }
  
  // Relative Time (e.g., "2 hours ago")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} ${(difference.inDays / 365).floor() == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ${(difference.inDays / 30).floor() == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
  
  // Get Order Status Color
  static Color getOrderStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.pending;
      case 'processing':
        return AppColors.processing;
      case 'shipped':
        return AppColors.shipped;
      case 'delivered':
        return AppColors.delivered;
      case 'cancelled':
        return AppColors.cancelled;
      default:
        return AppColors.textSecondary;
    }
  }
  
  // Get Order Status Display Text
  static String getOrderStatusText(String status) {
    return status[0].toUpperCase() + status.substring(1);
  }
  
  // Show Snackbar
  static void showSnackbar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  // Show Error Dialog
  static void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  // Show Confirmation Dialog
  static Future<bool> showConfirmDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
  
  // Truncate Text
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
  
  // Validate Image Size
  static bool isValidImageSize(int sizeInBytes, int maxSizeInBytes) {
    return sizeInBytes <= maxSizeInBytes;
  }
  
  // Get Initials from Name
  static String getInitials(String name) {
    if (name.isEmpty) return '';
    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }
  
  // Hide Keyboard
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}

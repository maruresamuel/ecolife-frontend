import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF60AD5E);
  static const Color primaryDark = Color(0xFF005005);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF81C784);
  static const Color secondaryLight = Color(0xFFB2FAB4);
  static const Color secondaryDark = Color(0xFF519657);
  
  // Accent Colors
  static const Color accent = Color(0xFFFFB300);
  static const Color accentLight = Color(0xFFFFE54C);
  
  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFBDBDBD);
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Order Status Colors
  static const Color pending = Color(0xFFFF9800);
  static const Color processing = Color(0xFF2196F3);
  static const Color shipped = Color(0xFF9C27B0);
  static const Color delivered = Color(0xFF4CAF50);
  static const Color cancelled = Color(0xFFF44336);
  
  // Other Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x80000000);
  
  // White color getter for consistency
  static Color get white => surface;
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

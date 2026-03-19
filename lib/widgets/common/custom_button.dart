import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

enum ButtonSize { small, medium, large }
enum ButtonType { primary, secondary, outline, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
  });
  
  @override
  Widget build(BuildContext context) {
    final height = _getHeight();
    final textStyle = _getTextStyle();
    final decoration = _getDecoration();
    
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: decoration['backgroundColor'],
          foregroundColor: decoration['foregroundColor'],
          elevation: decoration['elevation'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            side: decoration['borderSide'] ?? BorderSide.none,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingMd,
            vertical: 0,
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    decoration['foregroundColor'],
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[                    Icon(icon, size: AppSpacing.iconSm),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(text, style: textStyle),
                ],
              ),
      ),
    );
  }
  
  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return AppSpacing.buttonHeightSm;
      case ButtonSize.medium:
        return AppSpacing.buttonHeightMd;
      case ButtonSize.large:
        return AppSpacing.buttonHeightLg;
    }
  }
  
  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return AppTypography.buttonSmall;
      case ButtonSize.medium:
        return AppTypography.buttonMedium;
      case ButtonSize.large:
        return AppTypography.buttonLarge;
    }
  }
  
  Map<String, dynamic> _getDecoration() {
    switch (type) {
      case ButtonType.primary:
        return {
          'backgroundColor': AppColors.primary,
          'foregroundColor': AppColors.textWhite,
          'elevation': 2.0,
        };
      case ButtonType.secondary:
        return {
          'backgroundColor': AppColors.secondary,
          'foregroundColor': AppColors.textWhite,
          'elevation': 2.0,
        };
      case ButtonType.outline:
        return {
          'backgroundColor': Colors.transparent,
          'foregroundColor': AppColors.primary,
          'elevation': 0.0,
          'borderSide': const BorderSide(color: AppColors.primary, width: 1.5),
        };
      case ButtonType.text:
        return {
          'backgroundColor': Colors.transparent,
          'foregroundColor': AppColors.primary,
          'elevation': 0.0,
        };
    }
  }
}

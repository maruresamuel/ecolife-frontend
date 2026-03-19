import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class OrderStatusBadge extends StatelessWidget {
  final String status;
  final bool isLarge;

  const OrderStatusBadge({
    super.key,
    required this.status,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? AppSpacing.md : AppSpacing.sm,
        vertical: isLarge ? AppSpacing.sm : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: config.color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size: isLarge ? 18 : 14,
            color: config.color,
          ),
          SizedBox(width: AppSpacing.xs),
          Text(
            config.label,
            style: (isLarge ? AppTypography.bodyMedium : AppTypography.caption).copyWith(
              color: config.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return _StatusConfig(
          label: 'Pending',
          color: AppColors.warning,
          icon: Icons.pending_actions,
        );
      case 'processing':
        return _StatusConfig(
          label: 'Processing',
          color: AppColors.info,
          icon: Icons.autorenew,
        );
      case 'shipped':
        return _StatusConfig(
          label: 'Shipped',
          color: AppColors.secondary,
          icon: Icons.local_shipping,
        );
      case 'delivered':
        return _StatusConfig(
          label: 'Delivered',
          color: AppColors.success,
          icon: Icons.check_circle,
        );
      case 'cancelled':
        return _StatusConfig(
          label: 'Cancelled',
          color: AppColors.error,
          icon: Icons.cancel,
        );
      default:
        return _StatusConfig(
          label: status,
          color: AppColors.textSecondary,
          icon: Icons.help_outline,
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;
  final IconData icon;

  _StatusConfig({
    required this.label,
    required this.color,
    required this.icon,
  });
}

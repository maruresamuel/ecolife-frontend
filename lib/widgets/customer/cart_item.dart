import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/cart_provider.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../utils/helpers.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback? onRemove;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  
  const CartItemWidget({
    super.key,
    required this.item,
    this.onRemove,
    this.onIncrement,
    this.onDecrement,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: item.product.image != null && item.product.image!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: item.product.image!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 80,
                        height: 80,
                        color: AppColors.background,
                        child: const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 80,
                        height: 80,
                        color: AppColors.background,
                        child: const Icon(
                          Icons.broken_image,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: AppColors.background,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: AppColors.textSecondary,
                      ),
                    ),
            ),
            const SizedBox(width: AppSpacing.md),
            
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: AppTypography.h6,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    Helpers.formatCurrency(item.product.price),
                    style: AppTypography.priceSmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  
                  // Quantity Controls
                  Row(
                    children: [
                      IconButton(
                        onPressed: onDecrement,
                        icon: const Icon(Icons.remove_circle_outline),
                        color: AppColors.primary,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: Text(
                          '${item.quantity}',
                          style: AppTypography.h6,
                        ),
                      ),
                      IconButton(
                        onPressed: onIncrement,
                        icon: const Icon(Icons.add_circle_outline),
                        color: AppColors.primary,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: onRemove,
                        icon: const Icon(Icons.delete_outline),
                        color: AppColors.error,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../utils/constants.dart';

class FilterBar extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback? onClearFilters;
  
  const FilterBar({
    super.key,
    this.selectedCategory,
    required this.onCategoryChanged,
    this.onClearFilters,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          // All Categories
          _buildChip(
            label: 'All',
            isSelected: selectedCategory == null,
            onTap: () => onCategoryChanged(null),
          ),
          const SizedBox(width: AppSpacing.sm),
          
          // Category Chips
          ...AppConstants.productCategories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: _buildChip(
                label: category,
                isSelected: selectedCategory == category,
                onTap: () => onCategoryChanged(category),
              ),
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class EcoFilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onApplyFilters;

  const EcoFilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onApplyFilters,
  });

  @override
  State<EcoFilterBottomSheet> createState() => _EcoFilterBottomSheetState();
}

class _EcoFilterBottomSheetState extends State<EcoFilterBottomSheet> {
  late Map<String, dynamic> filters;

  @override
  void initState() {
    super.initState();
    filters = Map.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrganicFilter(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildCertificationFilter(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildSustainabilityScoreFilter(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildPackagingFilter(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildOriginFilter(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildSortByFilter(),
                ],
              ),
            ),
          ),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_list, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Eco-Friendly Filters',
            style: AppTypography.h3.copyWith(color: AppColors.primary),
          ),
          const Spacer(),
          TextButton(
            onPressed: _resetFilters,
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrganicFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Organic Products Only', style: AppTypography.bodyMedium),
        SwitchListTile(
          value: filters['isOrganic'] ?? false,
          onChanged: (value) {
            setState(() {
              filters['isOrganic'] = value;
            });
          },
          title: const Text('Show only organic products'),
          activeColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildCertificationFilter() {
    final certifications = [
      'USDA Organic',
      'Fair Trade',
      'Carbon Neutral',
      'Rainforest Alliance',
      'B Corporation',
      'Leaping Bunny',
      'FSC Certified',
      'Non-GMO',
      'Vegan',
      'Cruelty-Free',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Certifications', style: AppTypography.bodyMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: certifications.map((cert) {
            final isSelected = filters['certification'] == cert;
            return FilterChip(
              label: Text(cert),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  filters['certification'] = selected ? cert : null;
                });
              },
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSustainabilityScoreFilter() {
    final score = filters['minSustainabilityScore'] ?? 0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Minimum Sustainability Score', style: AppTypography.bodyMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: score.toDouble(),
                min: 0,
                max: 100,
                divisions: 20,
                label: score.toString(),
                activeColor: AppColors.primary,
                onChanged: (value) {
                  setState(() {
                    filters['minSustainabilityScore'] = value.toInt();
                  });
                },
              ),
            ),
            SizedBox(
              width: 60,
              child: Text(
                '$score / 100',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPackagingFilter() {
    final packagingOptions = [
      'All',
      'Biodegradable',
      'Recyclable',
      'Compostable',
      'Reusable',
      'Plastic-Free',
      'Minimal',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Packaging Type', style: AppTypography.bodyMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: packagingOptions.map((packaging) {
            final isSelected = (filters['packaging'] ?? 'All') == packaging;
            return ChoiceChip(
              label: Text(packaging),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  filters['packaging'] = selected ? packaging : 'All';
                });
              },
              selectedColor: AppColors.primary.withOpacity(0.2),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOriginFilter() {
    final originOptions = ['All', 'Local', 'Regional', 'National', 'International'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Origin', style: AppTypography.bodyMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: originOptions.map((origin) {
            final isSelected = (filters['origin'] ?? 'All') == origin;
            return ChoiceChip(
              label: Text(origin),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  filters['origin'] = selected ? origin : 'All';
                });
              },
              selectedColor: AppColors.primary.withOpacity(0.2),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSortByFilter() {
    final sortOptions = {
      'newest': 'Newest First',
      'price_asc': 'Price: Low to High',
      'price_desc': 'Price: High to Low',
      'name': 'Name A-Z',
      'sustainability': 'Sustainability Score',
      'carbon_footprint': 'Carbon Footprint (Low First)',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sort By', style: AppTypography.bodyMedium),
        const SizedBox(height: AppSpacing.sm),
        ...sortOptions.entries.map((entry) {
          return RadioListTile<String>(
            value: entry.key,
            groupValue: filters['sortBy'] ?? 'newest',
            onChanged: (value) {
              setState(() {
                filters['sortBy'] = value;
              });
            },
            title: Text(entry.value),
            activeColor: AppColors.primary,
            dense: true,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                widget.onApplyFilters(filters);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      filters = {
        'isOrganic': false,
        'certification': null,
        'minSustainabilityScore': 0,
        'packaging': 'All',
        'origin': 'All',
        'sortBy': 'newest',
      };
    });
  }
}

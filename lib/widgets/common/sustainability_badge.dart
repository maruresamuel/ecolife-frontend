import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../models/product_model.dart';

class SustainabilityBadge extends StatelessWidget {
  final ProductModel product;
  final bool showDetails;

  const SustainabilityBadge({
    super.key,
    required this.product,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    if (product.sustainabilityScore == 0 && !product.isOrganic && product.certifications.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Organic Badge
        if (product.isOrganic)
          _buildBadge(
            icon: Icons.eco,
            label: 'Organic',
            color: Colors.green,
          ),
        const SizedBox(height: AppSpacing.xs),
        
        // Sustainability Score
        if (product.sustainabilityScore > 0)
          _buildScoreBadge(),
        const SizedBox(height: AppSpacing.xs),
        
        // Certifications
        if (product.certifications.isNotEmpty && showDetails)
          _buildCertifications(),
        
        // Carbon Footprint
        if (product.carbonFootprint > 0 && showDetails)
          _buildCarbonFootprint(),
        
        // Packaging
        if (product.packaging != 'Standard' && showDetails)
          _buildPackagingInfo(),
        
        // Origin
        if (showDetails)
          _buildOriginInfo(),
      ],
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBadge() {
    final score = product.sustainabilityScore;
    Color color;
    IconData icon;
    
    if (score >= 80) {
      color = Colors.green[700]!;
      icon = Icons.verified;
    } else if (score >= 60) {
      color = Colors.lightGreen[700]!;
      icon = Icons.thumb_up;
    } else if (score >= 40) {
      color = Colors.orange[700]!;
      icon = Icons.recommend;
    } else {
      color = Colors.grey[600]!;
      icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '${product.sustainabilityLevel} ($score/100)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertifications() {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: product.certifications.map((cert) {
        return Chip(
          label: Text(
            cert,
            style: const TextStyle(fontSize: 10),
          ),
          padding: const EdgeInsets.all(4),
          backgroundColor: AppColors.primary.withOpacity(0.1),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }

  Widget _buildCarbonFootprint() {
    final level = product.carbonFootprintLevel;
    Color color;
    
    if (level == 'Low') {
      color = Colors.green;
    } else if (level == 'Medium') {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Row(
      children: [
        Icon(Icons.co2, size: 16, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '${product.carbonFootprint.toStringAsFixed(1)} kg CO₂ ($level)',
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPackagingInfo() {
    IconData icon;
    Color color = Colors.green;
    
    switch (product.packaging) {
      case 'Biodegradable':
        icon = Icons.recycling;
        break;
      case 'Recyclable':
        icon = Icons.restore;
        break;
      case 'Compostable':
        icon = Icons.compost;
        break;
      case 'Reusable':
        icon = Icons.loop;
        break;
      case 'Plastic-Free':
        icon = Icons.no_backpack;
        break;
      case 'Minimal':
        icon = Icons.minimize;
        break;
      default:
        icon = Icons.inventory_2;
        color = Colors.grey;
    }

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(
          product.packaging,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildOriginInfo() {
    IconData icon;
    Color color;
    
    switch (product.origin) {
      case 'Local':
        icon = Icons.location_on;
        color = Colors.green;
        break;
      case 'Regional':
        icon = Icons.location_city;
        color = Colors.lightGreen;
        break;
      case 'National':
        icon = Icons.flag;
        color = Colors.orange;
        break;
      default:
        icon = Icons.public;
        color = Colors.grey;
    }

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(
          product.origin,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

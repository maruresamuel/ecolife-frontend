import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class EnvironmentalImpactScreen extends StatelessWidget {
  const EnvironmentalImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Environmental Impact'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: AppSpacing.xl),
            _buildSection(
              title: 'Why Buy Eco-Friendly?',
              icon: Icons.eco,
              color: Colors.green,
              content: [
                _buildBulletPoint(
                  'Reduce plastic waste and ocean pollution',
                ),
                _buildBulletPoint(
                  'Support sustainable farming practices',
                ),
                _buildBulletPoint(
                  'Lower carbon footprint and greenhouse gases',
                ),
                _buildBulletPoint(
                  'Promote biodiversity and ecosystem health',
                ),
                _buildBulletPoint(
                  'Support local farmers and reduce transportation emissions',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildSection(
              title: 'Understanding Certifications',
              icon: Icons.verified,
              color: Colors.blue,
              content: [
                _buildCertificationCard(
                  'USDA Organic',
                  'Products grown without synthetic pesticides, fertilizers, or GMOs.',
                  Icons.agriculture,
                ),
                _buildCertificationCard(
                  'Fair Trade',
                  'Ensures fair wages and safe working conditions for farmers.',
                  Icons.handshake,
                ),
                _buildCertificationCard(
                  'Carbon Neutral',
                  'Carbon emissions are balanced through reduction and offset programs.',
                  Icons.co2,
                ),
                _buildCertificationCard(
                  'Leaping Bunny',
                  'No animal testing at any stage of product development.',
                  Icons.pets,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildSection(
              title: 'Packaging Matters',
              icon: Icons.recycling,
              color: Colors.teal,
              content: [
                _buildPackagingCard(
                  'Biodegradable',
                  'Breaks down naturally without harming the environment.',
                  Icons.compost,
                  Colors.green,
                ),
                _buildPackagingCard(
                  'Recyclable',
                  'Can be processed and reused to make new products.',
                  Icons.restore,
                  Colors.blue,
                ),
                _buildPackagingCard(
                  'Plastic-Free',
                  'No plastic materials, reducing ocean and landfill pollution.',
                  Icons.no_backpack,
                  Colors.purple,
                ),
                _buildPackagingCard(
                  'Reusable',
                  'Designed for multiple uses, reducing overall waste.',
                  Icons.loop,
                  Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildSection(
              title: 'Carbon Footprint',
              icon: Icons.cloud,
              color: Colors.grey,
              content: [
                Text(
                  'Carbon footprint measures the total greenhouse gas emissions caused by a product throughout its lifecycle - from production to disposal.',
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildCarbonLevel('Low', '< 1 kg CO₂', Colors.green, Icons.emoji_emotions),
                _buildCarbonLevel('Medium', '1-3 kg CO₂', Colors.orange, Icons.sentiment_neutral),
                _buildCarbonLevel('High', '> 3 kg CO₂', Colors.red, Icons.sentiment_dissatisfied),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildSection(
              title: 'Local vs. Imported',
              icon: Icons.location_on,
              color: Colors.indigo,
              content: [
                Text(
                  'Choosing local products reduces transportation emissions and supports your local economy.',
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildOriginCard('Local', 'Less than 50km away', Icons.location_on, Colors.green),
                _buildOriginCard('Regional', 'Within your state/region', Icons.location_city, Colors.lightGreen),
                _buildOriginCard('National', 'Within your country', Icons.flag, Colors.orange),
                _buildOriginCard('International', 'Imported from abroad', Icons.public, Colors.grey),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildCallToAction(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.public, size: 48, color: Colors.white),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Every Purchase Makes a Difference',
            style: AppTypography.h2.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Learn how choosing eco-friendly products helps protect our planet for future generations.',
            style: AppTypography.bodyMedium.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: AppSpacing.sm),
            Text(
              title,
              style: AppTypography.h3.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...content,
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(text, style: AppTypography.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationCard(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: AppTypography.bodySmall),
      ),
    );
  }

  Widget _buildPackagingCard(String title, String description, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: AppTypography.bodySmall),
      ),
    );
  }

  Widget _buildCarbonLevel(String level, String range, Color color, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(
          level,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        subtitle: Text(range),
      ),
    );
  }

  Widget _buildOriginCard(String title, String description, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: AppTypography.bodySmall),
      ),
    );
  }

  Widget _buildCallToAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.favorite, color: AppColors.primary, size: 48),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Start Making a Difference Today!',
            style: AppTypography.h3.copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Browse our curated selection of eco-friendly products and join thousands of conscious consumers making sustainable choices.',
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Shop Eco-Friendly Products'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.md,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

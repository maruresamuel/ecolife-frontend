import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import 'environmental_impact_screen.dart';

class SustainabilityGuideScreen extends StatelessWidget {
  const SustainabilityGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sustainability Guide'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildHeader(),
          const SizedBox(height: AppSpacing.xl),
          _buildQuickTips(),
          const SizedBox(height: AppSpacing.xl),
          _buildArticlesList(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[700]!, Colors.green[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.eco, size: 48, color: Colors.white),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Learn About Sustainable Living',
            style: AppTypography.h2.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Discover practical tips and insights to make environmentally conscious choices every day.',
            style: AppTypography.bodyMedium.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTips() {
    final tips = [
      {
        'icon': Icons.shopping_bag,
        'title': 'Bring Your Own Bags',
        'tip': 'Use reusable shopping bags to reduce plastic waste',
        'color': Colors.blue,
      },
      {
        'icon': Icons.local_drink,
        'title': 'Refill Water Bottles',
        'tip': 'Carry a reusable water bottle instead of buying plastic',
        'color': Colors.cyan,
      },
      {
        'icon': Icons.restaurant,
        'title': 'Buy Local Produce',
        'tip': 'Support local farmers and reduce transportation emissions',
        'color': Colors.green,
      },
      {
        'icon': Icons.recycling,
        'title': 'Recycle Properly',
        'tip': 'Sort waste correctly to maximize recycling efficiency',
        'color': Colors.orange,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Eco Tips', style: AppTypography.h3),
        const SizedBox(height: AppSpacing.md),
        ...tips.map((tip) => _buildTipCard(
          icon: tip['icon'] as IconData,
          title: tip['title'] as String,
          tip: tip['tip'] as String,
          color: tip['color'] as Color,
        )).toList(),
      ],
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String tip,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(tip, style: AppTypography.bodySmall),
      ),
    );
  }

  Widget _buildArticlesList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Educational Articles', style: AppTypography.h3),
        const SizedBox(height: AppSpacing.md),
        _buildArticleCard(
          context,
          title: 'Understanding Environmental Impact',
          description: 'Learn how your choices affect the planet',
          image: Icons.public,
          color: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EnvironmentalImpactScreen(),
              ),
            );
          },
        ),
        _buildArticleCard(
          context,
          title: 'The Importance of Organic Farming',
          description: 'Why organic agriculture matters for our future',
          image: Icons.agriculture,
          color: Colors.green,
          onTap: () {
            _showArticle(context, 
              'The Importance of Organic Farming',
              '''Organic farming is more than just a trend—it's a return to sustainable agricultural practices that have sustained humanity for millennia.

**Key Benefits:**

• **No Synthetic Chemicals:** Organic farming avoids synthetic pesticides and fertilizers, protecting soil health and water quality.

• **Biodiversity:** Organic farms support more diverse ecosystems, providing habitats for beneficial insects and wildlife.

• **Soil Health:** Organic practices build healthy soil through composting and crop rotation, improving long-term productivity.

• **Climate Impact:** Organic farming can help mitigate climate change by storing more carbon in the soil.

• **Healthier Food:** Studies suggest organic produce may contain higher levels of certain nutrients and antioxidants.

**Challenges:**

While organic farming has many benefits, it also faces challenges like lower initial yields and higher labor costs. However, as practices improve and demand grows, these challenges are being addressed.

**What You Can Do:**

• Support organic farmers by buying organic products
• Learn about local organic farms in your area
• Start a small organic garden at home
• Advocate for policies supporting sustainable agriculture''',
            );
          },
        ),
        _buildArticleCard(
          context,
          title: 'Reducing Your Carbon Footprint',
          description: 'Simple steps to live more sustainably',
          image: Icons.co2,
          color: Colors.grey,
          onTap: () {
            _showArticle(context,
              'Reducing Your Carbon Footprint',
              '''Your carbon footprint is the total greenhouse gas emissions caused by your activities. Here's how to reduce it:

**In Your Home:**

• Switch to energy-efficient LED bulbs
• Improve insulation to reduce heating/cooling needs
• Choose renewable energy when possible
• Fix leaks and conserve water
• Compost food waste

**Transportation:**

• Walk, bike, or use public transit when possible
• Carpool or combine errands
• Consider an electric or hybrid vehicle
• Maintain your vehicle for better fuel efficiency

**Shopping Habits:**

• Buy local and seasonal produce
• Choose products with minimal packaging
• Support sustainable brands
• Buy second-hand when possible
• Repair instead of replace

**Diet Changes:**

• Reduce meat consumption, especially beef
• Choose plant-based proteins
• Avoid food waste
• Buy organic and local when possible

**Long-term Impact:**

Small changes add up! If everyone made just a few of these changes, the collective impact would be enormous. Start with what's easiest for you and gradually incorporate more sustainable practices.''',
            );
          },
        ),
        _buildArticleCard(
          context,
          title: 'Understanding Product Certifications',
          description: 'What eco-labels really mean',
          image: Icons.verified,
          color: Colors.purple,
          onTap: () {
            _showArticle(context,
              'Understanding Product Certifications',
              '''Eco-labels and certifications help consumers identify truly sustainable products. Here's what to look for:

**Major Certifications:**

**USDA Organic**
• No synthetic pesticides or fertilizers
• No GMOs
• Strict standards for organic integrity
• Regular inspections required

**Fair Trade**
• Fair wages for workers
• Safe working conditions
• Community development
• Environmental sustainability

**Carbon Neutral**
• Total carbon emissions calculated
• Emissions reduced where possible
• Remaining emissions offset

**B Corporation**
• Meets high standards of social and environmental performance
• Public transparency and legal accountability
• Balances profit with purpose

**FSC (Forest Stewardship Council)**
• Responsibly sourced wood products
• Protects forests and wildlife
• Respects workers' rights

**Leaping Bunny**
• No animal testing
• Applies to entire product line
• Verified by independent audits

**Why Certifications Matter:**

These certifications are verified by independent third parties, making them more trustworthy than self-declared "green" claims. While certified products may cost slightly more, you're investing in better practices and a healthier planet.

**Beware of Greenwashing:**

Not all "eco-friendly" claims are verified. Look for legitimate certifications from recognized organizations rather than vague marketing terms.''',
            );
          },
        ),
        _buildArticleCard(
          context,
          title: 'Zero Waste Living Guide',
          description: 'Steps toward a waste-free lifestyle',
          image: Icons.delete_outline,
          color: Colors.brown,
          onTap: () {
            _showArticle(context,
              'Zero Waste Living Guide',
              '''Zero waste living aims to minimize waste sent to landfills by refusing, reducing, reusing, recycling, and composting.

**The 5 R's of Zero Waste:**

**1. Refuse**
• Say no to single-use plastics
• Decline unnecessary packaging
• Avoid disposable items

**2. Reduce**
• Buy only what you need
• Choose quality over quantity
• Minimize consumption

**3. Reuse**
• Use reusable bags, bottles, and containers
• Repair broken items
• Buy second-hand
• Donate unwanted items

**4. Recycle**
• Learn your local recycling rules
• Clean recyclables properly
• Choose recyclable packaging

**5. Rot (Compost)**
• Compost food scraps
• Use compost in your garden
• Reduce methane from landfills

**Starting Your Zero Waste Journey:**

**Kitchen:**
• Use reusable food containers
• Buy in bulk
• Compost food scraps
• Choose loose produce over packaged

**Bathroom:**
• Switch to bar soap and shampoo
• Use bamboo toothbrush
• Try reusable cotton pads
• Choose refillable products

**On-the-Go:**
• Carry reusable water bottle
• Bring your own coffee cup
• Pack lunches in reusable containers
• Always have reusable bags

**Remember:**

Perfect is the enemy of good. Focus on progress, not perfection. Every small change makes a difference!''',
            );
          },
        ),
        _buildArticleCard(
          context,
          title: 'Supporting Local Farmers',
          description: 'How buying local helps the environment',
          image: Icons.local_florist,
          color: Colors.teal,
          onTap: () {
            _showArticle(context,
              'Supporting Local Farmers',
              '''Buying from local farmers isn't just good for your community—it's essential for environmental sustainability.

**Environmental Benefits:**

**Reduced Transportation**
• Less fuel consumption
• Lower carbon emissions
• Fresher produce with longer shelf life

**Sustainable Practices**
• Many local farmers use organic methods
• Better soil management
• Preservation of farmland
• Protection of local ecosystems

**Economic Impact**
• Money stays in local economy
• Supports rural communities
• Preserves agricultural knowledge
• Creates local jobs

**Food Quality**
• Fresher, more nutritious produce
• Seasonal variety
• Transparent sourcing
• Personal relationships with producers

**How to Buy Local:**

**Farmers Markets**
• Meet farmers directly
• Ask about growing practices
• Find seasonal produce
• Support community events

**CSA Programs**
• Community Supported Agriculture
• Weekly boxes of fresh produce
• Share harvest risks and rewards
• Connect with your food source

**Local Food Co-ops**
• Member-owned stores
• Focus on local and organic
• Community-oriented
• Often offer bulk options

**Farm Stands**
• Direct from farm
• Ultra-fresh products
• Support family farms
• Often organic or low-spray

**Make a Difference:**

Every purchase from a local farmer is a vote for sustainable agriculture, healthy communities, and environmental stewardship. Start exploring local options today!''',
            );
          },
        ),
      ],
    );
  }

  Widget _buildArticleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData image,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(image, size: 64, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    description,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Text(
                        'Read More',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(Icons.arrow_forward, size: 16, color: color),
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

  void _showArticle(BuildContext context, String title, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(title),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              content,
              style: AppTypography.bodyMedium.copyWith(height: 1.8),
            ),
          ),
        ),
      ),
    );
  }
}

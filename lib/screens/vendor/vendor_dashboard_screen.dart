import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../services/order_service.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/vendor/vendor_stats_card.dart';
import 'add_product_screen.dart';
import 'vendor_products_screen.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  final OrderService _orderService = OrderService();
  bool _isLoading = false;
  int _totalProducts = 0;
  int _totalOrders = 0;
  int _pendingOrders = 0;
  double _totalRevenue = 0.0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load vendor products
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      await productProvider.fetchVendorProducts();
      _totalProducts = productProvider.products.length;

      // Load vendor orders
      try {
        final orders = await _orderService.getVendorOrders();
        _totalOrders = orders.length;
        _pendingOrders = orders.where((o) => o.status == 'pending').length;
        _totalRevenue = orders
            .where((o) => o.status == 'delivered')
            .fold(0.0, (sum, order) => sum + order.totalAmount);
      } catch (e) {
        // If endpoint doesn't exist, use dummy data
        _totalOrders = 0;
        _pendingOrders = 0;
        _totalRevenue = 0.0;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading dashboard: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Message
                    Text(
                      'Welcome back,',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      user?.name ?? 'Vendor',
                      style: AppTypography.h2,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Stats Cards
                    Text(
                      'Overview',
                      style: AppTypography.h3,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    Row(
                      children: [
                        Expanded(
                          child: VendorStatsCard(
                            title: 'Total Products',
                            value: '$_totalProducts',
                            icon: Icons.inventory_2,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: VendorStatsCard(
                            title: 'Total Orders',
                            value: '$_totalOrders',
                            icon: Icons.shopping_bag,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    Row(
                      children: [
                        Expanded(
                          child: VendorStatsCard(
                            title: 'Pending Orders',
                            value: '$_pendingOrders',
                            icon: Icons.pending_actions,
                            color: AppColors.warning,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: VendorStatsCard(
                            title: 'Revenue',
                            value: 'KSH ${_totalRevenue.toStringAsFixed(2)}',
                            icon: Icons.attach_money,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Quick Actions
                    Text(
                      'Quick Actions',
                      style: AppTypography.h3,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    _buildActionCard(
                      icon: Icons.add_box,
                      title: 'Add New Product',
                      subtitle: 'List a new product for sale',
                      color: AppColors.primary,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddProductScreen(),
                          ),
                        ).then((_) => _loadDashboardData());
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    _buildActionCard(
                      icon: Icons.inventory,
                      title: 'Manage Products',
                      subtitle: 'View and edit your products',
                      color: AppColors.secondary,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VendorProductsScreen(),
                          ),
                        ).then((_) => _loadDashboardData());
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    _buildActionCard(
                      icon: Icons.receipt_long,
                      title: 'View Orders',
                      subtitle: 'Check your orders and fulfillment',
                      color: AppColors.info,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Vendor orders screen coming soon!'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    _buildActionCard(
                      icon: Icons.analytics,
                      title: 'Sales Analytics',
                      subtitle: 'View your performance metrics',
                      color: AppColors.success,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Analytics coming soon!'),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Switch to Customer View
                    Center(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('Switch to Customer View'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

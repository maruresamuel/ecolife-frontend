import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_input.dart';
import '../../utils/validators.dart';
import 'wallet_screen.dart';
import '../vendor/vendor_wallet_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      final success = await authProvider.updateProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        setState(() {
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Failed to update profile'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      
      await authProvider.logout();
      await cartProvider.clearCart();
      
      if (!mounted) return;
      
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        actions: [
          if (!_isEditing)
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 8,
                      minHeight: 8,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;

          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Avatar
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: AppTypography.h1.copyWith(
                        color: AppColors.white,
                        fontSize: 48,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // User Role Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: user.isVendor
                          ? AppColors.secondary.withOpacity(0.1)
                          : AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Text(
                      user.isVendor ? 'VENDOR' : 'CUSTOMER',
                      style: AppTypography.bodyMedium.copyWith(
                        color: user.isVendor
                            ? AppColors.secondary
                            : AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Profile Form
                  CustomInput(
                    controller: _nameController,
                    label: 'Name',
                    prefixIcon: Icons.person,
                    enabled: _isEditing,
                    validator: (value) => Validators.validateRequired(value, 'Name'),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  CustomInput(
                    controller: _emailController,
                    label: 'Email',
                    prefixIcon: Icons.email,
                    enabled: false, // Email cannot be changed
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  CustomInput(
                    controller: _phoneController,
                    label: 'Phone Number',
                    prefixIcon: Icons.phone,
                    enabled: _isEditing,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return null;
                      return Validators.validatePhone(value);
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Action Buttons
                  if (_isEditing) ...[
                    CustomButton(
                      text: 'Save Changes',
                      onPressed: _isLoading ? null : _updateProfile,
                      isLoading: _isLoading,
                      icon: Icons.save,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CustomButton(
                      text: 'Cancel',
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                        });
                        _loadUserData();
                      },
                      type: ButtonType.outline,
                    ),
                  ] else ...[
                    // Quick Actions
                    _buildActionCard(                      icon: Icons.account_balance_wallet,
                      title: user.isVendor ? 'Vendor Wallet' : 'My Wallet',
                      subtitle: user.isVendor
                          ? 'Manage earnings and withdrawals'
                          : 'Add money and view transactions',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => user.isVendor
                                ? const VendorWalletScreen()
                                : const WalletScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    
                    _buildActionCard(                      icon: Icons.shopping_bag,
                      title: 'My Orders',
                      subtitle: 'View your order history',
                      onTap: () {
                        Navigator.pushNamed(context, '/orders');
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    
                    if (user.isVendor)
                      _buildActionCard(
                        icon: Icons.dashboard,
                        title: 'Vendor Dashboard',
                        subtitle: 'Manage your products and orders',
                        onTap: () {
                          Navigator.pushNamed(context, '/vendor-dashboard');
                        },
                      ),
                    if (user.isVendor)
                      const SizedBox(height: AppSpacing.md),

                    _buildActionCard(
                      icon: Icons.help,
                      title: 'Help & Support',
                      subtitle: 'Get help with your account',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Help & Support coming soon!'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    _buildActionCard(
                      icon: Icons.info,
                      title: 'About EcoLife',
                      subtitle: 'Learn more about our mission',
                      onTap: () {
                        _showAboutDialog();
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Logout Button
                    CustomButton(
                      text: 'Logout',
                      onPressed: _logout,
                      type: ButtonType.outline,
                      icon: Icons.logout,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 28,
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
              const Icon(
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

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About EcoLife'),
        content: const Text(
          'EcoLife is a platform connecting eco-conscious consumers with '
          'sustainable product vendors. Our mission is to make sustainable '
          'living accessible and convenient for everyone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

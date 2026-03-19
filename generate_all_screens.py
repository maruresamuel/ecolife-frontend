#!/usr/bin/env python3
import os

# Already created: login_screen.dart

screens = {
    "lib/screens/auth/register_screen.dart": '''import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/validators.dart';
import '../../utils/helpers.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_input.dart';
import '../../theme/spacing.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _obscurePassword = true;
  String _selectedRole = 'customer';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      
      final success = await authProvider.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim(),
        role: _selectedRole,
        address: _selectedRole == 'vendor' ? _addressController.text.trim() : null,
      );

      if (mounted) {
        if (success) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        } else {
          Helpers.showSnackbar(
            context,
            authProvider.error ?? 'Registration failed',
            isError: true,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomInput(
                  label: 'Full Name',
                  controller: _nameController,
                  validator: Validators.validateName,
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: AppSpacing.md),
                CustomInput(
                  label: 'Email',
                  controller: _emailController,
                  validator: Validators.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: AppSpacing.md),
                CustomInput(
                  label: 'Password',
                  controller: _passwordController,
                  validator: Validators.validatePassword,
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                CustomInput(
                  label: 'Phone',
                  controller: _phoneController,
                  validator: Validators.validatePhone,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone,
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'I am a',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'customer', child: Text('Customer')),
                    DropdownMenuItem(value: 'vendor', child: Text('Vendor')),
                  ],
                  onChanged: (value) => setState(() => _selectedRole = value!),
                ),
                if (_selectedRole == 'vendor') ...[
                  const SizedBox(height: AppSpacing.md),
                  CustomInput(
                    label: 'Address',
                    controller: _addressController,
                    validator: Validators.validateAddress,
                    maxLines: 3,
                    prefixIcon: Icons.location_on,
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) => CustomButton(
                    text: 'Register',
                    onPressed: _handleRegister,
                    isLoading: auth.isLoading,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
''',

    "lib/screens/auth/role_select_screen.dart": '''import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.eco, size: 100, color: AppColors.primary),
              const SizedBox(height: AppSpacing.xl),
              const Text(
                'Welcome to EcoLife',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Choose how you want to continue',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: AppSpacing.xxl),
              _buildRoleCard(
                context,
                title: 'Customer',
                description: 'Browse and buy eco-friendly products',
                icon: Icons.shopping_bag,
                onTap: () => Navigator.pushNamed(context, '/login'),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildRoleCard(
                context,
                title: 'Vendor',
                description: 'Sell your sustainable products',
                icon: Icons.store,
                onTap: () => Navigator.pushNamed(context, '/login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Icon(icon, size: 48, color: AppColors.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(description, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
''',

    "lib/screens/common/splash_screen.dart": '''import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, size: 120, color: Colors.white),
            SizedBox(height: 24),
            Text(
              'EcoLife',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
''',

    "lib/screens/common/loading_screen.dart": '''import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
''',
}

# Create all screen files
for filepath, content in screens.items():
    with open(filepath, 'w') as f:
        f.write(content)
    print(f"Created {filepath}")

print("All screens created successfully!")

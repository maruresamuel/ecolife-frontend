import 'package:flutter/material.dart';
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
          final user = authProvider.user;
          if (user != null) {
            if (user.isVendor) {
              Navigator.pushNamedAndRemoveUntil(context, '/vendor/main', (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(context, '/customer/main', (route) => false);
            }
          }
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

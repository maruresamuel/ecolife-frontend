import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/spacing.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../common/custom_button.dart';
import '../common/custom_input.dart';

class ProductForm extends StatefulWidget {
  final String? initialName;
  final String? initialDescription;
  final double? initialPrice;
  final int? initialStock;
  final String? initialCategory;
  final String? initialUnit;
  final Function({
    required String name,
    required String description,
    required double price,
    required int stock,
    required String category,
    required String unit,
  }) onSubmit;
  final bool isLoading;
  
  const ProductForm({
    super.key,
    this.initialName,
    this.initialDescription,
    this.initialPrice,
    this.initialStock,
    this.initialCategory,
    this.initialUnit,
    required this.onSubmit,
    this.isLoading = false,
  });
  
  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _unitController;
  String? _selectedCategory;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _priceController = TextEditingController(text: widget.initialPrice?.toString());
    _stockController = TextEditingController(text: widget.initialStock?.toString());
    _unitController = TextEditingController(text: widget.initialUnit ?? 'piece');
    _selectedCategory = widget.initialCategory ?? AppConstants.productCategories.first;
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _unitController.dispose();
    super.dispose();
  }
  
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        stock: int.parse(_stockController.text.trim()),
        category: _selectedCategory!,
        unit: _unitController.text.trim(),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomInput(
            label: 'Product Name',
            hint: 'Enter product name',
            controller: _nameController,
            validator: Validators.validateProductName,
            prefixIcon: Icons.shopping_bag,
          ),
          const SizedBox(height: AppSpacing.md),
          
          CustomInput(
            label: 'Description',
            hint: 'Enter product description',
            controller: _descriptionController,
            validator: Validators.validateDescription,
            maxLines: 4,
            prefixIcon: Icons.description,
          ),
          const SizedBox(height: AppSpacing.md),
          
          Row(
            children: [
              Expanded(
                child: CustomInput(
                  label: 'Price',
                  hint: '0.00',
                  controller: _priceController,
                  validator: Validators.validatePrice,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  prefixIcon: Icons.currency_rupee,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: CustomInput(
                  label: 'Stock',
                  hint: '0',
                  controller: _stockController,
                  validator: Validators.validateStock,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  prefixIcon: Icons.inventory,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: AppConstants.productCategories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
            validator: (value) => Validators.validateRequired(value, 'Category'),
          ),
          const SizedBox(height: AppSpacing.md),
          
          CustomInput(
            label: 'Unit',
            hint: 'e.g., kg, liter, piece',
            controller: _unitController,
            validator: (value) => Validators.validateRequired(value, 'Unit'),
            prefixIcon: Icons.straighten,
          ),
          const SizedBox(height: AppSpacing.lg),
          
          CustomButton(
            text: widget.initialName != null ? 'Update Product' : 'Add Product',
            onPressed: _handleSubmit,
            isLoading: widget.isLoading,
          ),
        ],
      ),
    );
  }
}

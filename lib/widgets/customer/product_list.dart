import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../theme/spacing.dart';
import '../common/product_card.dart';

class ProductList extends StatelessWidget {
  final List<ProductModel> products;
  final Function(ProductModel) onProductTap;
  final Function(ProductModel)? onAddToCart;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  
  const ProductList({
    super.key,
    required this.products,
    required this.onProductTap,
    this.onAddToCart,
    this.shrinkWrap = false,
    this.physics,
  });
  
  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Text('No products found'),
        ),
      );
    }
    
    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () => onProductTap(product),
          onAddToCart: onAddToCart != null
              ? () => onAddToCart!(product)
              : null,
        );
      },
    );
  }
}

import 'package:image_picker/image_picker.dart';
import '../models/product_model.dart';
import 'api_service.dart';

class ProductService {
  final ApiService _apiService = ApiService();
  
  // Get all products
  Future<List<ProductModel>> getProducts({
    String? category,
    String? search,
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 20,
    // Eco-friendly filters
    bool? isOrganic,
    String? certification,
    int? minSustainabilityScore,
    String? packaging,
    String? origin,
    String? sortBy,
  }) async {
    String endpoint = '/products?page=$page&limit=$limit';
    
    if (category != null && category.isNotEmpty) {
      endpoint += '&category=$category';
    }
    if (search != null && search.isNotEmpty) {
      endpoint += '&search=$search';
    }
    if (minPrice != null) {
      endpoint += '&minPrice=$minPrice';
    }
    if (maxPrice != null) {
      endpoint += '&maxPrice=$maxPrice';
    }
    
    // Eco-friendly filters
    if (isOrganic != null && isOrganic) {
      endpoint += '&isOrganic=true';
    }
    if (certification != null && certification.isNotEmpty) {
      endpoint += '&certification=$certification';
    }
    if (minSustainabilityScore != null) {
      endpoint += '&minSustainabilityScore=$minSustainabilityScore';
    }
    if (packaging != null && packaging.isNotEmpty) {
      endpoint += '&packaging=$packaging';
    }
    if (origin != null && origin.isNotEmpty) {
      endpoint += '&origin=$origin';
    }
    if (sortBy != null && sortBy.isNotEmpty) {
      endpoint += '&sortBy=$sortBy';
    }
    
    final response = await _apiService.get(endpoint, withAuth: false);
    
    // Backend returns { success: true, data: { products: [...] } }
    final productsData = response['data'];
    final productsList = productsData is Map && productsData.containsKey('products')
        ? productsData['products']
        : productsData;
    
    final products = (productsList as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
    
    return products;
  }
  
  // Get product by ID
  Future<ProductModel> getProduct(String id) async {
    final response = await _apiService.get('/products/$id', withAuth: false);
    // Backend returns { success: true, data: { product: {...} } }
    final productData = response['data'];
    final productJson = productData is Map && productData.containsKey('product')
        ? productData['product']
        : productData;
    return ProductModel.fromJson(productJson);
  }
  
  // Get categories
  Future<List<String>> getCategories() async {
    final response = await _apiService.get('/products/categories/list', withAuth: false);
    return List<String>.from(response['data'] ?? []);
  }
  
  // Create product (Vendor only)
  Future<ProductModel> createProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
    required String category,
    required String unit,
    XFile? imageFile,
  }) async {
    final fields = {
      'name': name,
      'description': description,
      'price': price.toString(),
      'stock': stock.toString(),
      'category': category,
      'unit': unit,
    };
    
    dynamic response;
    
    if (imageFile != null) {
      response = await _apiService.postMultipart(
        '/products',
        fields,
        'image',
        imageFile,
      );
    } else {
      response = await _apiService.post('/products', fields);
    }
    
    // Backend returns { success: true, data: { product: {...} } }
    final productData = response['data'];
    final productJson = productData is Map && productData.containsKey('product')
        ? productData['product']
        : productData;
    return ProductModel.fromJson(productJson);
  }
  
  // Update product (Vendor only)
  Future<ProductModel> updateProduct(
    String id, {
    String? name,
    String? description,
    double? price,
    int? stock,
    String? category,
    String? unit,
    XFile? imageFile,
  }) async {
    final fields = <String, String>{};
    
    if (name != null) fields['name'] = name;
    if (description != null) fields['description'] = description;
    if (price != null) fields['price'] = price.toString();
    if (stock != null) fields['stock'] = stock.toString();
    if (category != null) fields['category'] = category;
    if (unit != null) fields['unit'] = unit;
    
    dynamic response;
    
    if (imageFile != null) {
      response = await _apiService.postMultipart(
        '/products/$id',
        fields,
        'image',
        imageFile,
      );
    } else {
      response = await _apiService.put('/products/$id', fields);
    }
    
    // Backend returns { success: true, data: { product: {...} } }
    final productData = response['data'];
    final productJson = productData is Map && productData.containsKey('product')
        ? productData['product']
        : productData;
    return ProductModel.fromJson(productJson);
  }
  
  // Delete product (Vendor only)
  Future<void> deleteProduct(String id) async {
    await _apiService.delete('/products/$id');
  }
  
  // Get vendor's products
  Future<List<ProductModel>> getVendorProducts() async {
    final response = await _apiService.get('/vendor/products');
    
    // Backend returns { success: true, data: { products: [...] } }
    final productsData = response['data'];
    final productsList = productsData is Map && productsData.containsKey('products')
        ? productsData['products']
        : productsData;
    
    final products = (productsList as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
    
    return products;
  }
}

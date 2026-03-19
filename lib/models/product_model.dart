import '../utils/constants.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;
  final String unit;
  final String? image;
  final String vendorId;
  final String? vendorName;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Sustainability Fields
  final bool isOrganic;
  final List<String> certifications;
  final int sustainabilityScore;
  final double carbonFootprint;
  final String packaging;
  final String origin;
  final List<String> ecoLabels;
  final String? environmentalImpact;
  
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    this.unit = 'piece',
    this.image,
    required this.vendorId,
    this.vendorName,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.isOrganic = false,
    this.certifications = const [],
    this.sustainabilityScore = 0,
    this.carbonFootprint = 0.0,
    this.packaging = 'Standard',
    this.origin = 'Local',
    this.ecoLabels = const [],
    this.environmentalImpact,
  });
  
  // Helper to get full image URL
  static String? _getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    
    // If already a full URL, return as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }
    
    // Convert relative path to full URL using constants
    // Remove leading slash if present to avoid double slashes
    final path = imagePath.startsWith('/') ? imagePath : '/$imagePath';
    return '${AppConstants.imageBaseUrl}$path';
  }
  
  // From JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      category: json['category'] ?? '',
      unit: json['unit'] ?? 'piece',
      image: _getFullImageUrl(json['image']),
      vendorId: json['vendor'] is String
          ? json['vendor']
          : json['vendor']?['_id'] ?? '',
      vendorName: json['vendor'] is Map
          ? json['vendor']['name']
          : null,
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      isOrganic: json['isOrganic'] ?? false,
      certifications: json['certifications'] != null
          ? List<String>.from(json['certifications'])
          : [],
      sustainabilityScore: json['sustainabilityScore'] ?? 0,
      carbonFootprint: (json['carbonFootprint'] ?? 0).toDouble(),
      packaging: json['packaging'] ?? 'Standard',
      origin: json['origin'] ?? 'Local',
      ecoLabels: json['ecoLabels'] != null
          ? List<String>.from(json['ecoLabels'])
          : [],
      environmentalImpact: json['environmentalImpact'],
    );
  }
  
  // To JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'unit': unit,
      'image': image,
      'vendor': vendorId,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isOrganic': isOrganic,
      'certifications': certifications,
      'sustainabilityScore': sustainabilityScore,
      'carbonFootprint': carbonFootprint,
      'packaging': packaging,
      'origin': origin,
      'ecoLabels': ecoLabels,
      'environmentalImpact': environmentalImpact,
    };
  }
  
  // Copy with
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? category,
    String? unit,
    String? image,
    String? vendorId,
    String? vendorName,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isOrganic,
    List<String>? certifications,
    int? sustainabilityScore,
    double? carbonFootprint,
    String? packaging,
    String? origin,
    List<String>? ecoLabels,
    String? environmentalImpact,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      image: image ?? this.image,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isOrganic: isOrganic ?? this.isOrganic,
      certifications: certifications ?? this.certifications,
      sustainabilityScore: sustainabilityScore ?? this.sustainabilityScore,
      carbonFootprint: carbonFootprint ?? this.carbonFootprint,
      packaging: packaging ?? this.packaging,
      origin: origin ?? this.origin,
      ecoLabels: ecoLabels ?? this.ecoLabels,
      environmentalImpact: environmentalImpact ?? this.environmentalImpact,
    );
  }
  
  bool get isInStock => stock > 0;
  bool get isLowStock => stock > 0 && stock <= 10;
  
  // Get sustainability level
  String get sustainabilityLevel {
    if (sustainabilityScore >= 80) return 'Excellent';
    if (sustainabilityScore >= 60) return 'Good';
    if (sustainabilityScore >= 40) return 'Fair';
    return 'Standard';
  }
  
  // Get carbon footprint level
  String get carbonFootprintLevel {
    if (carbonFootprint < 1) return 'Low';
    if (carbonFootprint < 3) return 'Medium';
    return 'High';
  }
}

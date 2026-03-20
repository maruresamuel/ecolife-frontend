class AppConstants {
  // API Configuration
  // IMPORTANT: Update these URLs based on your setup
  
  // PRODUCTION API (Render deployment):
  static const String baseUrl = 'https://ecolife-backend-7ixq.onrender.com/api';
  static const String imageBaseUrl = 'https://ecolife-backend-7ixq.onrender.com';
  
  // For local development (uncomment when testing locally):
  // static const String baseUrl = 'http://localhost:5000/api';
  // static const String imageBaseUrl = 'http://localhost:5000';
  
  // For Android Emulator (uncomment when using Android emulator):
  // static const String baseUrl = 'http://10.0.2.2:5000/api';
  // static const String imageBaseUrl = 'http://10.0.2.2:5000';
  
  // For Physical Device with local backend (uncomment and replace with your machine's IP):
  // Find your IP: 
  //   - Linux/Mac: `ifconfig` or `ip addr show`
  //   - Windows: `ipconfig`
  // static const String baseUrl = 'http://192.168.0.100:5000/api';
  // static const String imageBaseUrl = 'http://192.168.0.100:5000';
  
  static const String apiVersion = 'v1';
  static const int apiTimeout = 60; // seconds (60s to handle Render cold starts)
  
  // Storage Keys
  static const String storageKeyToken = 'auth_token';
  static const String storageKeyUser = 'user_data';
  static const String storageKeyRole = 'user_role';
  static const String storageKeyCart = 'cart_items';
  
  // Product Categories
  static const List<String> productCategories = [
    'Organic Vegetables',
    'Organic Fruits',
    'Dairy Products',
    'Grains & Pulses',
    'Eco-friendly Products',
    'Natural Cosmetics',
    'Herbal Products',
    'Others',
  ];
  
  // Order Status
  static const String orderStatusPending = 'pending';
  static const String orderStatusProcessing = 'processing';
  static const String orderStatusShipped = 'shipped';
  static const String orderStatusDelivered = 'delivered';
  static const String orderStatusCancelled = 'cancelled';
  
  static const List<String> orderStatuses = [
    orderStatusPending,
    orderStatusProcessing,
    orderStatusShipped,
    orderStatusDelivered,
    orderStatusCancelled,
  ];
  
  // User Roles
  static const String roleCustomer = 'customer';
  static const String roleVendor = 'vendor';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Image Upload
  static const int maxImageSizeInBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png'];
  
  // Validation
  static const int minPasswordLength = 8;
  static const int phoneNumberLength = 10;
  static const int maxProductNameLength = 100;
  static const int maxDescriptionLength = 500;
  
  // UI
  static const double defaultElevation = 2.0;
  static const double cardElevation = 4.0;
  static const double maxContentWidth = 600.0;
  
  // Animation Duration
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
}

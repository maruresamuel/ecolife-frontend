# EcoLife Mobile App

A sustainable marketplace mobile application built with Flutter, connecting customers with eco-friendly products and vendors.

## Features

### Customer Features
- 🛍️ Browse eco-friendly products with categories
- 🔍 Search and filter products
- 🛒 Shopping cart management
- 📦 Order placement and tracking
- 👤 User profile management
- 📱 Responsive UI with Material Design

### Vendor Features
- 📊 Vendor dashboard with statistics
- ➕ Add and manage products
- 📸 Product image uploads
- 📦 Order management
- 💰 Sales tracking

## Tech Stack

- **Framework**: Flutter 3.8+
- **State Management**: Provider
- **HTTP Client**: Dio & HTTP package
- **Local Storage**: SharedPreferences
- **Image Handling**: ImagePicker, CachedNetworkImage
- **Navigation**: Custom Router
- **UI Components**: Material Design 3

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # Main app widget with providers
├── navigation/               # Routing configuration
│   ├── app_router.dart
│   ├── auth_routes.dart
│   ├── customer_routes.dart
│   └── vendor_routes.dart
├── screens/                  # All screen widgets
│   ├── auth/                # Authentication screens
│   ├── customer/            # Customer screens
│   ├── vendor/              # Vendor screens
│   └── common/              # Common screens
├── widgets/                  # Reusable widgets
│   ├── common/              # Shared widgets
│   ├── customer/            # Customer-specific widgets
│   └── vendor/              # Vendor-specific widgets
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── cart_provider.dart
│   └── product_provider.dart
├── services/                 # API services
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── product_service.dart
│   └── order_service.dart
├── models/                   # Data models
│   ├── user_model.dart
│   ├── product_model.dart
│   └── order_model.dart
├── utils/                    # Utilities
│   ├── constants.dart
│   ├── helpers.dart
│   └── validators.dart
└── theme/                    # Theme configuration
    ├── colors.dart
    ├── typography.dart
    └── spacing.dart
```

## Getting Started

### Prerequisites

- Flutter SDK (3.8 or higher)
- Dart SDK (3.8 or higher)
- Android Studio / VS Code with Flutter extensions
- Android Emulator or iOS Simulator
- Running EcoLife Backend API

### Installation

1. **Clone the repository**
   ```bash
   cd ecolife_mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Endpoint**
   
   Update the base URL in `lib/utils/constants.dart`:
   
   ```dart
   // For Android Emulator
   static const String baseUrl = 'http://10.0.2.2:5000/api';
   
   // For iOS Simulator
   // static const String baseUrl = 'http://localhost:5000/api';
   
   // For Physical Device (replace with your computer's IP)
   // static const String baseUrl = 'http://192.168.1.XXX:5000/api';
   ```

4. **Run the app**
   ```bash
   # Check available devices
   flutter devices
   
   # Run on specific device
   flutter run -d <device-id>
   
   # Run in debug mode
   flutter run
   
   # Run in release mode
   flutter run --release
   ```

## Configuration

### Backend API Setup

Make sure the EcoLife backend is running:

```bash
cd ecolife-backend
npm install
npm run dev
```

The backend should be accessible at `http://localhost:5000`

### Environment-Specific URLs

- **Android Emulator**: Use `10.0.2.2` instead of `localhost`
- **iOS Simulator**: Use `localhost` directly
- **Physical Device**: Use your computer's local IP address

## Default Test Accounts

### Customer Account
- **Email**: customer@ecolife.com
- **Password**: password123

### Vendor Account
- **Email**: vendor@ecolife.com
- **Password**: password123

## Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1
  
  # HTTP & API
  http: ^1.2.0
  dio: ^5.4.0
  
  # Local Storage
  shared_preferences: ^2.2.2
  
  # Navigation
  go_router: ^13.0.0
  
  # Image Handling
  cached_network_image: ^3.3.1
  image_picker: ^1.0.7
  
  # UI Components
  flutter_svg: ^2.0.9
  shimmer: ^3.0.0
  badges: ^3.1.2
  
  # Utils
  intl: ^0.19.0
  uuid: ^4.3.3
```

## Features Breakdown

### Authentication
- ✅ User Registration (Customer/Vendor)
- ✅ Login with JWT
- ✅ Role-based access
- ✅ Profile management
- ✅ Password change
- ✅ Logout

### Product Management
- ✅ Browse products
- ✅ Search products
- ✅ Filter by category
- ✅ Product details
- ✅ Add/Edit/Delete products (Vendor)
- ✅ Image upload

### Shopping Cart
- ✅ Add to cart
- ✅ Update quantities
- ✅ Remove items
- ✅ Cart persistence
- ✅ Cart badge

### Orders
- ✅ Place orders
- ✅ View order history
- ✅ Order tracking
- ✅ Order status updates (Vendor)
- ✅ Cancel orders

## Troubleshooting

### Common Issues

1. **API Connection Failed**
   - Verify backend is running
   - Check API URL in constants.dart
   - For Android emulator, use `10.0.2.2` not `localhost`

2. **Dependencies Error**
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Build Issues**
   ```bash
   cd android && ./gradlew clean
   cd ios && pod install
   ```

4. **Hot Reload Not Working**
   - Stop the app and run again
   - Use `flutter run --hot` explicitly

## Development Commands

```bash
# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
flutter format lib/

# Check outdated packages
flutter pub outdated

# Upgrade packages
flutter pub upgrade

# Clean build
flutter clean
```

## API Endpoints Used

- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `GET /api/auth/me` - Get current user
- `GET /api/products` - Get all products
- `GET /api/products/:id` - Get product by ID
- `POST /api/products` - Create product (Vendor)
- `PUT /api/products/:id` - Update product (Vendor)
- `DELETE /api/products/:id` - Delete product (Vendor)
- `POST /api/orders` - Create order
- `GET /api/orders` - Get user orders
- `GET /api/orders/:id` - Get order by ID
- `PUT /api/orders/:id/cancel` - Cancel order

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is part of the EcoLife sustainable marketplace platform.

## Support

For issues and questions, please open an issue in the repository.

---

**Built with ❤️ using Flutter**

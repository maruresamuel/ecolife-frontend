import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../providers/auth_provider.dart';
import '../screens/common/splash_screen.dart';
import '../screens/auth/role_select_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/customer/customer_main_screen.dart';
import '../screens/customer/home_screen.dart';
import '../screens/customer/dashboard_screen.dart';
import '../screens/customer/product_details_screen.dart';
import '../screens/customer/cart_screen.dart';
import '../screens/customer/checkout_screen.dart';
import '../screens/customer/orders_screen.dart';
import '../screens/customer/profile_screen.dart';
import '../screens/common/notifications_screen.dart';
import '../screens/vendor/vendor_main_screen.dart';
import '../screens/vendor/enhanced_vendor_dashboard_screen.dart';
import '../screens/vendor/vendor_products_screen.dart';
import '../screens/vendor/add_product_screen.dart';
import '../screens/vendor/edit_product_screen.dart';
import '../screens/vendor/vendor_orders_screen.dart';
import '../screens/vendor/vendor_wallet_screen.dart';
import '../screens/customer/wallet_screen.dart';
import '../screens/customer/environmental_impact_screen.dart';
import '../screens/customer/sustainability_guide_screen.dart';
import '../screens/common/order_detail_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String roleSelect = '/role-select';
  static const String login = '/login';
  static const String register = '/register';
  
  // Customer routes
  static const String customerMain = '/customer/main';
  static const String customerDashboard = '/customer/dashboard';
  static const String home = '/home';
  static const String productDetails = '/product-details';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String wallet = '/wallet';
  static const String environmentalImpact = '/environmental-impact';
  static const String sustainabilityGuide = '/sustainability-guide';
  
  // Vendor routes
  static const String vendorMain = '/vendor/main';
  static const String vendorDashboard = '/vendor/dashboard';
  static const String vendorProducts = '/vendor/products';
  static const String addProduct = '/vendor/add-product';
  static const String editProduct = '/vendor/edit-product';
  static const String vendorOrders = '/vendor/orders';
  static const String vendorWallet = '/vendor/wallet';
  
  // Common routes
  static const String orderDetail = '/order-detail';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      case roleSelect:
        return MaterialPageRoute(builder: (_) => const RoleSelectScreen());
      
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      
      case customerMain:
        return MaterialPageRoute(builder: (_) => const CustomerMainScreen());
      
      case customerDashboard:
        return MaterialPageRoute(builder: (_) => const CustomerDashboardScreen());
      
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      
      case productDetails:
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(
            product: args as ProductModel,
          ),
        );
      
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      
      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      
      case orders:
        return MaterialPageRoute(builder: (_) => const OrdersScreen());
      
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      
      case wallet:
        return MaterialPageRoute(builder: (_) => const WalletScreen());
      
      case environmentalImpact:
        return MaterialPageRoute(builder: (_) => const EnvironmentalImpactScreen());
      
      case sustainabilityGuide:
        return MaterialPageRoute(builder: (_) => const SustainabilityGuideScreen());
      
      case vendorMain:
        return MaterialPageRoute(builder: (_) => const VendorMainScreen());
      
      case vendorDashboard:
        return MaterialPageRoute(builder: (_) => const VendorDashboardScreen());
      
      case vendorProducts:
        return MaterialPageRoute(builder: (_) => const VendorProductsScreen());
      
      case addProduct:
        return MaterialPageRoute(builder: (_) => const AddProductScreen());
      
      case editProduct:
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => EditProductScreen(
            product: args as ProductModel,
          ),
        );
      
      case vendorOrders:
        return MaterialPageRoute(builder: (_) => const VendorOrdersScreen());
      
      case vendorWallet:
        return MaterialPageRoute(builder: (_) => const VendorWalletScreen());
      
      case orderDetail:
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => OrderDetailScreen(
            order: args as OrderModel,
          ),
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
  
  // Get initial route based on authentication statusMain
  static String getInitialRoute(AuthProvider authProvider) {
    if (authProvider.isAuthenticated) {
      return authProvider.isVendor ? vendorMain : customerMain;
    }
    return login;
  }
}

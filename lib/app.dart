import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/order_provider.dart';
import 'providers/notification_provider.dart';
import 'navigation/app_router.dart';
import 'theme/colors.dart';

class EcoLifeApp extends StatelessWidget {
  const EcoLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider()..loadCart(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          // Determine initial route
          String initialRoute;
          if (authProvider.isLoading) {
            initialRoute = AppRouter.splash;
          } else {
            initialRoute = AppRouter.getInitialRoute(authProvider);
          }
          
          return MaterialApp(
            title: 'EcoLife',
            debugShowCheckedModeBanner: false,
            // Device Preview configuration
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            theme: ThemeData(
              primaryColor: AppColors.primary,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                primary: AppColors.primary,
                secondary: AppColors.secondary,
              ),
              scaffoldBackgroundColor: AppColors.background,
              useMaterial3: true,
            ),
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: initialRoute,
          );
        },
      ),
    );
  }
}

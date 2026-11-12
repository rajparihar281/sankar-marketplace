import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../screens/auth/auth_screen.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/details/product_details_screen.dart';
import '../../screens/listing/product_listing_screen.dart';
import '../../screens/main_navigation_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/wishlist/wishlist_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String main = '/main';
  static const String listing = '/listing';
  static const String details = '/details';
  static const String cart = '/cart';
  static const String wishlist = '/wishlist';
  static const String profile = '/profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case auth:
        return MaterialPageRoute(
          builder: (_) => const AuthScreen(),
          settings: settings,
        );
      case main:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
          settings: settings,
        );
      case listing:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ProductListingScreen(
            initialCategory: args?['category'] as String?,
            searchQuery: args?['search'] as String?,
          ),
          settings: settings,
        );
      case details:
        final product = settings.arguments as ProductModel;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: product),
          settings: settings,
        );
      case cart:
        return MaterialPageRoute(
          builder: (_) => const CartScreen(),
          settings: settings,
        );
      case wishlist:
        return MaterialPageRoute(
          builder: (_) => const WishlistScreen(),
          settings: settings,
        );
      case profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}


class AppConstants {
  static const String appName = 'Sankar Hub';
  static const String appTagline = 'Engineering Excellence & Innovation';
  static const String companyName = 'Sankar Group';
  static const String companyDescription =
      'Leading provider of precision engineering components, industrial sealing systems, and advanced manufacturing solutions.';

  // Currency
  static const String currency = '₹';
  static String formatPrice(num amount) {
    return '$currency${amount.toStringAsFixed(2)}';
  }

  // Storage Keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyAuthToken = 'auth_token';
  static const String keyUserData = 'user_data';
  static const String keyWishlist = 'wishlist_product_ids';
  static const String keyCart = 'cart_items_data';
  static const String keyThemeMode = 'app_theme_mode';

  // API Endpoints & Timeouts
  static const String baseApiUrl = 'https://dummyjson.com';
  static const int apiTimeoutSeconds = 12;

  // Commercial / Procurement Rules
  static const double freeShippingThreshold = 2000.0;
  static const double standardShippingFee = 250.0;
  static const double industrialTaxRate = 0.05; // 5% GST / Industrial Tax
}

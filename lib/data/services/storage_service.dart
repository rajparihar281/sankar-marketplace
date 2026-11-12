import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../models/cart_item_model.dart';
import '../models/user_model.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // --- Auth Persistence ---
  static Future<void> saveUser(UserModel user) async {
    await init();
    await _prefs?.setString(AppConstants.keyUserData, user.toJson());
    await _prefs?.setBool(AppConstants.keyIsLoggedIn, true);
  }

  static Future<UserModel?> getUser() async {
    await init();
    final jsonStr = _prefs?.getString(AppConstants.keyUserData);
    if (jsonStr == null) return null;
    try {
      return UserModel.fromJson(jsonStr);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> isLoggedIn() async {
    await init();
    return _prefs?.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }

  static Future<void> clearAuth() async {
    await init();
    await _prefs?.remove(AppConstants.keyUserData);
    await _prefs?.setBool(AppConstants.keyIsLoggedIn, false);
  }

  // --- Wishlist Persistence ---
  static Future<void> saveWishlist(List<int> productIds) async {
    await init();
    final stringIds = productIds.map((id) => id.toString()).toList();
    await _prefs?.setStringList(AppConstants.keyWishlist, stringIds);
  }

  static Future<List<int>> getWishlist() async {
    await init();
    final stringIds = _prefs?.getStringList(AppConstants.keyWishlist) ?? [];
    return stringIds.map((id) => int.tryParse(id) ?? 0).where((id) => id != 0).toList();
  }

  // --- Cart Persistence ---
  static Future<void> saveCart(List<CartItemModel> items) async {
    await init();
    final jsonList = items.map((item) => item.toMap()).toList();
    await _prefs?.setString(AppConstants.keyCart, json.encode(jsonList));
  }

  static Future<List<CartItemModel>> getCart() async {
    await init();
    final jsonStr = _prefs?.getString(AppConstants.keyCart);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final List<dynamic> list = json.decode(jsonStr);
      return list.map((item) => CartItemModel.fromMap(item as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  // --- Theme Mode Persistence ---
  static Future<void> saveThemeMode(bool isDark) async {
    await init();
    await _prefs?.setBool(AppConstants.keyThemeMode, isDark);
  }

  static Future<bool> isDarkMode() async {
    await init();
    return _prefs?.getBool(AppConstants.keyThemeMode) ?? false;
  }
}


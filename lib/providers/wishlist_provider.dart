import 'package:flutter/material.dart';
import '../data/models/product_model.dart';
import '../data/services/storage_service.dart';

class WishlistProvider extends ChangeNotifier {
  final Set<int> _wishlistIds = {};
  final Map<int, ProductModel> _cachedProducts = {};
  bool _isLoading = false;

  Set<int> get wishlistIds => _wishlistIds;
  List<ProductModel> get favoriteProducts => _cachedProducts.values.toList();
  int get count => _wishlistIds.length;
  bool get isLoading => _isLoading;

  WishlistProvider() {
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    _isLoading = true;
    notifyListeners();
    final ids = await StorageService.getWishlist();
    _wishlistIds.addAll(ids);
    _isLoading = false;
    notifyListeners();
  }

  bool isFavorite(int id) {
    return _wishlistIds.contains(id);
  }

  Future<void> toggleFavorite(ProductModel product) async {
    if (_wishlistIds.contains(product.id)) {
      _wishlistIds.remove(product.id);
      _cachedProducts.remove(product.id);
    } else {
      _wishlistIds.add(product.id);
      _cachedProducts[product.id] = product;
    }
    notifyListeners();
    await StorageService.saveWishlist(_wishlistIds.toList());
  }

  void syncWithProducts(List<ProductModel> products) {
    bool updated = false;
    for (final p in products) {
      if (_wishlistIds.contains(p.id) && !_cachedProducts.containsKey(p.id)) {
        _cachedProducts[p.id] = p;
        updated = true;
      }
    }
    if (updated) {
      notifyListeners();
    }
  }

  Future<void> removeFavorite(int id) async {
    _wishlistIds.remove(id);
    _cachedProducts.remove(id);
    notifyListeners();
    await StorageService.saveWishlist(_wishlistIds.toList());
  }
}


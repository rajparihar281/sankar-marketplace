import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../data/models/cart_item_model.dart';
import '../data/models/product_model.dart';
import '../data/services/storage_service.dart';

class CartProvider extends ChangeNotifier {
  List<CartItemModel> _items = [];
  bool _isLoading = false;

  List<CartItemModel> get items => _items;
  int get itemCount => _items.length;
  bool get isLoading => _isLoading;

  int get totalQuantity =>
      _items.fold(0, (total, item) => total + item.quantity);

  double get subtotal =>
      _items.fold(0.0, (total, item) => total + item.totalPrice);

  double get taxAmount => subtotal * AppConstants.industrialTaxRate;

  double get shippingAmount => (subtotal >= AppConstants.freeShippingThreshold || subtotal == 0)
      ? 0.0
      : AppConstants.standardShippingFee;

  double get grandTotal => subtotal + taxAmount + shippingAmount;

  CartProvider() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    _isLoading = true;
    notifyListeners();
    _items = await StorageService.getCart();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItemModel(product: product, quantity: quantity));
    }

    notifyListeners();
    await StorageService.saveCart(_items);
  }

  Future<void> updateQuantity(int productId, int delta) async {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      final newQty = _items[index].quantity + delta;
      if (newQty <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQty;
      }
      notifyListeners();
      await StorageService.saveCart(_items);
    }
  }

  Future<void> removeFromCart(int productId) async {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
    await StorageService.saveCart(_items);
  }

  Future<void> clearCart() async {
    _items.clear();
    notifyListeners();
    await StorageService.saveCart(_items);
  }
}

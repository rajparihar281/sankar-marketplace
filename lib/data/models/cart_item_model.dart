import 'dart:convert';
import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;

  CartItemModel({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.discountedPrice * quantity;

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      product: ProductModel.fromMap(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'] as int? ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemModel.fromJson(String source) =>
      CartItemModel.fromMap(json.decode(source));
}


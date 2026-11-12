import 'package:flutter_test/flutter_test.dart';
import 'package:sankar_marketplace/core/constants/app_constants.dart';
import 'package:sankar_marketplace/data/models/product_model.dart';
import 'package:sankar_marketplace/data/sample/sample_products.dart';

void main() {
  test('Sample products catalog contains valid Sankar items', () {
    expect(SampleProducts.sankarCatalog.isNotEmpty, true);
    final firstItem = SampleProducts.sankarCatalog.first;
    expect(firstItem.title, contains('Sankar'));
    expect(firstItem.price, greaterThan(0));
    expect(firstItem.stock, greaterThan(0));
    expect(firstItem.discountedPrice, lessThanOrEqualTo(firstItem.price));
  });

  test('ProductModel discount calculation is accurate', () {
    final product = ProductModel(
      id: 999,
      title: 'Precision Test Tool',
      description: 'Test description',
      category: 'Machining & Tools',
      price: 1000.0,
      discountPercentage: 20.0,
      thumbnail: 'https://example.com/tool.jpg',
    );

    expect(product.discountedPrice, 800.0);
    expect(product.isInStock, true);
    expect(product.formattedPrice, '₹1000.00');
    expect(product.formattedDiscountedPrice, '₹800.00');
  });

  test('App constants define Sankar Group identity and Indian Rupee currency', () {
    expect(AppConstants.companyName, 'Sankar Group');
    expect(AppConstants.appName, 'Sankar Hub');
    expect(AppConstants.currency, '₹');
    expect(AppConstants.formatPrice(2500), '₹2500.00');
  });
}

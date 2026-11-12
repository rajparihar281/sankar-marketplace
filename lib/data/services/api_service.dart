import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../models/product_model.dart';
import '../sample/sample_products.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches products from API with automatic fallback to structured sample data
  Future<List<ProductModel>> getProducts({
    String? category,
    String? searchQuery,
  }) async {
    try {
      String endpoint = '${AppConstants.baseApiUrl}/products?limit=40';

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        endpoint =
            '${AppConstants.baseApiUrl}/products/search?q=${Uri.encodeComponent(searchQuery.trim())}';
      } else if (category != null &&
          category.isNotEmpty &&
          category.toLowerCase() != 'all') {
        endpoint =
            '${AppConstants.baseApiUrl}/products/category/${Uri.encodeComponent(category.toLowerCase())}';
      }

      final uri = Uri.parse(endpoint);
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> productsJson = data['products'] ?? [];

        List<ProductModel> fetchedProducts = productsJson
            .map((jsonItem) => ProductModel.fromMap(jsonItem as Map<String, dynamic>))
            .toList();

        // Blend in Sankar Group special engineering products at top for brand experience
        if ((searchQuery == null || searchQuery.isEmpty) &&
            (category == null || category == 'All')) {
          fetchedProducts = [...SampleProducts.sankarCatalog, ...fetchedProducts];
        }

        return fetchedProducts;
      } else {
        throw ApiException(
          'Server returned status code: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on SocketException {
      // Offline fallback: Return local curated Sankar catalog
      return _getLocalFilteredProducts(category, searchQuery);
    } on TimeoutException {
      // Timeout fallback
      return _getLocalFilteredProducts(category, searchQuery);
    } catch (e) {
      // Any other network/parsing error: provide structured local fallback
      final fallback = _getLocalFilteredProducts(category, searchQuery);
      if (fallback.isNotEmpty) return fallback;
      throw ApiException('Failed to load products: ${e.toString()}');
    }
  }

  /// Helper to filter sample products offline
  List<ProductModel> _getLocalFilteredProducts(String? category, String? searchQuery) {
    var items = List<ProductModel>.from(SampleProducts.sankarCatalog);

    if (category != null && category.isNotEmpty && category != 'All') {
      items = items.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final query = searchQuery.toLowerCase().trim();
      items = items.where((p) {
        return p.title.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query) ||
            p.brand.toLowerCase().contains(query);
      }).toList();
    }

    return items;
  }

  /// Fetches unique categories
  Future<List<String>> getCategories() async {
    try {
      final uri = Uri.parse('${AppConstants.baseApiUrl}/products/categories');
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<String> list = [];
        if (data is List) {
          list = data.map((item) {
            if (item is Map && item['name'] != null) {
              return item['name'].toString();
            }
            return item.toString();
          }).toList();
        }
        return ['All', ...SampleProducts.categories.where((c) => c != 'All'), ...list.take(6)];
      }
      return SampleProducts.categories;
    } catch (_) {
      return SampleProducts.categories;
    }
  }

  /// Fetches a single product by ID
  Future<ProductModel> getProductById(int id) async {
    // Check local catalog first
    final localMatch = SampleProducts.sankarCatalog.where((p) => p.id == id);
    if (localMatch.isNotEmpty) return localMatch.first;

    try {
      final uri = Uri.parse('${AppConstants.baseApiUrl}/products/$id');
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ProductModel.fromMap(data);
      }
      throw ApiException('Product not found ($id)');
    } catch (e) {
      throw ApiException('Unable to retrieve product details.');
    }
  }
}


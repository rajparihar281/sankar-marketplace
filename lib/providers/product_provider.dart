import 'package:flutter/material.dart';
import '../data/models/product_model.dart';
import '../data/services/api_service.dart';

enum ProductSortOption {
  featured,
  priceAsc,
  priceDesc,
  highestRating,
}

enum LoadingStatus {
  initial,
  loading,
  loaded,
  error,
}

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService;

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  List<String> _categories = ['All'];

  LoadingStatus _status = LoadingStatus.initial;
  String? _errorMessage;

  String _selectedCategory = 'All';
  String _searchQuery = '';
  ProductSortOption _sortOption = ProductSortOption.featured;

  ProductProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService() {
    loadProducts();
    loadCategories();
  }

  // Getters
  List<ProductModel> get products => _filteredProducts;
  List<ProductModel> get allProducts => _allProducts;
  List<String> get categories => _categories;
  LoadingStatus get status => _status;
  bool get isLoading => _status == LoadingStatus.loading;
  bool get hasError => _status == LoadingStatus.error;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  ProductSortOption get sortOption => _sortOption;

  // Home Screen curated subsets
  List<ProductModel> get featuredProducts =>
      _allProducts.take(6).toList();

  List<ProductModel> get trendingDeals =>
      _allProducts.where((p) => p.discountPercentage >= 10).take(6).toList();

  Future<void> loadProducts() async {
    _status = LoadingStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetched = await _apiService.getProducts(
        category: _selectedCategory == 'All' ? null : _selectedCategory,
        searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
      );

      _allProducts = fetched;
      _applyFiltersAndSort();
      _status = LoadingStatus.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = LoadingStatus.error;
    }

    notifyListeners();
  }

  Future<void> loadCategories() async {
    try {
      final fetchedCats = await _apiService.getCategories();
      _categories = fetchedCats;
      notifyListeners();
    } catch (_) {
      // Keep defaults
    }
  }

  void setCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    // Reload with category endpoint or filter locally
    loadProducts();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFiltersAndSort();
    notifyListeners();
  }

  void submitSearch(String query) {
    _searchQuery = query;
    loadProducts();
  }

  void clearSearch() {
    _searchQuery = '';
    _applyFiltersAndSort();
    notifyListeners();
  }

  void setSortOption(ProductSortOption option) {
    _sortOption = option;
    _applyFiltersAndSort();
    notifyListeners();
  }

  void _applyFiltersAndSort() {
    var items = List<ProductModel>.from(_allProducts);

    // Apply local search filter if present
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      items = items.where((p) {
        return p.title.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.brand.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q);
      }).toList();
    }

    // Apply local category filter if not 'All'
    if (_selectedCategory != 'All') {
      items = items.where((p) {
        return p.category.toLowerCase() == _selectedCategory.toLowerCase();
      }).toList();
    }

    // Apply sorting
    switch (_sortOption) {
      case ProductSortOption.priceAsc:
        items.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
        break;
      case ProductSortOption.priceDesc:
        items.sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
        break;
      case ProductSortOption.highestRating:
        items.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ProductSortOption.featured:
        // natural order
        break;
    }

    _filteredProducts = items;
  }

  Future<void> refresh() async {
    await loadProducts();
  }
}


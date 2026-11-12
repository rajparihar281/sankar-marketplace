import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/error_state_view.dart';
import '../../widgets/product_card.dart';
import '../../widgets/rating_stars.dart';

class ProductListingScreen extends StatefulWidget {
  final String? initialCategory;
  final String? searchQuery;

  const ProductListingScreen({
    super.key,
    this.initialCategory,
    this.searchQuery,
  });

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  late TextEditingController _searchController;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProductProvider>();
      if (widget.initialCategory != null) {
        provider.setCategory(widget.initialCategory!);
      }
      if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
        provider.setSearchQuery(widget.searchQuery!);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSortModal(BuildContext context) {
    final provider = context.read<ProductProvider>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sort Products By',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                _buildSortOption(
                  title: 'Featured / Recommended',
                  subtitle: 'Curated Sankar engineering catalog',
                  option: ProductSortOption.featured,
                  current: provider.sortOption,
                  onSelect: () {
                    provider.setSortOption(ProductSortOption.featured);
                    Navigator.pop(context);
                  },
                ),
                _buildSortOption(
                  title: 'Price: Low to High',
                  subtitle: 'Budget-friendly solutions first',
                  option: ProductSortOption.priceAsc,
                  current: provider.sortOption,
                  onSelect: () {
                    provider.setSortOption(ProductSortOption.priceAsc);
                    Navigator.pop(context);
                  },
                ),
                _buildSortOption(
                  title: 'Price: High to Low',
                  subtitle: 'Heavy-duty & premium grade equipment',
                  option: ProductSortOption.priceDesc,
                  current: provider.sortOption,
                  onSelect: () {
                    provider.setSortOption(ProductSortOption.priceDesc);
                    Navigator.pop(context);
                  },
                ),
                _buildSortOption(
                  title: 'Customer Rating',
                  subtitle: 'Highest rated parts by industrial engineers',
                  option: ProductSortOption.highestRating,
                  current: provider.sortOption,
                  onSelect: () {
                    provider.setSortOption(ProductSortOption.highestRating);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOption({
    required String title,
    required String subtitle,
    required ProductSortOption option,
    required ProductSortOption current,
    required VoidCallback onSelect,
  }) {
    final isSelected = option == current;
    return ListTile(
      dense: true,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.primary : null,
        ),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20)
          : null,
      onTap: onSelect,
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final cartProvider = context.watch<CartProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final products = productProvider.products;
    final categories = productProvider.categories;
    final selectedCategory = productProvider.selectedCategory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
            tooltip: _isGridView ? 'Switch to List View' : 'Switch to Grid View',
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort_rounded),
            tooltip: 'Sort Products',
            onPressed: () => _showSortModal(context),
          ),
          IconButton(
            icon: Badge(
              isLabelVisible: cartProvider.itemCount > 0,
              label: Text(cartProvider.itemCount.toString()),
              backgroundColor: AppColors.accent,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            tooltip: 'Cart',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => productProvider.setSearchQuery(val),
              onSubmitted: (val) => productProvider.submitSearch(val),
              decoration: InputDecoration(
                hintText: 'Search products, SKU or brand...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          productProvider.clearSearch();
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Categories Horizontal Filter Chips
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = selectedCategory.toLowerCase() == cat.toLowerCase();

                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: isDark ? AppColors.accent : AppColors.primary,
                  backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? (isDark ? Colors.black : Colors.white)
                        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      productProvider.setCategory(cat);
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 6),

          // Result Count & Active Filter Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${products.length} products found',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                if (selectedCategory != 'All' || _searchController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      productProvider.setCategory('All');
                      productProvider.clearSearch();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Reset Filters',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.accent : AppColors.primaryLight,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.cancel_outlined,
                          size: 14,
                          color: isDark ? AppColors.accent : AppColors.primaryLight,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Product List / Grid
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => productProvider.refresh(),
              color: AppColors.primary,
              child: _buildBody(context, productProvider, products, isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ProductProvider provider,
    List<ProductModel> products,
    bool isDark,
  ) {
    if (provider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Fetching Sankar Group inventory...'),
          ],
        ),
      );
    }

    if (provider.hasError) {
      return ErrorStateView(
        message: provider.errorMessage ?? 'Failed to load catalog data.',
        onRetry: () => provider.refresh(),
      );
    }

    if (products.isEmpty) {
      return EmptyStateView(
        icon: Icons.search_off_rounded,
        title: 'No products match your criteria',
        message: 'Try clearing your search terms or selecting a different category filter.',
        buttonText: 'Clear Filters',
        onButtonPressed: () {
          _searchController.clear();
          provider.setCategory('All');
          provider.clearSearch();
        },
      );
    }

    if (_isGridView) {
      final screenWidth = MediaQuery.sizeOf(context).width;
      final textScale = MediaQuery.textScalerOf(context).scale(1.0);
      final crossAxisCount = screenWidth > 900 ? 4 : (screenWidth > 600 ? 3 : 2);

      // Adaptive ratio tuned specifically to prevent overflow on narrow screens
      final double childAspectRatio = screenWidth < 380
          ? (0.57 / textScale.clamp(1.0, 1.3))
          : (0.64 / textScale.clamp(1.0, 1.3));

      return GridView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          return ProductCard(product: products[index]);
        },
      );
    }

    // List View Layout
    return ListView.separated(
      padding: const EdgeInsets.all(14),
      itemCount: products.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return _buildHorizontalListTile(context, products[index], isDark);
      },
    );
  }

  Widget _buildHorizontalListTile(
    BuildContext context,
    ProductModel product,
    bool isDark,
  ) {
    final wishlist = context.watch<WishlistProvider>();
    final cart = context.watch<CartProvider>();
    final isFav = wishlist.isFavorite(product.id);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.details,
              arguments: product,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 76,
                    height: 76,
                    color: isDark ? Colors.black26 : const Color(0xFFF1F5F9),
                    child: Hero(
                      tag: 'product_image_${product.id}',
                      child: Image.network(
                        product.thumbnail,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.precision_manufacturing_rounded,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.brand.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.accent : AppColors.primaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      RatingStars(rating: product.rating, size: 11),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                product.formattedDiscountedPrice,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          if (product.discountPercentage > 0) ...[
                            const SizedBox(width: 6),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  product.formattedPrice,
                                  style: TextStyle(
                                    fontSize: 11,
                                    decoration: TextDecoration.lineThrough,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Actions
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFav ? AppColors.error : AppColors.textSecondaryLight,
                        size: 19,
                      ),
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        wishlist.toggleFavorite(product);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add_shopping_cart_rounded,
                        color: AppColors.primary,
                        size: 19,
                      ),
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        cart.addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added "${product.title}" to cart'),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

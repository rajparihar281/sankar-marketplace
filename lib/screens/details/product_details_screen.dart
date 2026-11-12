import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/rating_stars.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedImageIndex = 0;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final wishlist = context.watch<WishlistProvider>();
    final cart = context.watch<CartProvider>();
    final isFav = wishlist.isFavorite(product.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.sizeOf(context).height;

    final images = product.images.isNotEmpty ? product.images : [product.thumbnail];
    final double galleryHeight = (screenHeight * 0.30).clamp(180.0, 280.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.brand,
          style: const TextStyle(fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFav ? AppColors.error : null,
            ),
            tooltip: 'Wishlist',
            onPressed: () {
              wishlist.toggleFavorite(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFav ? 'Removed from wishlist' : 'Added to wishlist',
                  ),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            icon: Badge(
              isLabelVisible: cart.itemCount > 0,
              label: Text(cart.itemCount.toString()),
              backgroundColor: AppColors.accent,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            tooltip: 'Cart',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel / Hero Display
            Container(
              height: galleryHeight,
              width: double.infinity,
              color: isDark ? Colors.black26 : const Color(0xFFF8FAFC),
              child: Center(
                child: Hero(
                  tag: 'product_image_${product.id}',
                  child: Image.network(
                    images[_selectedImageIndex],
                    fit: BoxFit.contain,
                    height: galleryHeight - 20,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.precision_manufacturing_rounded,
                      size: 64,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ),
            ),

            // Multiple Thumbnail selector if available
            if (images.length > 1) ...[
              const SizedBox(height: 10),
              SizedBox(
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: images.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedImageIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImageIndex = index;
                        });
                      },
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? (isDark ? AppColors.accent : AppColors.primary)
                                : (isDark ? AppColors.borderDark : AppColors.borderLight),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.network(
                            images[index],
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => const Icon(Icons.image, size: 20),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges: Category & Stock Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.accent.withValues(alpha: 0.15)
                                : AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.category.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.4,
                              color: isDark ? AppColors.accent : AppColors.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: product.isInStock
                              ? AppColors.success.withValues(alpha: 0.12)
                              : AppColors.error.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: product.isInStock ? AppColors.success : AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              product.availabilityStatus,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: product.isInStock ? AppColors.success : AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Product Title
                  Text(
                    product.title,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.4,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Rating and Reviews Row
                  Row(
                    children: [
                      RatingStars(rating: product.rating, size: 14),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '(${product.rating} / 5.0 Rating)',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'SKU: SG-${product.id + 1000}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Price Section (with Wrap to completely prevent overflow on Samsung A03s and small screens)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Special Unit Price',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondaryLight,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  Text(
                                    product.formattedDiscountedPrice,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  if (product.discountPercentage > 0) ...[
                                    Text(
                                      product.formattedPrice,
                                      style: TextStyle(
                                        fontSize: 13,
                                        decoration: TextDecoration.lineThrough,
                                        color: isDark
                                            ? AppColors.textSecondaryDark
                                            : AppColors.textSecondaryLight,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'SAVE ${product.discountPercentage.toStringAsFixed(0)}%',
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Quantity Selector
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardDark : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 14),
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                padding: EdgeInsets.zero,
                                onPressed: _quantity > 1
                                    ? () => setState(() => _quantity--)
                                    : null,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  '$_quantity',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 14),
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                padding: EdgeInsets.zero,
                                onPressed: () => setState(() => _quantity++),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Product Overview',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: isDark ? AppColors.textSecondaryDark : const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Technical Specifications Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Engineering Specifications',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildSpecRow('Brand Division', product.brand, isDark),
                        _buildSpecRow('Category', product.category, isDark),
                        _buildSpecRow('Warranty Terms', product.warrantyInformation, isDark),
                        _buildSpecRow('Fulfillment Logistics', product.shippingInformation, isDark),
                        _buildSpecRow('Stock Available', '${product.stock} units', isDark, isLast: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 90), // Space for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Total calculation
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppConstants.formatPrice(product.discountedPrice * _quantity),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.accent : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Add to Cart Button
              Expanded(
                child: CustomButton(
                  text: 'Add to Cart',
                  icon: Icons.shopping_bag_outlined,
                  onPressed: () {
                    cart.addToCart(product, quantity: _quantity);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added $_quantity "${product.title}" to cart'),
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(
                          label: 'VIEW CART',
                          textColor: AppColors.accent,
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.cart);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value, bool isDark, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            color: isDark ? AppColors.borderDark.withValues(alpha: 0.5) : AppColors.borderLight,
            height: 1,
          ),
      ],
    );
  }
}

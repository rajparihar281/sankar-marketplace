import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../data/models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import 'rating_stars.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isHorizontal;
  final double? width;

  const ProductCard({
    super.key,
    required this.product,
    this.isHorizontal = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = context.watch<WishlistProvider>();
    final isFav = wishlistProvider.isFavorite(product.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedHeight = constraints.hasBoundedHeight;
        final double imageHeight = isHorizontal
            ? 110.0
            : (hasBoundedHeight ? (constraints.maxHeight * 0.47).clamp(90.0, 135.0) : 120.0);

        return Container(
          width: width,
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image container with Hero & Favorite button
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                        child: Container(
                          height: imageHeight,
                          width: double.infinity,
                          color: isDark ? Colors.black26 : const Color(0xFFF1F5F9),
                          child: Hero(
                            tag: 'product_image_${product.id}',
                            child: Image.network(
                              product.thumbnail,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.precision_manufacturing_rounded,
                                    size: 34,
                                    color: AppColors.textSecondaryLight.withValues(alpha: 0.5),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      // Discount Badge
                      if (product.discountPercentage > 0)
                        Positioned(
                          top: 6,
                          left: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accentDark,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              '-${product.discountPercentage.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      // Wishlist button
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              wishlistProvider.toggleFavorite(product);
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isFav ? 'Removed from wishlist' : 'Saved to wishlist',
                                  ),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.surfaceDark.withValues(alpha: 0.85)
                                    : Colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: Icon(
                                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                size: 16,
                                color: isFav ? AppColors.error : AppColors.textSecondaryLight,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Content Details (Expanded if bounded height to avoid any overflow)
                  Expanded(
                    flex: hasBoundedHeight ? 1 : 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(9, 7, 9, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Brand / Division Tag
                              Text(
                                product.brand.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4,
                                  color: isDark ? AppColors.accent : AppColors.primaryLight,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),

                              // Title
                              Text(
                                product.title,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  height: 1.18,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),

                              // Rating
                              RatingStars(rating: product.rating, size: 11),
                            ],
                          ),

                          // Price & Cart Button
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          product.formattedDiscountedPrice,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                          ),
                                        ),
                                      ),
                                      if (product.discountPercentage > 0)
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            product.formattedPrice,
                                            style: TextStyle(
                                              fontSize: 10,
                                              decoration: TextDecoration.lineThrough,
                                              color: isDark
                                                  ? AppColors.textSecondaryDark
                                                  : AppColors.textSecondaryLight,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 4),

                                // Quick Add to Cart Button
                                InkWell(
                                  borderRadius: BorderRadius.circular(7),
                                  onTap: () {
                                    context.read<CartProvider>().addToCart(product);
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Added "${product.title}" to cart'),
                                        duration: const Duration(seconds: 1),
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
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.accent : AppColors.primary,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Icon(
                                      Icons.add_shopping_cart_rounded,
                                      size: 15,
                                      color: isDark ? Colors.black : Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

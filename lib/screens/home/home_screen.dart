import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/banner_carousel.dart';
import '../../widgets/product_card.dart';
import '../../widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final productProvider = context.watch<ProductProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();
    final cartProvider = context.watch<CartProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final user = auth.user;
    final userName = user != null ? user.name : 'Engineer';
    final screenWidth = MediaQuery.sizeOf(context).width;
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);

    final double trendingRatio = screenWidth < 380
        ? (0.57 / textScale.clamp(1.0, 1.3))
        : (0.64 / textScale.clamp(1.0, 1.3));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: isDark ? AppColors.accent : AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.precision_manufacturing_rounded,
                size: 20,
                color: isDark ? Colors.black : Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppConstants.appName,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Sankar Group Industrial Portal',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All manufacturing systems operating normally.'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            icon: Badge(
              isLabelVisible: cartProvider.itemCount > 0,
              label: Text(cartProvider.itemCount.toString()),
              backgroundColor: AppColors.accent,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            tooltip: 'View Cart',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.cart);
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => productProvider.refresh(),
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Greeting Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: isDark ? AppColors.accent : AppColors.primary,
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'E',
                        style: TextStyle(
                          color: isDark ? Colors.black : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Hello, $userName 👋',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.company ?? 'Sankar Group Partner',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'ONLINE',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Interactive Search Bar trigger
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.listing);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Search gaskets, CNC bits, sensors & parts...',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.accent.withValues(alpha: 0.15)
                              : AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          size: 15,
                          color: isDark ? AppColors.accent : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Promotional Banner Slider
              const BannerCarousel(),
              const SizedBox(height: 18),

              // Dashboard Statistics Row (fully responsive, cannot overflow)
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      title: 'Available Parts',
                      value: '${productProvider.allProducts.length}',
                      icon: Icons.inventory_2_outlined,
                      color: AppColors.primaryLight,
                      isDark: isDark,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.listing),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      title: 'Wishlist',
                      value: '${wishlistProvider.count}',
                      icon: Icons.favorite_outline_rounded,
                      color: AppColors.accentDark,
                      isDark: isDark,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.wishlist),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricCard(
                      context: context,
                      title: 'Cart Items',
                      value: '${cartProvider.itemCount}',
                      icon: Icons.shopping_cart_outlined,
                      color: AppColors.success,
                      isDark: isDark,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Categories Horizontal Filter
              SectionHeader(
                title: 'Browse Categories',
                subtitle: 'Precision products engineered to OEM specifications',
                actionText: 'All Categories',
                onActionTap: () => Navigator.pushNamed(context, AppRoutes.listing),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: productProvider.categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = productProvider.categories[index];
                    return ActionChip(
                      label: Text(cat),
                      backgroundColor: isDark
                          ? AppColors.surfaceDark
                          : Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                      side: BorderSide(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      onPressed: () {
                        productProvider.setCategory(cat);
                        Navigator.pushNamed(
                          context,
                          AppRoutes.listing,
                          arguments: {'category': cat},
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 22),

              // Featured Products Section
              SectionHeader(
                title: 'Featured Sankar Solutions',
                subtitle: 'Hand-picked industrial grade components',
                onActionTap: () => Navigator.pushNamed(context, AppRoutes.listing),
              ),
              const SizedBox(height: 10),

              if (productProvider.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (productProvider.featuredProducts.isNotEmpty)
                SizedBox(
                  height: 255,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: productProvider.featuredProducts.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final product = productProvider.featuredProducts[index];
                      final cardWidth = (screenWidth * 0.48).clamp(165.0, 210.0);
                      return ProductCard(
                        product: product,
                        width: cardWidth,
                        isHorizontal: true,
                      );
                    },
                  ),
                )
              else
                const Text('No featured items at the moment.'),

              const SizedBox(height: 22),

              // Trending Deals Section (responsive ratio calculated to completely prevent bottom overflow)
              SectionHeader(
                title: 'Top Value & Special Deals',
                subtitle: 'Discounts on precision parts and bulk lots',
                onActionTap: () => Navigator.pushNamed(context, AppRoutes.listing),
              ),
              const SizedBox(height: 10),

              if (productProvider.trendingDeals.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: productProvider.trendingDeals.length > 4
                      ? 4
                      : productProvider.trendingDeals.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth > 600 ? 3 : 2,
                    childAspectRatio: trendingRatio,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final item = productProvider.trendingDeals[index];
                    return ProductCard(product: item);
                  },
                ),

              const SizedBox(height: 24),

              // Support / Custom Engineering Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.engineering_rounded,
                      size: 38,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Need Custom Engineering?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Sankar Group design team can fabricate custom sealing gaskets & tooling to your exact CAD specs.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.88),
                              fontSize: 11,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

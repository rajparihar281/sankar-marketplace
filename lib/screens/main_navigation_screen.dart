import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/routes/app_routes.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import 'home/home_screen.dart';
import 'listing/product_listing_screen.dart';
import 'profile/profile_screen.dart';
import 'wishlist/wishlist_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    HomeScreen(),
    ProductListingScreen(),
    WishlistScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().itemCount;
    final wishlistCount = context.watch<WishlistProvider>().count;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: switchTab,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: wishlistCount > 0,
              label: Text(wishlistCount.toString()),
              backgroundColor: AppColors.accent,
              child: const Icon(Icons.favorite_outline_rounded),
            ),
            selectedIcon: Badge(
              isLabelVisible: wishlistCount > 0,
              label: Text(wishlistCount.toString()),
              backgroundColor: AppColors.accent,
              child: const Icon(Icons.favorite_rounded),
            ),
            label: 'Wishlist',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        backgroundColor: isDark ? AppColors.accent : AppColors.primary,
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.cart);
        },
        child: Badge(
          isLabelVisible: cartCount > 0,
          label: Text(
            cartCount.toString(),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: isDark ? AppColors.error : AppColors.accent,
          child: Icon(
            Icons.shopping_bag_outlined,
            color: isDark ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}


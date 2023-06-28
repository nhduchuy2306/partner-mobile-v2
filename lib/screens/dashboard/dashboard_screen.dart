import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:partner_mobile/provider/cart_provider.dart';
import 'package:partner_mobile/screens/cart/cart_screen.dart';
import 'package:partner_mobile/screens/home/home_screen.dart';
import 'package:partner_mobile/screens/notification/notification_screen.dart';
import 'package:partner_mobile/screens/profile/profile_screen.dart';
import 'package:partner_mobile/screens/shop/shop_screen.dart';
import 'package:partner_mobile/screens/wishlist/wishlist_screen.dart';
import 'package:partner_mobile/styles/app_colors.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _currentIndex = 0;

  late Future<int> cartCount = Future.value(0);

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
  }

  List<Widget> getScreens() {
    return [
      HomeScreen(
        goToShopScreen: (index) => setState(() {
          _currentIndex = index;
        }),
      ),
      const ShopScreen(),
      const CartScreen(),
      const WishlistScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screens = getScreens();

    final navigatorItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "Home",
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.shopping_bag),
        label: "Shop",
      ),
      BottomNavigationBarItem(
        icon: Consumer<CartProvider>(builder: (context, cartProvider, child) {
          if (cartProvider.cartItems.isEmpty) {
            return const Icon(Icons.shopping_cart);
          } else if (cartProvider.cartItems.length > 9) {
            return const Badge(
              label: Text(
                "9+",
                style: TextStyle(color: Colors.white),
              ),
              child: Icon(Icons.shopping_cart),
            );
          } else if (cartProvider.cartItems.isNotEmpty) {
            return Badge(
              label: Text(
                cartProvider.cartItems.length.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              child: const Icon(Icons.shopping_cart),
            );
          } else {
            return const Icon(Icons.shopping_cart);
          }
        }),
        label: "Cart",
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        label: "Wishlist",
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: "Profile",
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
        items: navigatorItems,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
      ),
    );
  }
}

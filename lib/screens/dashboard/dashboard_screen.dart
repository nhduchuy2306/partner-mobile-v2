import 'package:flutter/material.dart';
import 'package:partner_mobile/screens/cart/cart_screen.dart';
import 'package:partner_mobile/screens/home/home_screen.dart';
import 'package:partner_mobile/screens/notification/notification_screen.dart';
import 'package:partner_mobile/screens/profile/profile_screen.dart';
import 'package:partner_mobile/screens/shop/shop_screen.dart';
import 'package:partner_mobile/styles/app_colors.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _currentIndex = 0;

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
      const NotificationScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screens = getScreens();
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: navigatorItems,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  // // Screens
  // List<Widget> screens = [
  //   HomeScreen(
  //     // go to shop screen
  //     goToShopScreen: goToShopScreen(0),
  //   ),
  //   const ShopScreen(),
  //   const CartScreen(),
  //   const NotificationScreen(),
  //   const ProfileScreen(),
  // ];

  // Navigation Items
  List<BottomNavigationBarItem> navigatorItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "Home",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.shopping_bag),
      label: "Shop",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart),
      label: "Cart",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.notifications),
      label: "Notification",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: "Profile",
    ),
  ];
}

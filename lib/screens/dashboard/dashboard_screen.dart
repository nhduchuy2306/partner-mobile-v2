import 'package:flutter/material.dart';
import 'package:partner_mobile/screens/cart/cart_screen.dart';
import 'package:partner_mobile/screens/home/home_screen.dart';
import 'package:partner_mobile/screens/notification/notification_screen.dart';
import 'package:partner_mobile/screens/profile/profile_screen.dart';
import 'package:partner_mobile/screens/shop/shop_screen.dart';
import 'package:partner_mobile/services/cart_service.dart';
import 'package:partner_mobile/styles/app_colors.dart';

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
    updateCartCount();
  }

  Future<void> updateCartCount() async {
    final count = await CartService.getCartItemsCount();
    setState(() {
      cartCount = Future.value(count);
    });
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

    final navigatorItems = [
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

    return Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: FutureBuilder<int>(
            future: cartCount,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Error message
                } else {
                  return BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: (index) => setState(() {
                      _currentIndex = index;
                    }),
                    items: [
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: "Home",
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.shopping_bag),
                        label: "Shop",
                      ),
                      BottomNavigationBarItem(
                        // icon: Icon(Icons.shopping_cart),
                        icon: Badge(
                          label: Text(snapshot.data.toString()),
                          child: const Icon(Icons.shopping_cart),
                        ),
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
                    ],
                    selectedItemColor: AppColors.primaryColor,
                    unselectedItemColor: Colors.black,
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.white,
                  );
                }
              } else {
                return BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: (index) => setState(() {
                    _currentIndex = index;
                  }),
                  items: navigatorItems,
                  selectedItemColor: AppColors.primaryColor,
                  unselectedItemColor: Colors.black,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                );
              }
            }));
  }
}

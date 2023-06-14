import 'package:flutter/material.dart';

import '../Explore/explore_screen.dart';
import '../cart/cart_screen.dart';
import '../home/home_screen.dart';
import '../notification/notification_screen.dart';
import '../profile/profile_screen.dart';

// Navigation Items
List<BottomNavigationBarItem> navigatorItems = [
  const BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: "Home",
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.search),
    label: "Explore",
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

// Screens
List<Widget> screens = [
  const HomeScreen(),
  const ExploreScreen(),
  const CartScreen(),
  const NotificationScreen(),
  const ProfileScreen(),
];

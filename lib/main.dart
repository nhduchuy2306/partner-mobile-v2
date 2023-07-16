import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:partner_mobile/provider/brand_provider.dart';
import 'package:partner_mobile/provider/cart_provider.dart';
import 'package:partner_mobile/provider/category_provider.dart';
import 'package:partner_mobile/provider/dynamic_link_provider.dart';
import 'package:partner_mobile/provider/favorite_provider.dart';
import 'package:partner_mobile/provider/firebase_message_provider.dart';
import 'package:partner_mobile/provider/google_signin_provider.dart';
import 'package:partner_mobile/provider/payment_wallet_provider.dart';
import 'package:partner_mobile/screens/profile/payment_success.dart';
import 'package:partner_mobile/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final firebaseMessagingProvider = MyFirebaseMessagingProvider();
  await firebaseMessagingProvider.initialize();
  String? token = await firebaseMessagingProvider.getFCMToken();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('fcmToken', token ?? "");

  print('FCM Token: ${prefs.getString('fcmToken')}');
  print('Token Admin: ${prefs.getString('partnerTokenFromAdmin')}');
  print("partnerTokenFromAdmin: ${prefs.getString('partnerTokenFromAdmin')}");
  print("isPaymentSuccess: ${prefs.getBool('isPaymentSuccess')}");

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
    ChangeNotifierProvider(create: (_) => PaymentWalletProvider()),
    ChangeNotifierProvider(create: (_) => FavoriteProvider()),
    ChangeNotifierProvider(create: (_) => CategoryProvider()),
    ChangeNotifierProvider(create: (_) => BrandProvider()),
    ChangeNotifierProvider(create: (_) => DynamicLinkProvider(navigatorKey: GlobalKey<NavigatorState>()))
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gadget Zone',
      navigatorKey: navigatorKey,
      routes: {
        '/payment-success': (context) => const PaymentSuccess(),
        '/payment-fail': (context) => const PaymentSuccess(),
      },
      home: Builder(
        builder: (context) {
          final dynamicLinkProvider =
              DynamicLinkProvider(navigatorKey: navigatorKey);
          dynamicLinkProvider.handleDynamicLinks();
          return const SplashScreen();
        },
      ),
    );
  }
}

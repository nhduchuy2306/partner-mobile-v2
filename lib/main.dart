import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:partner_mobile/provider/firebase_message_provider.dart';
import 'package:partner_mobile/provider/cart_provider.dart';
import 'package:partner_mobile/provider/google_signin_provider.dart';
import 'package:partner_mobile/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final firebaseMessagingProvider = MyFirebaseMessagingProvider();
  await firebaseMessagingProvider.initialize();
  String? token = await firebaseMessagingProvider.getFCMToken();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('fcmToken', token ?? "");

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gadget Zone',
      home: SplashScreen(),
    );
  }
}

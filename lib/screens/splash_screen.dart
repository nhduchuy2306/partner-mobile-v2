import 'package:flutter/material.dart';
import 'package:partner_mobile/screens/dashboard/dashboard_screen.dart';
import 'package:partner_mobile/screens/welcome_screen.dart';
import 'package:partner_mobile/styles/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    init();
    const delay = Duration(seconds: 3);
    Future.delayed(delay, () => onTimerFinished());
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  void onTimerFinished() {
    var isFirstTime = prefs.getBool('isFirstTime');

    if (isFirstTime == true) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) {
          return const DashBoardScreen();
        },
      ));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) {
          return const WelcomeScreen();
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: splashScreenIcon(),
      ),
    );
  }
}

Widget splashScreenIcon() {
  return Container(
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          "assets/images/appLogo.png",
          color: Colors.white,
          width: 400,
          height: 400,
          fit: BoxFit.cover,
        ),
        const Center(
          child: Text(
            "GADGET ZONE",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

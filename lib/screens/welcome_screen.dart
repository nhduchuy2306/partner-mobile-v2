import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../styles/app_colors.dart';
import 'dashboard/dashboard_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              icon(),
              welcomeTextWidget(),
              const SizedBox(
                height: 10,
              ),
              sloganText(),
              const SizedBox(
                height: 40,
              ),
              getButton(context),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget icon() {
    String iconPath = "assets/images/appLogo.png";
    return Image.asset(
      iconPath,
      width: 300,
      height: 300,
      color: Colors.white,
    );
  }

  Widget welcomeTextWidget() {
    return const Column(
      children: [
        Text(
          "Welcome to",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          "Gadget Zone",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget sloganText() {
    return const Text(
      "The best place to buy gadgets",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget getButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: MaterialButton(
        onPressed: () {
          onGetStartedClicked(context);
        },
        child: const Text(
          "Get Started",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void onGetStartedClicked(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
        child: const DashBoardScreen(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }
}

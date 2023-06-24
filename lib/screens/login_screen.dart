import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:partner_mobile/helpers/constant_value.dart';
import 'package:partner_mobile/models/partner_token.dart';
import 'package:partner_mobile/models/user.dart';
import 'package:partner_mobile/models/user_info.dart';
import 'package:partner_mobile/provider/google_signin_provider.dart';
import 'package:partner_mobile/screens/dashboard/dashboard_screen.dart';
import 'package:partner_mobile/services/customer_membership_service.dart';
import 'package:partner_mobile/services/user_service.dart';
import 'package:partner_mobile/styles/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String image = "assets/images/gamepad.png";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
              color: Colors.black,
            ),
            Column(
              children: [
                const SizedBox(height: 50),
                Image.asset(image),
                const SizedBox(height: 20),
                const Text(
                  "Welcome to Gadget Zone",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      );
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final GoogleSignInProvider googleSignInProvider =
                          GoogleSignInProvider();
                      GoogleSignInAccount user =
                          await googleSignInProvider.googleLogin();
                      if (user != null) {
                        PartnerToken partnerToken = PartnerToken(
                          userName: ConstantValue.partnerUsername,
                          password: ConstantValue.partnerPassword,
                        );
                        String? partnerTokenFromAdmin =
                            await CustomerMemberShipService.getTokenOfPartner(
                                partnerToken);
                        print("partnerTokenFromAdmin: $partnerTokenFromAdmin" ??
                            "");
                        if (partnerTokenFromAdmin != null) {
                          prefs.setString(
                              "partnerTokenFromAdmin", partnerTokenFromAdmin);
                        }
                        UserInfo userInfo = UserInfo(
                            displayName: user.displayName,
                            email: user.email,
                            phoneNumber: "",
                            photoURL: user.photoUrl,
                            uid: user.id,
                            providerId: "");
                        User? userModel = await UserService.getUserByUsername(
                            user.id ?? "");
                        if (userModel == null) {
                          await UserService.register(userInfo);
                        }
                      }
                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: const DashBoardScreen(),
                            ));
                      });
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.google,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Sign in with Google",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

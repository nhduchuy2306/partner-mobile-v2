import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:partner_mobile/common_widgets/app_button.dart';
import 'package:partner_mobile/models/customer_membership.dart';
import 'package:partner_mobile/provider/google_signin_provider.dart';
import 'package:partner_mobile/screens/login_screen.dart';
import 'package:partner_mobile/screens/profile/order_history_screen.dart';
import 'package:partner_mobile/services/customer_membership_service.dart';
import 'package:partner_mobile/styles/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? user = FirebaseAuth.instance.currentUser;
  late UserInfo? userInfo = user?.providerData[0];

  late Future<CustomerMemberShip> customerMemberShips;

  @override
  void initState() {
    super.initState();
    setState(() {
      user = FirebaseAuth.instance.currentUser;
      userInfo = user?.providerData[0];
      customerMemberShips =
          CustomerMemberShipService.getCustomerMemberShipById(userInfo?.uid ?? "1");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            getProfileOfUser(userInfo),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 1,
            ),
            settingBar(userInfo),
            const Divider(
              thickness: 1,
            ),
            logoutButton(userInfo),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget settingBar(userInfo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: OrderHistoryScreen(userInfo: userInfo),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: const ListTile(
          leading: Icon(
            Icons.history,
            color: Colors.black,
            size: 30,
          ),
          title: Text(
            "Order History",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "My Order History",
            style: TextStyle(
                fontSize: 16,
                color: Color(0xff7C7C7C),
                fontWeight: FontWeight.normal),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Color(0xff7C7C7C),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget getImageHeader(userInfo) {
    String imagePath = "assets/images/profile.png";
    if (userInfo != null) {
      imagePath = userInfo.photoURL ?? "assets/images/profile.png";
      return CircleAvatar(
        radius: 5.0,
        backgroundImage: NetworkImage(imagePath, scale: 1.0),
        backgroundColor: AppColors.primaryColor.withOpacity(0.7),
      );
    } else {
      return CircleAvatar(
        radius: 5.0,
        backgroundImage: AssetImage(imagePath),
        backgroundColor: AppColors.primaryColor.withOpacity(0.7),
      );
    }
  }

  Widget logoutButton(userInfo) {
    if (userInfo == null) {
      return Container();
    }
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          elevation: 0,
          backgroundColor: const Color(0xffF2F3F2),
          textStyle: const TextStyle(
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 25),
          minimumSize: const Size.fromHeight(50),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Icon(
                Icons.logout,
                color: AppColors.primaryColor,
              ),
            ),
            Text(
              "Log Out",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );

          GoogleSignInProvider googleSignInProvider = GoogleSignInProvider();
          await googleSignInProvider.googleLogout();
          setState(() {
            user = null;
            this.userInfo = null;
          });
          Future.delayed(
            const Duration(seconds: 1),
            () {
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  Widget getProfileOfUser(userInfo) {
    if (user != null) {
      return Column(
        children: [
          ListTile(
            leading: SizedBox(
                width: 65, height: 65, child: getImageHeader(userInfo)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  userInfo.displayName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    FontAwesomeIcons.pen,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              userInfo?.email,
              style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff7C7C7C),
                  fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<CustomerMemberShip>(
              future: customerMemberShips,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 30),
                            width: MediaQuery.of(context).size.width / 3,
                            child: Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.rankingStar,
                                  color: Colors.blueAccent,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${snapshot.data?.membership?.level}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 70),
                            child: Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.wallet,
                                  color: Colors.deepOrangeAccent,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${snapshot.data?.walletList?[0].balance?.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 30),
                            width: MediaQuery.of(context).size.width / 3,
                            child: Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.medal,
                                  color: Colors.amber,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 5,
                                      child: LinearProgressIndicator(
                                        value: ((snapshot.data?.membership
                                                    ?.totalReceipt ??
                                                1) /
                                            (snapshot.data?.nextLevel
                                                    ?.condition ??
                                                2)),
                                        backgroundColor: Colors.grey[300],
                                        valueColor:
                                            const AlwaysStoppedAnimation(
                                                Colors.orange),
                                        minHeight: 20,
                                      ),
                                    ),
                                    Text(
                                      "${snapshot.data?.membership?.totalReceipt?.toStringAsFixed(0)}/"
                                      "${snapshot.data?.nextLevel?.condition?.toStringAsFixed(0)}",
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 70),
                            child: Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.coins,
                                  color: Colors.lime,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${snapshot.data?.membership?.totalExpenditure?.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ],
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // button login
            ButtonWidget(
              text: "Login",
              roundness: 10,
              thickness: 1,
              fontWeight: FontWeight.bold,
              padding: const EdgeInsets.all(10),
              fontSize: 20,
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: const LoginScreen(),
                    type: PageTransitionType.bottomToTop,
                    duration: const Duration(milliseconds: 200),
                  ),
                );
              },
              textColor: AppColors.primaryColor,
            ),
            // button register
            ButtonWidget(
              text: "Register",
              roundness: 10,
              thickness: 1,
              fontWeight: FontWeight.bold,
              padding: const EdgeInsets.all(10),
              fontSize: 20,
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: const LoginScreen(),
                    type: PageTransitionType.bottomToTop,
                    duration: const Duration(milliseconds: 200),
                  ),
                );
              },
              textColor: AppColors.darkGrey,
              borderColor: AppColors.darkGrey,
            ),
          ],
        ),
      );
    }
  }
}

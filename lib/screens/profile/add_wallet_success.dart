import 'package:flutter/material.dart';
import 'package:partner_mobile/models/push_notification.dart';
import 'package:partner_mobile/screens/dashboard/dashboard_screen.dart';
import 'package:partner_mobile/services/push_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddWalletSuccess extends StatefulWidget {
  const AddWalletSuccess({super.key});

  @override
  State<AddWalletSuccess> createState() => _AddWalletSuccessState();
}

class _AddWalletSuccessState extends State<AddWalletSuccess> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _pushNoti() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? fcmToken = prefs.getString('fcmToken');
    Data data = Data(
        additionalProp1: "Create Wallet",
        additionalProp2: "You have a new wallet",
        additionalProp3: "FLUTTER_NOTIFICATION_CLICK");
    PushNotification pushNotification = PushNotification(
        subject: "Create Wallet",
        content: "You have a new wallet",
        data: data,
        token: fcmToken);

    await PushNotificationService.createNotification(pushNotification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Add Wallet Success'),
          leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashBoardScreen()),
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
              size: 30,
            ),
          )),
      body: const Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            size: 200,
            color: Colors.green,
          ),
          SizedBox(height: 20),
          Text(
            'Add new Wallet Success',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      )),
    );
  }
}

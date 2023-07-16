import 'package:flutter/material.dart';
import 'package:partner_mobile/models/raise_recharge_wallet.dart';
import 'package:partner_mobile/provider/dynamic_link_provider.dart';
import 'package:partner_mobile/screens/dashboard/dashboard_screen.dart';
import 'package:partner_mobile/services/raise_recharge_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({super.key, this.raiseWallet});

  final RaiseWallet? raiseWallet;

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  bool isPaymentSuccess = false;

  @override
  void initState() {
    super.initState();
    _raiseRechargeRequest();
  }

  void _raiseRechargeRequest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isPaymentSuccess = prefs.getBool('isPaymentSuccess') ?? false;
    setState(() {
      isPaymentSuccess = prefs.getBool('isPaymentSuccess') ?? false;
    });
    if (isPaymentSuccess) {
      prefs.remove('isPaymentSuccess');
      await RaiseRechargeService.raiseRechargeRequest(widget.raiseWallet!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const DashBoardScreen()),
          (route) => false,
        );
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Payment Success'),
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
        body: isPaymentSuccess == true
            ? const Center(
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
                      'Payment Success',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      size: 200,
                      color: Colors.red,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Payment Fail, Please try again',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

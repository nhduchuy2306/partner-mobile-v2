import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicLinkProvider extends ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey;
  bool isPaymentSuccess = false;

  DynamicLinkProvider({required this.navigatorKey});

  void setPaymentSuccess(bool value) {
    isPaymentSuccess = value;
    notifyListeners();
  }

  Future handleDynamicLinks() async {
    // Get initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDeepLink(data);

    // Handle dynamic link when the app is opened
    FirebaseDynamicLinks.instance.onLink.listen((event) {
      _handleDeepLink(event);
    });
  }

  // Handle dynamic link when the app is opened
  Future _handleDeepLink(PendingDynamicLinkData? data) async {
    final Uri? deepLink = data?.link;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');
      String url = deepLink.toString();
      if (url.contains('message=fail')) {
        setPaymentSuccess(false);
        prefs.setBool('isPaymentSuccess', false);
        print("Payment Failed: $isPaymentSuccess");
        navigatorKey.currentState!.popAndPushNamed('/payment-fail');
        return;
      } else if (url.contains('message=success')) {
        setPaymentSuccess(true);
        prefs.setBool('isPaymentSuccess', true);
        print("Payment Success: $isPaymentSuccess");
      }
    }
  }

  bool getPaymentSuccess() {
    SharedPreferences.getInstance().then((prefs) {
      isPaymentSuccess = prefs.getBool('isPaymentSuccess') ?? false;
      print("isPaymentSuccess: $isPaymentSuccess");
    });
    return isPaymentSuccess;
  }
}

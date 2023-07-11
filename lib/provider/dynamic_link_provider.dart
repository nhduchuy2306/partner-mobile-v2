import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinkProvider extends ChangeNotifier {

  Future handleDynamicLinks() async {
    // Get initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    // Handle dynamic link inside the app
    _handleDeepLink(data);

    // Handle dynamic link when the app is opened
    FirebaseDynamicLinks.instance.onLink;
  }

  // Handle dynamic link when the app is opened
  Future _handleDeepLink(PendingDynamicLinkData? data) async {
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');
      // Navigator.pushNamed(context, deepLink.path);
    }
  }
}

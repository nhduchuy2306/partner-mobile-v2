import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:partner_mobile/models/cart_item.dart';
import 'package:partner_mobile/models/customer_membership.dart';
import 'package:partner_mobile/models/order_request.dart';
import 'package:partner_mobile/models/push_notification.dart';
import 'package:partner_mobile/provider/cart_provider.dart';
import 'package:partner_mobile/provider/payment_wallet_provider.dart';
import 'package:partner_mobile/services/customer_membership_service.dart';
import 'package:partner_mobile/services/order_service.dart';
import 'package:partner_mobile/services/push_notification_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutBottomSheet extends StatefulWidget {
  const CheckoutBottomSheet({super.key, required this.totalAmount});

  final double totalAmount;

  @override
  _CheckoutBottomSheetState createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {
  late User? user = FirebaseAuth.instance.currentUser;
  late UserInfo? userInfo = user?.providerData[0];
  late List<int> _selectedPaymentWalletIds;

  @override
  void initState() {
    super.initState();
    setState(() {
      user = FirebaseAuth.instance.currentUser;
      userInfo = user?.providerData[0];
      _selectedPaymentWalletIds = [];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 30,
      ),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Wrap(
        children: <Widget>[
          Row(
            children: [
              const Text(
                "Checkout",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    size: 25,
                  ))
            ],
          ),
          const SizedBox(
            height: 45,
          ),
          getDivider(),
          checkoutRow("Delivery",
              trailingText: "Select Method", showArrow: true),
          getDivider(),
          checkoutRow("Payment",
              trailingWidget: const Icon(
                Icons.payment,
              ),
              showArrow: true, onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                Future<CustomerMemberShip> customerMembershipFuture =
                    CustomerMemberShipService.getCustomerMemberShipById(userInfo?.uid ?? "1");
                return AlertDialog(
                  title: const Text("Payment Wallet"),
                  content: SingleChildScrollView(
                    child: Consumer<PaymentWalletProvider>(
                        builder: (context, paymentWalletProvider, child) {
                      return FutureBuilder<CustomerMemberShip>(
                        future: customerMembershipFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListBody(
                              children: snapshot.data!.walletList!.map((item) {
                                return CheckboxListTile(
                                    title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('${item.type}'),
                                        Text(
                                            '\$ ${item.balance!.toStringAsFixed(0)}')
                                      ],
                                    ),
                                    value: paymentWalletProvider
                                        .selectedPaymentWalletIds
                                        .contains(item),
                                    onChanged: (isSelected) {
                                      if (isSelected!) {
                                        paymentWalletProvider
                                            .addPaymentWalletId(item);
                                      } else {
                                        paymentWalletProvider
                                            .removePaymentWalletId(item);
                                      }
                                    });
                              }).toList(),
                            );
                          } else if (snapshot.hasError) {
                            return const Text("Error");
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                    }),
                  ),
                );
              },
            );
          }),
          getDivider(),
          checkoutRow("Total Cost",
              trailingText: "${widget.totalAmount.toStringAsFixed(0)} VND"),
          getDivider(),
          const SizedBox(
            height: 30,
          ),
          termsAndConditionsAgreement(context),
          Container(
            margin: const EdgeInsets.only(
              top: 25,
            ),
            child:
                Consumer<CartProvider>(builder: (context, cartProvider, child) {
              return GestureDetector(
                onTap: () async {
                  if (userInfo == null) {
                    showErrorDialog();
                  }

                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  final String? token = prefs.getString('fcmToken');

                  Future<String> playOrderFuture =
                      placeOrder(cartProvider.cartItems);
                  playOrderFuture.then((value) {
                    if (value == "success") {
                      cartProvider.clearCart();

                      Data data = Data(
                          additionalProp1: "New Order",
                          additionalProp2: "You have a new order",
                          additionalProp3: "FLUTTER_NOTIFICATION_CLICK");

                      PushNotification pushNotification = PushNotification(
                          subject: "New Order",
                          content: "You have a new order",
                          data: data,
                          token: token);

                      Future<String> pushNotificationService =
                          PushNotificationService.createNotification(
                              pushNotification);

                      pushNotificationService.then((value) {
                        print(value);
                      });

                      Navigator.pop(context);
                      showOrderPlacedDialog();
                    } else {
                      Navigator.pop(context);
                      showOrderFailedDialog();
                    }
                  });
                },
                child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFC6A57),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      "Place Order",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget getDivider() {
    return const Divider(
      thickness: 1,
      color: Color(0xFFE2E2E2),
    );
  }

  Widget termsAndConditionsAgreement(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: 'By placing an order you agree to our',
          style: TextStyle(
            color: const Color(0xFF7C7C7C),
            fontSize: 14,
            fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
            fontWeight: FontWeight.w600,
          ),
          children: const [
            TextSpan(
              text: " Terms",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            TextSpan(text: " And"),
            TextSpan(
              text: " Conditions",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
    );
  }

  Widget checkoutRow(String label,
      {String? trailingText,
      Widget? trailingWidget,
      bool? showArrow,
      Function()? onTap}) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            trailingText == null
                ? (trailingWidget ?? Container())
                : Text(
                    trailingText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7C7C7C),
                    ),
                  ),
            const SizedBox(
              width: 20,
            ),
            showArrow == null || showArrow == false
                ? Container()
                : const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  )
          ],
        ),
      ),
    );
  }

  Future<String> placeOrder(List<CartItem> carts) async {
    if (userInfo == null) {
      return "error";
    }

    if (carts.isEmpty) {
      return "empty";
    }

    List<CartItems> cartItems = [];

    for (var cart in carts) {
      cartItems.add(CartItems(
          productId: cart.product?.productId,
          quantity: cart.quantity,
          price: cart.product!.price,
          productName: cart.product!.productName,
          productImage: cart.product!.picture));
    }

    var orderRequest =
        OrderRequest(userName: userInfo?.uid, cartItems: cartItems);
    var response = await OrderService.createOrder(orderRequest);
    return response;
  }

  void showErrorDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Please login before placing order"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
          );
        });
  }

  void showOrderPlacedDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Order Placed"),
            content: const Text("Your order has been placed successfully"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
          );
        });
  }

  void showOrderFailedDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Order Failed"),
            content: const Text("Your order has been failed"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
          );
        });
  }
}

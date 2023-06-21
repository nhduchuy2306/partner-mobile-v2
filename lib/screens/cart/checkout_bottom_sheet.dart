import 'package:flutter/material.dart';

class CheckoutBottomSheet extends StatefulWidget {
  const CheckoutBottomSheet({super.key, required this.totalAmount});

  final double totalAmount;

  @override
  _CheckoutBottomSheetState createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {
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
              showArrow: true),
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
            child: GestureDetector(
              onTap: () {
                onPlaceOrderClicked();
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
            ),
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
            fontFamily: Theme.of(context).textTheme.bodyText1?.fontFamily,
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
      {String? trailingText, Widget? trailingWidget, bool? showArrow}) {
    return Container(
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
    );
  }

  void onPlaceOrderClicked() {
    Navigator.pop(context);
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
}

import 'package:flutter/material.dart';
import 'package:partner_mobile/models/product.dart';
import 'package:partner_mobile/models/product_item.dart';
import 'package:partner_mobile/styles/app_colors.dart';

class ItemCardWidget extends StatelessWidget {
  const ItemCardWidget({Key? key, required this.item})
      : super(key: key);
  final Product item;

  final double width = 200;
  final double height = 500;
  final Color borderColor = const Color(0xffE2E2E2);
  final double borderRadius = 18;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(
          borderRadius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: imageWidget(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              item.productName!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "${item.price?.toStringAsFixed(0)} VNĐ",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    print("Add to cart");
                  },
                  child: addWidget(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget imageWidget() {
    return Image.network(
      item.picture!,
      width: 300,
      height: 300,
      fit: BoxFit.cover,
    );
  }

  Widget addWidget() {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          color: AppColors.primaryColor),
      child: const Center(
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:partner_mobile/models/product_item.dart';
import 'package:partner_mobile/styles/app_colors.dart';

class ItemCardWidget extends StatelessWidget {
  const ItemCardWidget({Key? key, required this.item, this.heroSuffix})
      : super(key: key);
  final ProductItem item;
  final String? heroSuffix;

  final double width = 174;
  final double height = 250;
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
                child: Hero(
                  tag: "GroceryItem:${item.name}-${heroSuffix ?? ""}",
                  child: imageWidget(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              item.description,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7C7C7C),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "\$${item.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                addWidget()
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget imageWidget() {
    return Image.asset(item.imagePath);
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

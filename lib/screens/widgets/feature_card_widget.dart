import 'package:flutter/material.dart';
import 'package:partner_mobile/styles/app_colors.dart';

class FeaturedItem {
  final String name;
  final String imagePath;

  FeaturedItem(this.name, this.imagePath);
}

class FeaturedCard extends StatelessWidget {
  const FeaturedCard(this.featuredItem,
      {super.key, this.color = AppColors.primaryColor});

  final FeaturedItem featuredItem;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 105,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 17),
      decoration: BoxDecoration(
          color: color.withOpacity(0.25),
          borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Image.network(
            featuredItem.imagePath,
            width: 70,
            height: 70,
            fit: BoxFit.contain,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            featuredItem.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

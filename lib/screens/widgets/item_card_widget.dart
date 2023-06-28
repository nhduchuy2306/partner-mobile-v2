import 'package:flutter/material.dart';
import 'package:partner_mobile/models/product.dart';
import 'package:partner_mobile/provider/cart_provider.dart';
import 'package:partner_mobile/provider/favorite_provider.dart';
import 'package:partner_mobile/styles/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemCardWidget extends StatelessWidget {
  const ItemCardWidget(
      {Key? key, required this.item, this.width = 200, this.height = 500})
      : super(key: key);
  final Product item;

  final double? width;
  final double? height;
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
          horizontal: 10,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: imageWidget(),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              item.productName!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Text(
                      "\$ ${item.price?.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 13,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          return GestureDetector(
                            onTap: () {
                              cartProvider.addToCart(item, 1);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Add to cart successfully!'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 13, right: 13, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: addWidget(),
                            ),
                          );
                        },
                      ),
                      Consumer<FavoriteProvider>(builder:(context, favoriteProvider, child){
                        return IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: favoriteProvider.isFavorite(item)
                                ? Colors.red
                                : Colors.grey,
                            size: 20,
                          ),
                          onPressed: ()  {
                            favoriteProvider.addFavorite(item);
                          },
                        );
                      })
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageWidget() {
    return Image.network(
      item.picture!,
      width: 150,
      height: 100,
      fit: BoxFit.cover,
    );
  }

  Widget addWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          color: AppColors.primaryColor),
      child: const Center(
        child: Text(
          "Add To Cart",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

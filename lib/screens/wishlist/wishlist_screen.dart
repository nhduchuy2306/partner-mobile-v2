import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:partner_mobile/models/product_description.dart';
import 'package:partner_mobile/models/product_picture.dart';
import 'package:partner_mobile/provider/favorite_provider.dart';
import 'package:partner_mobile/screens/products/product_detail_screen.dart';
import 'package:partner_mobile/services/product_description_service.dart';
import 'package:partner_mobile/services/product_picture_service.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    var favoriteList = context.watch<FavoriteProvider>().favoriteList;

    Future<List<ProductPicture>> getProductPicture(int id) async {
      var productPicture =
          await ProductPictureService.getAllPictureForProductById(id);
      return productPicture;
    }

    Future<ProductDescription> getProductDescriptionById(int id) async {
      var productDescription =
          await ProductDescriptionService.getDescriptionByProductId(id);
      return productDescription;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wishlist",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: favoriteList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: ProductDetailScreen(
                    product: favoriteList[index],
                    productPictures:
                        getProductPicture(favoriteList[index].productId!),
                    productDescription: getProductDescriptionById(
                        favoriteList[index].productId!),
                  ),
                  type: PageTransitionType.bottomToTop,
                ),
              );
            },
            child: Card(
              child: ListTile(
                leading: Image.network(
                  favoriteList[index].picture!,
                  width: 100,
                  height: 100,
                ),
                title: Text(favoriteList[index].productName!),
                subtitle:
                    Text('\$${favoriteList[index].price!.toStringAsFixed(0)}'),
                trailing: Consumer<FavoriteProvider>(
                    builder: (context, favoriteProvider, child) {
                  return IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: favoriteProvider.isFavorite(favoriteList[index])
                          ? Colors.red
                          : Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      favoriteProvider.addFavorite(favoriteList[index]);
                    },
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}

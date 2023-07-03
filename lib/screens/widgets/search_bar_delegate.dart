import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:partner_mobile/models/product.dart';
import 'package:partner_mobile/models/product_description.dart';
import 'package:partner_mobile/models/product_picture.dart';
import 'package:partner_mobile/screens/products/product_detail_screen.dart';
import 'package:partner_mobile/services/product_description_service.dart';
import 'package:partner_mobile/services/product_picture_service.dart';
import 'package:partner_mobile/services/product_service.dart';

class MySearchDelegate extends SearchDelegate {
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    Future<List<Product>> getProductByName(String name) {
      var products = ProductService.getAllProductPagination(
          1, 18, name, null, null, null, null);
      return products;
    }

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

    return Container(
      margin: const EdgeInsets.all(12),
      child: FutureBuilder<List<Product>>(
        future: getProductByName(query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var products = snapshot.data!;
            return GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              children: products.map((e) {
                return Container(
                  margin: const EdgeInsets.all(2),
                  child: Column(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.bottomToTop,
                                duration: const Duration(milliseconds: 300),
                                child: ProductDetailScreen(
                                    product: e,
                                    productDescription:
                                        getProductDescriptionById(e.productId!),
                                    productPictures:
                                        getProductPicture(e.productId!)),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                e.picture ?? "",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          e.productName ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          "\$${e.price!.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Future<List<Product>> getBestSellingProducts() async {
      var categories = await ProductService.getBestSellingProducts();
      return categories;
    }

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

    return Container(
      margin: const EdgeInsets.all(12),
      child: FutureBuilder(
        future: getBestSellingProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var products = snapshot.data!;
            return GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              children: products.map((e) {
                return Container(
                  margin: const EdgeInsets.all(2),
                  child: Column(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.bottomToTop,
                                duration: const Duration(milliseconds: 300),
                                child: ProductDetailScreen(
                                    product: e,
                                    productDescription:
                                        getProductDescriptionById(e.productId!),
                                    productPictures:
                                        getProductPicture(e.productId!)),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                e.picture ?? "",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          e.productName ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          "\$${e.price!.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

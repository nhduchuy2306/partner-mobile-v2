import 'dart:math';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:partner_mobile/models/category.dart';
import 'package:partner_mobile/models/product.dart';
import 'package:partner_mobile/models/product_description.dart';
import 'package:partner_mobile/models/product_picture.dart';
import 'package:partner_mobile/models/title_enum.dart';
import 'package:partner_mobile/screens/home/home_banner.dart';
import 'package:partner_mobile/screens/notification/notification_screen.dart';
import 'package:partner_mobile/screens/products/product_detail_screen.dart';
import 'package:partner_mobile/screens/widgets/feature_card_widget.dart';
import 'package:partner_mobile/screens/widgets/item_card_widget.dart';
import 'package:partner_mobile/screens/widgets/search_bar_widget.dart';
import 'package:partner_mobile/services/category_service.dart';
import 'package:partner_mobile/services/product_description_service.dart';
import 'package:partner_mobile/services/product_picture_service.dart';
import 'package:partner_mobile/services/product_service.dart';
import 'package:partner_mobile/styles/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.goToShopScreen});

  final Function(int) goToShopScreen;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories = [];
  List<Product> latestProducts = [];
  List<Product> bestSellingProducts = [];

  late Future<List<Category>> futureCategories;
  late Future<List<Product>> futureLatestProducts;
  late Future<List<Product>> futureBestSellingProducts;

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryService.getCategories();
    futureLatestProducts = ProductService.getLatestProducts();
    futureBestSellingProducts = ProductService.getBestSellingProducts();

    futureCategories.then((value) {
      setState(() {
        categories = value;
      });
    });
    futureLatestProducts.then((value) {
      setState(() {
        latestProducts = value;
      });
    });
    futureBestSellingProducts.then((value) {
      setState(() {
        bestSellingProducts = value;
      });
    });
  }

  Future refresh() async {
    setState(() {
      futureCategories = CategoryService.getCategories();
      futureLatestProducts = ProductService.getLatestProducts();
      futureBestSellingProducts = ProductService.getBestSellingProducts();

      futureCategories.then((value) {
        setState(() {
          categories = value;
        });
      });
      futureLatestProducts.then((value) {
        setState(() {
          latestProducts = value;
        });
      });
      futureBestSellingProducts.then((value) {
        setState(() {
          bestSellingProducts = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Gadget Zone",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  padded(const SearchBarWidget()),
                  const SizedBox(
                    height: 25,
                  ),
                  const HomeBanner(),
                  const SizedBox(
                    height: 25,
                  ),
                  if (bestSellingProducts.isNotEmpty)
                    Column(
                      children: [
                        padded(subTitle("Best Selling", TitleEnum.bestSelling)),
                        getHorizontalItemSliderWithFuture(
                            futureBestSellingProducts),
                      ],
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (latestProducts.isNotEmpty)
                    Column(
                      children: [
                        padded(subTitle(
                            "Latest Product", TitleEnum.latestProduct)),
                        getHorizontalItemSliderWithFuture(futureLatestProducts),
                      ],
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                  padded(subTitle("Categories", TitleEnum.categories)),
                  const SizedBox(
                    height: 15,
                  ),
                  getHorizontalCategoryWithFuture(futureCategories),
                  const SizedBox(
                    height: 15,
                  ),
                  getHorizontalItemSliderWithFuture(futureLatestProducts),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget padded(Widget widget) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: widget,
    );
  }

  // get title
  Widget subTitle(String text, TitleEnum titleEnum) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            widget.goToShopScreen!(1);
          },
          child: const Text(
            "See All",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  // get all products using future
  Widget getHorizontalItemSliderWithFuture(
      Future<List<Product>> futureProducts) {
    return FutureBuilder<List<Product>>(
      future: futureProducts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return getHorizontalItemSlider(snapshot.data!);
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Error, Must connect to internet"),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // get all products
  Widget getHorizontalItemSlider(List<Product> items) {
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
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 270,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.bottomToTop,
                  child: ProductDetailScreen(
                    product: items[index]!,
                    productDescription:
                        getProductDescriptionById(items[index]!.productId!),
                    productPictures:
                        getProductPicture(items[index]!.productId!),
                  ),
                ),
              );
            },
            child: ItemCardWidget(
              item: items[index],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: 20,
          );
        },
      ),
    );
  }

  // get all catergories using future
  Widget getHorizontalCategoryWithFuture(
      Future<List<Category>> futureCategories) {
    return FutureBuilder<List<Category>>(
      future: futureCategories,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return getHorizontalCategory(snapshot.data!);
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Error, Must connect to internet"),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // get all categories
  Widget getHorizontalCategory(List<Category> categories) {
    return SizedBox(
      height: 105,
      child: ListView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    print("Category ${categories[index].categoryName}");
                  },
                  child: FeaturedCard(
                    FeaturedItem(categories[index].categoryName!,
                        categories[index].categoryPicture!),
                    color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                        .withOpacity(1.0),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            );
          }),
    );
  }
}

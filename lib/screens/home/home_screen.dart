import 'dart:math';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:partner_mobile/models/category.dart';
import 'package:partner_mobile/models/product.dart';
import 'package:partner_mobile/models/title_enum.dart';
import 'package:partner_mobile/screens/home/home_banner.dart';
import 'package:partner_mobile/screens/products/product_detail_screen.dart';
import 'package:partner_mobile/screens/widgets/feature_card_widget.dart';
import 'package:partner_mobile/screens/widgets/item_card_widget.dart';
import 'package:partner_mobile/screens/widgets/search_bar_widget.dart';
import 'package:partner_mobile/services/category_service.dart';
import 'package:partner_mobile/services/product_service.dart';
import 'package:partner_mobile/styles/app_colors.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Category> categories = [];
  List<Product> latestProducts = [];

  @override
  void initState() {
    super.initState();
    CategoryService.getCategories().then((value) {
      setState(() {
        categories = value;
      });
    });
    ProductService.getLatestProducts().then((value) {
      setState(() {
        latestProducts = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
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
                padded(subTitle("Best Selling", TitleEnum.bestSelling)),
                getHorizontalItemSlider(latestProducts),
                const SizedBox(
                  height: 15,
                ),
                padded(subTitle("Latest Product", TitleEnum.exclusiveOrder)),
                getHorizontalItemSlider(latestProducts),
                const SizedBox(
                  height: 15,
                ),
                padded(subTitle("Categories", TitleEnum.others)),
                const SizedBox(
                  height: 15,
                ),
                getHorizontalCategory(categories),
                const SizedBox(
                  height: 15,
                ),
                getHorizontalItemSlider(latestProducts),
                const SizedBox(
                  height: 15,
                ),
              ],
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
            if (titleEnum == TitleEnum.exclusiveOrder) {
              print("See All Exclusive Order");
            } else if (titleEnum == TitleEnum.bestSelling) {
              print("See All $titleEnum");
            } else if (titleEnum == TitleEnum.others) {
              print("See All $titleEnum");
            }
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

  // get all products
  Widget getHorizontalItemSlider(List<Product> items) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 250,
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
                    child: ProductDetailScreen(productId: items[index].productId!)
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

  // get all categories
  Widget getHorizontalCategory(List<Category> categories) {
    return SizedBox(
      height: 105,
      child: ListView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index){
            return Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                FeaturedCard(
                  FeaturedItem(categories[index].categoryName!, categories[index].categoryPicture!),
                  color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            );
          }
      ),
    );
  }
}

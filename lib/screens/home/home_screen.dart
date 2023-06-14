import 'package:flutter/material.dart';
import 'package:partner_mobile/models/product_item.dart';
import 'package:partner_mobile/models/title_enum.dart';
import 'package:partner_mobile/screens/home/home_banner.dart';
import 'package:partner_mobile/screens/widgets/feature_card_widget.dart';
import 'package:partner_mobile/screens/widgets/item_card_widget.dart';
import 'package:partner_mobile/screens/widgets/search_bar_widget.dart';
import 'package:partner_mobile/styles/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                padded(subTitle("Exclusive Order", TitleEnum.exclusiveOrder)),
                getHorizontalItemSlider(exclusiveOffers),
                const SizedBox(
                  height: 15,
                ),
                padded(subTitle("Best Selling", TitleEnum.bestSelling)),
                getHorizontalItemSlider(bestSelling),
                const SizedBox(
                  height: 15,
                ),
                padded(subTitle("Others", TitleEnum.others)),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 105,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      FeaturedCard(
                        featuredItems[0],
                        color: const Color(0xffF8A44C),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      FeaturedCard(
                        featuredItems[1],
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                getHorizontalItemSlider(others),
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

  Widget getHorizontalItemSlider(List<ProductItem> items) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 250,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: ItemCardWidget(
              item: items[index],
              heroSuffix: "home_screen",
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
}

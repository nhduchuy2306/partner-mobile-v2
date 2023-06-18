import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:partner_mobile/models/brand.dart';
import 'package:partner_mobile/models/product.dart';
import 'package:partner_mobile/models/product_description.dart';
import 'package:partner_mobile/models/product_picture.dart';
import 'package:partner_mobile/models/category.dart';
import 'package:partner_mobile/screens/products/product_detail_screen.dart';
import 'package:partner_mobile/screens/shop/filter_screen.dart';
import 'package:partner_mobile/screens/widgets/item_card_widget.dart';
import 'package:partner_mobile/services/brand_service.dart';
import 'package:partner_mobile/services/category_service.dart';
import 'package:partner_mobile/services/product_description_service.dart';
import 'package:partner_mobile/services/product_picture_service.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final _baseUrl = "https://my-happygear.azurewebsites.net/happygear/api";
  int _page = 1;
  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  final List<Product> _products = [];

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;
      try {
        final res = await http.get(Uri.parse("$_baseUrl/products?p=$_page"));
        if (res.statusCode == 200) {
          final productsJson = json.decode(utf8.decode(res.bodyBytes));
          if (productsJson.length == 0) {
            setState(() {
              _hasNextPage = false;
            });
          } else {
            setState(() {
              _hasNextPage = true;
            });
            for (var productJson in productsJson[0]) {
              _products.add(Product.fromJson(productJson));
            }
          }
        }
      } catch (e) {
        print("Something went wrong: $e");
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      final res = await http.get(Uri.parse("$_baseUrl/products?p=$_page"));
      if (res.statusCode == 200) {
        final productsJson = json.decode(utf8.decode(res.bodyBytes));
        for (var productJson in productsJson[0]) {
          _products.add(Product.fromJson(productJson));
        }
      }
    } catch (e) {
      print("Something went wrong: $e");
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _scrollController = ScrollController()..addListener(_loadMore);
  }

  @override
  Widget build(BuildContext context) {
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

    Future<List<Category>> getCategories() async {
      var categories = await CategoryService.getCategories();
      return categories;
    }

    Future<List<Brand>> getBrands() async {
      var brands = await BrandService.getBrands();
      return brands;
    }

    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: const EdgeInsets.only(left: 45),
          child: const Center(
            child: Text(
              "Happy Gear",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.bottomToTop,
                  duration: const Duration(milliseconds: 300),
                  child: FilterScreen(
                    categories: getCategories(),
                    brands: getBrands(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: _isFirstLoadRunning
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                      ),
                      controller: _scrollController,
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final items = _products[index];
                        return Container(
                          margin: const EdgeInsets.all(5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: ProductDetailScreen(
                                    product: items!,
                                    productDescription:
                                        getProductDescriptionById(
                                            items!.productId!),
                                    productPictures:
                                        getProductPicture(items!.productId!),
                                  ),
                                ),
                              );
                            },
                            child: ItemCardWidget(
                              item: items,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (_isLoadMoreRunning == true)
                    const Padding(
                      padding: EdgeInsets.all(5),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
    );
  }
}

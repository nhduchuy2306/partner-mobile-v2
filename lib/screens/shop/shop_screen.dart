import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:partner_mobile/models/brand.dart';
import 'package:partner_mobile/models/category.dart';
import 'package:partner_mobile/models/product.dart';
import 'package:partner_mobile/models/product_description.dart';
import 'package:partner_mobile/models/product_picture.dart';
import 'package:partner_mobile/screens/products/product_detail_screen.dart';
import 'package:partner_mobile/screens/shop/filter_screen.dart';
import 'package:partner_mobile/screens/widgets/item_card_widget.dart';
import 'package:partner_mobile/services/brand_service.dart';
import 'package:partner_mobile/services/category_service.dart';
import 'package:partner_mobile/services/product_description_service.dart';
import 'package:partner_mobile/services/product_picture_service.dart';
import 'package:partner_mobile/services/product_service.dart';

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
  List<Product> _products = [];

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _scrollController = ScrollController()..addListener(_loadMore);
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page += 1;
      try {
        final listProducts =
            await ProductService.getAllProductPagination(_page);
        if (listProducts.isEmpty) {
          setState(() {
            _hasNextPage = false;
          });
        } else {
          setState(() {
            _hasNextPage = true;
          });
          _products = listProducts;
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
      final listProducts = await ProductService.getAllProductPagination(_page);
      if (listProducts.isEmpty) {
        setState(() {
          _hasNextPage = false;
        });
      } else {
        setState(() {
          _hasNextPage = true;
        });
        _products = listProducts;
      }
    } catch (e) {
      print("Something went wrong: $e");
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
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
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _page = 1;
          });
          _firstLoad();
        },
        child: _isFirstLoadRunning
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: const EdgeInsets.all(2),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
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
      ),
    );
  }
}

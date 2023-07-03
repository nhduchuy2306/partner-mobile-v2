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
  int _page = 1;
  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  final List<Product> _products = [];
  late ScrollController _scrollController;

  // declare filter variables
  String? _search;
  List<int>? _categories;
  List<int>? _brands;
  double? _fromPrice;
  double? _toPrice;

  void _onFilter(String? search, List<int>? categories, List<int>? brands,
      double? fromPrice, double? toPrice) {
    setState(() {
      _search = search;
      _categories = categories;
      _brands = brands;
      _fromPrice = fromPrice;
      _toPrice = toPrice;
      _page = 1;
      _products.clear();
      _firstLoad();
    });
  }

  @override
  void initState() {
    super.initState();
    _search = null;
    _categories = null;
    _brands = null;
    _fromPrice = null;
    _toPrice = null;

    _firstLoad();
    _scrollController = ScrollController()..addListener(_loadMore);
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false) {
      setState(() {
        _isLoadMoreRunning = true;
        _page += 1;
      });

      try {
        final listProducts = await ProductService.getAllProductPagination(
            _page, 8, _search, _brands, _categories, _fromPrice, _toPrice);
        if (listProducts.isEmpty) {
          setState(() {
            _hasNextPage = false;
          });
        } else {
          setState(() {
            _hasNextPage = true;
          });
          _products.addAll(listProducts);
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
      final listProducts = await ProductService.getAllProductPagination(
          _page, 8, _search, _brands, _categories, _fromPrice, _toPrice);

      for (var product in listProducts) {
        print(product.productId);
      }
      if (listProducts.isEmpty) {
        setState(() {
          _hasNextPage = false;
        });
      } else {
        setState(() {
          _hasNextPage = true;
        });
        _products.addAll(listProducts);
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
        title: const Text(
          "Gadget Zone",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
              ).then((value) {
                print(value);
                if(double.tryParse(value["minPrice"]) == null) {
                  value["minPrice"] = "0";
                }
                if(double.tryParse(value["maxPrice"]) == null) {
                  value["maxPrice"] = "100000000";
                }
                _onFilter(
                    null,
                    value["categories"],
                    value["brands"],
                    double.parse(value["minPrice"]),
                    double.parse(value["maxPrice"]));
              });
              setState(() {});
            },
            icon: const Icon(Icons.filter_list, color: Colors.black),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _page = 1;
          _firstLoad();
          _products.clear();
          });
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

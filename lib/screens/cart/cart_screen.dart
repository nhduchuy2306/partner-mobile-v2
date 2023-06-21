import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:partner_mobile/models/product.dart';
import 'package:partner_mobile/models/product_description.dart';
import 'package:partner_mobile/models/product_picture.dart';
import 'package:partner_mobile/provider/cart_provider.dart';
import 'package:partner_mobile/screens/cart/checkout_bottom_sheet.dart';
import 'package:partner_mobile/screens/products/product_detail_screen.dart';
import 'package:partner_mobile/screens/widgets/shopping_cart_item.dart';
import 'package:partner_mobile/services/product_description_service.dart';
import 'package:partner_mobile/services/product_picture_service.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
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

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: .0,
          title: const Text(
            "Cart",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          controller: ScrollController(),
          physics: const BouncingScrollPhysics(),
          child: Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: cartProvider.cartItems.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.bottomToTop,
                              duration: const Duration(milliseconds: 300),
                              child: ProductDetailScreen(
                                product:
                                    cartProvider.cartItems[index].product ??
                                        Product(),
                                productDescription: getProductDescriptionById(
                                    cartProvider.cartItems[index].product
                                            ?.productId ??
                                        1),
                                productPictures: getProductPicture(cartProvider
                                        .cartItems[index].product?.productId ??
                                    1),
                              ),
                            ),
                          );
                        },
                        child: ShoppingCartItem(
                          product: cartProvider.cartItems[index].product,
                          quantity: cartProvider.cartItems[index].quantity,
                        ),
                      );
                    },
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  getCheckoutButton(context, cartProvider.totalAmount)
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget getCheckoutButton(BuildContext context, double totalAmount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: GestureDetector(
        onTap: () {
          showBottomSheet(context, totalAmount);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xff489E67),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: Text(
              "Checkout",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showBottomSheet(context, double totalAmount) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return CheckoutBottomSheet(totalAmount: totalAmount);
        });
  }
}

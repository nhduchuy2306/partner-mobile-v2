import 'package:flutter/material.dart';
import 'package:partner_mobile/models/product.dart';
import 'package:partner_mobile/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class ShoppingCartItem extends StatelessWidget {
  const ShoppingCartItem({super.key, this.product, this.quantity});

  final Product? product;
  final int? quantity;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(product?.productId.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Are you sure?"),
            content:
                const Text("Do you want to remove the item from the cart?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("No"),
              ),
              Consumer<CartProvider>(builder: (context, cartProvider, child) {
                return TextButton(
                  onPressed: () {
                    cartProvider.removeFromCart(product!.productId!);
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Yes"),
                );
              })
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Row(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: NetworkImage(product?.picture ?? ""),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product?.productName ?? "",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${product?.price?.toStringAsFixed(0)} VND",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Consumer<CartProvider>(
                          builder: (context, cartProvider, child) {
                        return GestureDetector(
                          onTap: () {
                            cartProvider
                                .decreaseCartItemQuantity(product!.productId!);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xff489E67),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        );
                      }),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          "$quantity",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Consumer<CartProvider>(
                          builder: (context, cartProvider, child) {
                        return GestureDetector(
                          onTap: () {
                            cartProvider
                                .increaseCartItemQuantity(product!.productId!);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xff489E67),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        );
                      }),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

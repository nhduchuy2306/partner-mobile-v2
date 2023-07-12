import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:partner_mobile/models/order.dart';
import 'package:partner_mobile/models/order_detail.dart';
import 'package:partner_mobile/models/product.dart';
import 'package:partner_mobile/provider/cart_provider.dart';
import 'package:partner_mobile/services/order_service.dart';
import 'package:partner_mobile/styles/app_colors.dart';
import 'package:provider/provider.dart';

class OrderHistoryScreen extends StatefulWidget {
  OrderHistoryScreen({super.key, this.userInfo});

  UserInfo? userInfo;

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late Future<List<Order>> _getAllOrders;
  late Future<List<OrderDetail>> _getAllOrderDetails;

  @override
  void initState() {
    super.initState();
    _getAllOrders =
        OrderService.getOrdersByUsername(widget.userInfo?.uid ?? "");
    _getAllOrderDetails =
        OrderService.getOrderDetailByUsername(widget.userInfo?.uid ?? "");
  }

  @override
  Widget build(BuildContext context) {
    var cartItems = context.watch<CartProvider>().cartItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _getAllOrders =
                OrderService.getOrdersByUsername(widget.userInfo?.uid ?? "");
          });
        },
        child: SingleChildScrollView(
          child: FutureBuilder<List<OrderDetail>>(
            future: _getAllOrderDetails,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: const Center(
                      child: Text("No order history"),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    double total = (snapshot.data?[index].price ?? 0) *
                        (snapshot.data?[index].quantity ?? 1);
                    return Card(
                      margin: const EdgeInsets.all(15),
                      shadowColor: Colors.grey,
                      surfaceTintColor: Colors.grey,
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.network(
                                  snapshot.data?[index].picture ?? "",
                                  width: 100,
                                  height: 100,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      snapshot.data?[index].productName ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      'x${snapshot.data?[index].quantity}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      '\$${total?.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              'Total: \$${snapshot.data?[index].price?.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.primaryColor,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Product product = Product(
                                      productId:
                                          snapshot.data?[index].productId ?? 1,
                                      productName:
                                          snapshot.data?[index].productName ??
                                              "",
                                      price: snapshot.data?[index].price ?? 0,
                                      picture:
                                          snapshot.data?[index].picture ?? "",
                                      quantity:
                                          snapshot.data?[index].quantity ?? 1);
                                  context
                                      .read<CartProvider>()
                                      .addToCart(product, 1);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Added to cart'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Order Again",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Container(
                  padding: const EdgeInsets.all(20),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ));
            },
          ),
        ),
      ),
    );
  }
}

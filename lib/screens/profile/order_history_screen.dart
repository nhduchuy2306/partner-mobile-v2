import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:partner_mobile/models/order.dart';
import 'package:partner_mobile/services/order_service.dart';

class OrderHistoryScreen extends StatefulWidget {
  OrderHistoryScreen({super.key, this.userInfo});

  UserInfo? userInfo;

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {

  late Future<List<Order>> _getAllOrders;

  @override
  void initState() {
    super.initState();
    _getAllOrders = OrderService.getOrdersByUsername(widget.userInfo?.uid ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Order>>(
            future: _getAllOrders,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(snapshot.data?[index].date ?? ""),
                        subtitle: Text(widget.userInfo?.displayName ?? ""),
                        trailing: Text("${snapshot.data?[index].total?.toStringAsFixed(0)} VND" ?? ""),
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
                  )
              );
            }
        ),
      ),
    );
  }
}

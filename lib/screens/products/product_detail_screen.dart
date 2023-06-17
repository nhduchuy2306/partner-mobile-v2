import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  int productId;

  ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: Center(
        child: Text(productId.toString() ?? 'No product id'),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() {
    return ProductsPageState();
  }
}

class ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Product Page'),);
  }
}
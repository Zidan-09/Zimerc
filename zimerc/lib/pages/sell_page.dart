import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() {
    return SellPageState();
  }
}

class SellPageState extends State<SellPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Sell Page'),);
  }
}
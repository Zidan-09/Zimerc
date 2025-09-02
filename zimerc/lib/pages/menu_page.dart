import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() {
    return MenuPageState();
  }
}

class MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Menu Page'),);
  }
}
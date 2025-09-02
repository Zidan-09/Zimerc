import 'package:flutter/material.dart';
import 'package:zimerc/pages/home_page.dart';
import 'package:zimerc/pages/menu_page.dart';
import 'package:zimerc/pages/products_page.dart';
import 'package:zimerc/pages/reports_page.dart';
import 'package:zimerc/pages/sell_page.dart';
import 'package:zimerc/widgets/navbar.dart';

//0xFF388E3C Primary Color
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  State<MyApp> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  int page = 0;

  final List<Widget> pages = const [
    HomePage(),
    ReportsPage(),
    SellPage(),
    ProductsPage(),
    MenuPage()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: pages[page],
        bottomNavigationBar: NavBar(
          currentPage: page,
          onPageChanged: (index) {
            setState(() {
              page = index;
            });
          },
        )
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'reports/reports_screen.dart';
import 'sale/sale_screen.dart';
import 'products/products_screen.dart';
import '/widgets/custom_bottom_nav.dart';

class HomeController extends StatefulWidget {
  const HomeController({super.key});

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ReportsScreen(),
    SizedBox(),
    ProductsScreen(),
    SizedBox(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SaleScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      extendBody: true,
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
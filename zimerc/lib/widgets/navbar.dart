import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int currentPage;
  final Function(int) onPageChanged;

  const NavBar({
    super.key,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.066,
      color: const Color(0xFF388E3C),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 0, right: 15, bottom: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildIcon(Icons.home, 0),
            _buildIcon(Icons.bar_chart, 1),
            _buildIcon(Icons.sell, 2),
            _buildIcon(Icons.add_box, 3),
            _buildIcon(Icons.menu, 4),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    return GestureDetector(
      onTap: () => onPageChanged(index),
      child: Icon(
        icon,
        color: currentPage == index ? Colors.yellow : Colors.white,
        size: 40,
      ),
    );
  }
}
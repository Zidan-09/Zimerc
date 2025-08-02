import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'extras_menu.dart';

class CustomBottomNav extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav>
    with SingleTickerProviderStateMixin {
  bool isExtrasOpen = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleExtras() {
    setState(() {
      isExtrasOpen = !isExtrasOpen;
      if (isExtrasOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Widget buildIcon(IconData filled, IconData outlined, bool active) {
    return Icon(
      active ? filled : outlined,
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isExtrasOpen ? 150 : 0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green[800],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: isExtrasOpen ? const ExtrasMenu() : null,
            ),
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: buildIcon(Icons.home, Icons.home_outlined, widget.selectedIndex == 0),
                    onPressed: () => widget.onItemTapped(0),
                  ),
                  IconButton(
                    icon: buildIcon(Icons.bar_chart, Icons.bar_chart_outlined, widget.selectedIndex == 1),
                    onPressed: () => widget.onItemTapped(1),
                  ),
                  const SizedBox(width: 60),
                  IconButton(
                    icon: buildIcon(Icons.inventory, Icons.inventory_2_outlined, widget.selectedIndex == 3),
                    onPressed: () => widget.onItemTapped(3),
                  ),
                  IconButton(
                    onPressed: toggleExtras,
                    icon: RotationTransition(
                      turns: Tween(begin: 0.0, end: 0.25)
                          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
                      child: Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -20,
          child: GestureDetector(
            onTap: () => widget.onItemTapped(2),
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 4),
              ),
              child: Icon(
                Icons.attach_money,
                color: AppColors.primary,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
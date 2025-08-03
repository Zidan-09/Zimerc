// lib/widgets/custom_bottom_nav.dart

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
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // fora da tela (direita)
      end: Offset.zero, // posição normal
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
      children: [
        // Painel lateral Extras com top ajustado para cobrir o vão branco
        Positioned(
          top: 0, // desce o painel 16 pixels
          right: 0,
          bottom: 45, // Altura da navbar para não cobrir
          child: SlideTransition(
            position: _offsetAnimation,
            child: Container(
              width: 172,
              color: Color.fromARGB(255, 44, 141, 48),
              child: const ExtrasMenu(),
            ),
          ),
        ),

        // Navbar fixa embaixo
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary,
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
                    turns: Tween(begin: 0.0, end: 0.25).animate(
                      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
                    ),
                    child: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Botão Venda destacado
        Positioned(
          bottom: 4,
          left: MediaQuery.of(context).size.width / 2 - 30,
          child: GestureDetector(
            onTap: () => widget.onItemTapped(2),
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(38),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
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
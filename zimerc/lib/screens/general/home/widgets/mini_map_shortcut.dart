import 'package:flutter/material.dart';

class MiniMapShortcut extends StatelessWidget {
  const MiniMapShortcut({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Atalho do mapa clicado!')),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/mini_map.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
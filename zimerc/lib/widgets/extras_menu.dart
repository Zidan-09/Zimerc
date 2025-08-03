import 'package:flutter/material.dart';

class ExtrasMenu extends StatelessWidget {
  const ExtrasMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: const [
                      Icon(Icons.settings, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Configurações',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: const [
                      Icon(Icons.account_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Conta',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Sobre',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
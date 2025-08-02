import 'package:flutter/material.dart';

class SaleScreen extends StatelessWidget {
  const SaleScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('💲 Realizar Venda')),
      body: const Center(child: Text('Tela de Venda')),
    );
  }
}
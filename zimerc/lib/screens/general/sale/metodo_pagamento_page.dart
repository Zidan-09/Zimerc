import 'package:flutter/material.dart';
import 'confirmar_pagamento_page.dart'; // ajuste o caminho
import 'produto.dart'; // mesmo Produto dos outros arquivos

class MetodoPagamentoPage extends StatelessWidget {
  final List<Produto> itensSelecionados;

  const MetodoPagamentoPage({super.key, required this.itensSelecionados});

  final List<Map<String, dynamic>> metodos = const [
    {'nome': 'Dinheiro', 'icone': Icons.money},
    {'nome': 'Cartão de Crédito', 'icone': Icons.credit_card},
    {'nome': 'Pix', 'icone': Icons.qr_code},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Método de Pagamento')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: metodos.map((metodo) {
          return Card(
            child: ListTile(
              leading: Icon(metodo['icone']),
              title: Text(metodo['nome']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConfirmarPagamentoPage(
                      itensSelecionados: itensSelecionados,
                      metodoPagamento: metodo['nome'],
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
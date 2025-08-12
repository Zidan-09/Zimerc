import 'package:flutter/material.dart';
import 'produto.dart'; // caso queira, senão defina Produto igual no selecionar_produtos_page.dart
import 'metodo_pagamento_page.dart'; // ajuste o caminho

class ConfirmarItensPage extends StatelessWidget {
  final List<Produto> itensSelecionados;

  const ConfirmarItensPage({super.key, required this.itensSelecionados});

  double get total => itensSelecionados.fold(0, (sum, item) => sum + item.valor);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar Itens')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: itensSelecionados.length,
              itemBuilder: (context, index) {
                final item = itensSelecionados[index];
                return ListTile(
                  title: Text(item.nome),
                  trailing: Text('R\$ ${item.valor.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Total: R\$ ${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MetodoPagamentoPage(itensSelecionados: itensSelecionados),
                ),
              );
            },
            child: const Text('Selecionar Método de Pagamento'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SaleScreen extends StatefulWidget {
  @override
  _SelectProductsForSaleScreenState createState() =>
      _SelectProductsForSaleScreenState();
}

class _SelectProductsForSaleScreenState
    extends State<SaleScreen> {
  // Simulação da lista de produtos
  List<Map<String, dynamic>> produtos = [
    {'product_id': 1, 'name': 'Produto A', 'price': 12.50},
    {'product_id': 2, 'name': 'Produto B', 'price': 7.30},
    {'product_id': 3, 'name': 'Produto C', 'price': 15.99},
    {'product_id': 4, 'name': 'Produto D', 'price': 3.45},
  ];

  // Quantidade selecionada por produto_id
  Map<int, int> quantities = {};

  final currencyFormatter =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void initState() {
    super.initState();
    // Inicializa quantidades em 0
    for (var produto in produtos) {
      quantities[produto['product_id']] = 0;
    }
  }

  int get totalSelectedItems =>
      quantities.values.fold(0, (previous, current) => previous + current);

  void _incrementQuantity(int productId) {
    setState(() {
      quantities[productId] = (quantities[productId] ?? 0) + 1;
    });
  }

  void _decrementQuantity(int productId) {
    setState(() {
      int current = quantities[productId] ?? 0;
      if (current > 0) {
        quantities[productId] = current - 1;
      }
    });
  }

  void _onCancel() {
    // Voltar para a tela inicial, por exemplo:
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _onNext() {
    // Passar para próxima tela com os itens selecionados
    final selectedProducts = produtos
        .where((p) => (quantities[p['product_id']] ?? 0) > 0)
        .map((p) => {
              'product': p,
              'quantity': quantities[p['product_id']],
            })
        .toList();

    // Exemplo: navegar e passar esses dados
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ConfirmSaleScreen(selectedProducts: selectedProducts),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // fundo cinza
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              // Retângulo cinza grande
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      const Text(
                        'Selecione os Produtos',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Retângulo branco com sombra contendo a lista
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: ListView.builder(
                            itemCount: produtos.length,
                            itemBuilder: (context, index) {
                              final produto = produtos[index];
                              final productId = produto['product_id'] as int;
                              final quantity = quantities[productId] ?? 0;
                              final price = produto['price'] as double;

                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Nome e preço
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            produto['name'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            currencyFormatter.format(price),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Controles adicionar/remover quantidade
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: quantity > 0
                                                ? () =>
                                                    _decrementQuantity(productId)
                                                : null,
                                            icon: const Icon(Icons.remove),
                                            color: quantity > 0
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                          Text(
                                            quantity.toString(),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                _incrementQuantity(productId),
                                            icon: const Icon(Icons.add),
                                            color: Colors.green,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Botões Cancelar e Próximo
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _onCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          totalSelectedItems > 0 ? _onNext : null, // desativa
                      style: ElevatedButton.styleFrom(
                        backgroundColor: totalSelectedItems > 0
                            ? const Color(0xFF007B00) // AppColor.primary verde
                            : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Próximo',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tela de confirmação (apenas stub)
class ConfirmSaleScreen extends StatelessWidget {
  final List<Map<String, dynamic>> selectedProducts;

  const ConfirmSaleScreen({required this.selectedProducts, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Por enquanto só mostra os produtos selecionados
    return Scaffold(
      appBar: AppBar(title: const Text('Confirme os itens')),
      body: ListView.builder(
        itemCount: selectedProducts.length,
        itemBuilder: (context, index) {
          final entry = selectedProducts[index];
          final product = entry['product'];
          final quantity = entry['quantity'] as int;
          final price = product['price'] as double;
          final currencyFormatter =
              NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
          return ListTile(
            title: Text(product['name']),
            subtitle: Text('Quantidade: $quantity'),
            trailing:
                Text(currencyFormatter.format(price * quantity.toDouble())),
          );
        },
      ),
    );
  }
}
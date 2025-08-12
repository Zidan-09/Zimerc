import 'package:flutter/material.dart';
import '../../../services/sale_service.dart'; // ajuste o caminho
import 'produto.dart';

class ConfirmarPagamentoPage extends StatelessWidget {
  final List<Produto> itensSelecionados;
  final String metodoPagamento;

  const ConfirmarPagamentoPage({
    super.key,
    required this.itensSelecionados,
    required this.metodoPagamento,
  });

  double get total => itensSelecionados.fold(0, (sum, item) => sum + item.valor);

  Future<void> inserirVenda() async {
    final sale = {
      'sale_date': DateTime.now().toIso8601String(),
      'payment_method': metodoPagamento,
      'total_amount': total,
      'company_id': null, // ajuste conforme necessário
      'user_id': null,    // ajuste conforme necessário
      'latitude': null,
      'longitude': null,
      'is_synced': 0,
    };

    final produtosParaInserir = itensSelecionados.map((produto) => {
      'product_id': produto.productId,
      'quantity': 1,
      'unit_price': produto.valor,
    }).toList();

    final saleService = SaleService();
    final idVenda = await saleService.addSaleWithProducts(
      sale: sale,
      produtos: produtosParaInserir,
    );

    debugPrint('Venda inserida com ID $idVenda');
  }

  void _finalizarVenda(BuildContext context) async {
    await inserirVenda();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Venda realizada com sucesso!')),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar Pagamento')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total a pagar: R\$ ${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text('Método: $metodoPagamento', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => _finalizarVenda(context),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Text('Confirmar Venda'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
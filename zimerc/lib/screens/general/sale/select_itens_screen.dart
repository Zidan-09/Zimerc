import 'package:flutter/material.dart';
import '../../../services/product_service.dart'; // ajuste o caminho
import 'confirm_itens_screen.dart'; // ajuste o caminho
import 'produto.dart';

class SelecionarProdutosPage extends StatefulWidget {
  const SelecionarProdutosPage({super.key});

  @override
  State<SelecionarProdutosPage> createState() => _SelecionarProdutosPageState();
}

class _SelecionarProdutosPageState extends State<SelecionarProdutosPage> {
  final ProductService _productService = ProductService();

  List<Produto> _produtos = [];
  Set<Produto> _selecionados = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    final listaMap = await _productService.getAllProducts();
    setState(() {
      _produtos = listaMap.map((map) => Produto.fromMap(map)).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_produtos.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Nenhum produto cadastrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Selecionar Produtos')),
      body: ListView(
        children: _produtos.map((produto) {
          final estaSelecionado = _selecionados.contains(produto);
          return CheckboxListTile(
            title: Text(produto.nome),
            subtitle: Text('R\$ ${produto.valor.toStringAsFixed(2)}'),
            value: estaSelecionado,
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  _selecionados.add(produto);
                } else {
                  _selecionados.remove(produto);
                }
              });
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Próximo'),
        icon: const Icon(Icons.arrow_forward),
        onPressed: _selecionados.isEmpty
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConfirmarItensPage(
                      itensSelecionados: _selecionados.toList(),
                    ),
                  ),
                );
              },
      ),
    );
  }
}
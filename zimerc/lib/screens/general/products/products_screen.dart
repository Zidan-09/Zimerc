// lib/screens/general/products/products_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/product_service.dart';
import '../../../services/session.dart';
import 'widgets/products_cards.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> produtos = [];
  bool _loading = true;

  late final AnimationController _controller;
  final currencyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  final ProductService _productService = ProductService();
  final Session _session = Session();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    // Carrega sessão (se ainda não carregada) e produtos
    _init();
  }

  Future<void> _init() async {
    await _session.loadFromPrefs();
    await _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _loading = true;
    });

    final prods = await _productService.getAllProducts();

    setState(() {
      produtos = prods;
      _loading = false;
    });

    // iniciar animação depois de popular produtos
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildAnimatedItem(BuildContext context, int index) {
    final produto = produtos[index];

    // segurança caso lista mude
    if (produtos.isEmpty) return const SizedBox.shrink();

    final animationIntervalStart = index / produtos.length;
    final animationIntervalEnd = (index + 1) / produtos.length;

    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(animationIntervalStart, animationIntervalEnd, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(animation),
        child: ProductCard(
          nome: produto['name'] ?? '',
          preco: produto['unit_price'] != null ? (produto['unit_price'] as num).toDouble() : 0.0,
          currencyFormatter: currencyFormatter,
        ),
      ),
    );
  }

  bool get _isEmployee => _session.isEmployee;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35, left: 16, right: 16, bottom: 70),
      child: Column(
        children: [
          // Retângulo externo cinza (quase a tela inteira)
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título dentro do retângulo cinza
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: const Text(
                      'Seus Produtos Cadastrados',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Retângulo interno branco com sombra, contendo a lista de cards
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: _loading
                          ? const Center(child: CircularProgressIndicator())
                          : produtos.isEmpty
                              ? Center(
                                  child: Text(
                                    'Nenhum produto cadastrado.',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: produtos.length,
                                  itemBuilder: buildAnimatedItem,
                                ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Linha de botões: Adicionar, Editar, Deletar
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isEmployee ? null : () {
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Adicionar',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.disabled)) return Colors.grey.shade400;
                      return Colors.green;
                    }),
                    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 14)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isEmployee ? null : () {
             
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text('Editar',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.disabled)) return Colors.grey.shade400;
                      return Colors.amber[700];
                    }),
                    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 14)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isEmployee ? null : () {
                  },
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text('Deletar',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.disabled)) return Colors.grey.shade400;
                      return Colors.red;
                    }),
                    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 14)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
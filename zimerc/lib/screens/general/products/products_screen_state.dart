part of products_screen;

class _ProductsScreenState extends State<ProductsScreen> with TickerProviderStateMixin {
  List<Map<String, dynamic>> produtos = [];
  bool _loading = true;

  late final AnimationController _appearController;
  final currencyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  final ProductService _productService = ProductService();
  final Session _session = Session();

  bool selectionMode = false;
  final Set<int> selectedIds = {};

  final Map<int, AnimationController> _removeControllers = {};

  double _bottomConfirmBarHeight = 0.0;

  @override
  void initState() {
    super.initState();

    _appearController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

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
      selectedIds.clear();
      selectionMode = false;
      _bottomConfirmBarHeight = 0.0;
    });

    _appearController.forward(from: 0);
  }

  @override
  void dispose() {
    _appearController.dispose();
    for (final c in _removeControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Widget buildAnimatedItem(BuildContext context, int index) => buildAnimatedItemImpl(this, context, index);

  void _onCardTap(int productId) {
    if (!selectionMode) {
      return;
    }

    setState(() {
      selectedIds.add(productId);
      _animateConfirmBar(show: true);
    });

    final produto = produtos.firstWhere(
      (p) => (p['product_id'] as int) == productId,
      orElse: () => <String, dynamic>{});
    final nome = produto['name'] ?? 'Produto';

    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: Text('Deseja excluir "$nome"? Esta ação não pode ser desfeita.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    ).then((confirmed) async {
      if (confirmed == true) {
        await Future.delayed(const Duration(milliseconds: 250));
        await _animateAndDeleteSingle(productId);
      } else {
        if (mounted) {
          setState(() {
            selectedIds.remove(productId);
            if (selectedIds.isEmpty) _animateConfirmBar(show: false);
          });
        }
      }
    });
  }

  Future<void> _animateAndDeleteSingle(int productId) async {
    // proteção
    final exists = produtos.any((p) => (p['product_id'] as int) == productId);
    if (!exists) return;

    final ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
    _removeControllers[productId] = ctrl;

    setState(() {
      selectedIds.add(productId);
      _animateConfirmBar(show: selectedIds.isNotEmpty);
    });

    // iniciar animação
    await ctrl.forward();

    try {
      await _productService.deleteProduct(productId);
    } catch (e) {
      debugPrint('Erro deletando $productId: $e');
      setState(() {
        selectedIds.remove(productId);
        final c = _removeControllers.remove(productId);
        c?.dispose();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao deletar item: $e')),
        );
      }
      return;
    }

    setState(() {
      produtos.removeWhere((p) => (p['product_id'] as int) == productId);
      selectedIds.remove(productId);
      final c = _removeControllers.remove(productId);
      c?.dispose();
      if (selectedIds.isEmpty) _animateConfirmBar(show: false);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto excluído')),
      );
    }
  }

  void _toggleDeleteMode() {
    setState(() {
      if (selectionMode) {
        selectionMode = false;
        selectedIds.clear();
        _animateConfirmBar(show: false);
      } else {
        selectionMode = true;
        selectedIds.clear();
        _animateConfirmBar(show: false);
      }
    });
  }

  void _animateConfirmBar({required bool show}) {
    setState(() {
      _bottomConfirmBarHeight = show ? 72.0 : 0.0;
    });
  }

  bool get _isEmployee => _session.isEmployee;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35, left: 16, right: 16, bottom: 70),
      child: Column(
        children: [
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

                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 12 + _bottomConfirmBarHeight),
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

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isEmployee
                      ? null
                      : () async {
                          // abrir modal inserir
                          final bool? added = await showModalBottomSheet<bool>(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            builder: (context) => const AddProductForm(),
                          );
                          if (added == true) await _loadProducts();
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
                  onPressed: _isEmployee
                      ? null
                      : () {
                          // editar: por enquanto sem implementação
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
                  onPressed: _isEmployee
                      ? null
                      : () {
                          _toggleDeleteMode();
                        },
                  icon: Icon(selectionMode ? Icons.close : Icons.delete, color: Colors.white),
                  label: Text(selectionMode ? 'Cancelar' : 'Deletar',
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
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

          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: selectedIds.isNotEmpty ? 0.0 : 0.0,
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(top: 8),
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
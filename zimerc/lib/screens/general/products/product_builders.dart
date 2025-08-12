part of 'products_screen.dart';

Widget buildAnimatedItemImpl(_ProductsScreenState state, BuildContext context, int index) {
  final produtos = state.produtos;
  final _appearController = state._appearController;
  final _removeControllers = state._removeControllers;
  final currencyFormatter = state.currencyFormatter;
  final selectedIds = state.selectedIds;

  if (produtos.isEmpty) return const SizedBox.shrink();
  final produto = produtos[index];
  final productId = produto['product_id'] as int;

  final animationIntervalStart = index / produtos.length;
  final animationIntervalEnd = (index + 1) / produtos.length;

  final animation = CurvedAnimation(
    parent: _appearController,
    curve: Interval(animationIntervalStart, animationIntervalEnd, curve: Curves.easeOut),
  );

  if (_removeControllers.containsKey(productId)) {
    final remCtrl = _removeControllers[productId]!;
    final slideAnim = Tween<Offset>(begin: Offset.zero, end: const Offset(1.2, 0)).animate(
      CurvedAnimation(parent: remCtrl, curve: Curves.easeIn),
    );
    final fadeAnim = Tween<double>(begin: 1.0, end: 0.0).animate(remCtrl);

    return FadeTransition(
      opacity: fadeAnim,
      child: SlideTransition(
        position: slideAnim,
        child: SizedBox(
          child: ProductCard(
            nome: produto['name'] ?? '',
            preco: produto['unit_price'] != null ? (produto['unit_price'] as num).toDouble() : 0.0,
            currencyFormatter: currencyFormatter,
            selected: selectedIds.contains(productId),
            onTap: () => state._onCardTap(productId),
          ),
        ),
      ),
    );
  }

  return FadeTransition(
    opacity: animation,
    child: SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(animation),
      child: ProductCard(
        nome: produto['name'] ?? '',
        preco: produto['unit_price'] != null ? (produto['unit_price'] as num).toDouble() : 0.0,
        currencyFormatter: currencyFormatter,
        selected: selectedIds.contains(productId),
        onTap: () => state._onCardTap(productId),
      ),
    ),
  );
}
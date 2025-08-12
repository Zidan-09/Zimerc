import 'package:flutter/foundation.dart';

class CartItem {
  final int productId;
  final String name;
  final double unitPrice;
  int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.unitPrice,
    this.quantity = 1,
  });

  double get totalPrice => unitPrice * quantity;
}

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => _items;

  List<CartItem> get itemList => _items.values.toList();

  double get totalValue {
    double total = 0;
    for (var item in _items.values) {
      total += item.totalPrice;
    }
    return total;
  }

  void addItem({
    required int productId,
    required String name,
    required double unitPrice,
  }) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity++;
    } else {
      _items[productId] = CartItem(
        productId: productId,
        name: name,
        unitPrice: unitPrice,
      );
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void decrementItem(int productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity--;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
// cart_manager.dart
import 'package:flutter/material.dart';

class CartItem {
  String name;
  double price;
  int qty;
  String image;

  CartItem(this.name, this.price, this.qty, this.image);

  double get total => price * qty;
}

class CartManager extends ChangeNotifier {
  final List<CartItem> _items = [
    CartItem("BBQ Pizza", 25.0, 2, "assets/images/BBQ p.png"),
    CartItem("BBQ Burger", 20.0, 2, "assets/images/BBQ b.png"),
    CartItem("Cacio e Pepe", 16.0, 2, "assets/images/pepe.png"),
  ];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(CartItem newItem) {
    bool found = false;
    for (var item in _items) {
      if (item.name == newItem.name) {
        item.qty += newItem.qty;
        found = true;
        break;
      }
    }

    if (!found) {
      _items.add(newItem);
    }
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void updateQuantity(int index, int newQty) {
    if (index >= 0 && index < _items.length && newQty > 0) {
      _items[index].qty = newQty;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get itemsPrice => _items.fold(0, (sum, item) => sum + item.total);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.qty);
  int get uniqueItemCount => _items.length;
}

// Global instance
final CartManager myCart = CartManager();

// ... existing CartManager class ...

// ADD THIS AT THE BOTTOM OF cart_manager.dart:

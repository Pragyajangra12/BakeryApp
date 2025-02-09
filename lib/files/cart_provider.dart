import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => List.unmodifiable(_cartItems);

  double get totalPrice {
    double subtotal = _cartItems.fold(0.0, (sum, item) {
      return sum + (item['price'] * item['quantity']);
    });
    return subtotal + 10000; // Fixed delivery fee
  }

  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item['quantity'] as int).toInt();

  void addToCart({required String label, required double price, required String imagePath, int quantity = 1}) {
    if (label.isEmpty || price <= 0 || imagePath.isEmpty) return;

    int index = _cartItems.indexWhere((item) => item['label'] == label);
    if (index != -1) {
      _cartItems[index]['quantity'] += quantity;
    } else {
      _cartItems.add({
        'label': label,
        'price': price,
        'imagePath': imagePath,
        'quantity': quantity,
      });
    }
    notifyListeners();
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  void incrementQuantity(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems[index]['quantity']++;
      notifyListeners();
    }
  }

  void decrementQuantity(int index) {
    if (index >= 0 && index < _cartItems.length) {
      if (_cartItems[index]['quantity'] > 1) {
        _cartItems[index]['quantity']--;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}

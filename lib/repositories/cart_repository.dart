import 'package:southsea_cinema/models/cart_item.dart';

class CartRepository {
  CartRepository._internal();

  static final CartRepository instance = CartRepository._internal();
  final List<CartItem> _cartItems = [];

  List<CartItem> getItems() {
    return List<CartItem>.unmodifiable(_cartItems);
  }

  void addItem(CartItem item) {
    _cartItems.add(item);
  }

  void removeItem(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
    }
  }

  void clear() {
    _cartItems.clear();
  }

  int getTotalItems() {
    int total = 0;
    for (final CartItem item in _cartItems) {
      total += item.quantity;
    }
    return total;
  }

  int get totalItemCount {
    return getTotalItems();
  }

  double getTotalPrice() {
    double total = 0.0;
    for (final CartItem item in _cartItems) {
      total += item.itemTotal;
    }
    return total;
  }

  double getDeliveryFee() {
    if (_cartItems.isEmpty) {
      return 0.0;
    }
    return 1.50;
  }

  double getTotalDue() {
    return getTotalPrice() + getDeliveryFee();
  }
}

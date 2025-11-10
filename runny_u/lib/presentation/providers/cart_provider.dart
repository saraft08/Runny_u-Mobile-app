// lib/presentation/providers/cart_provider.dart

import 'package:flutter/material.dart';
import '../../data/models/cart_model.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/menu_item_model.dart';
import '../../data/repositories/cart_repository.dart';

class CartProvider with ChangeNotifier {
  final CartRepository _repository = CartRepository();

  final List<CartItemModel> _items = [];
  CartModel? _savedCart;
  bool _isLoading = false;
  String? _error;

  List<CartItemModel> get items => _items;
  CartModel? get savedCart => _savedCart;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get total => _items.fold(0.0, (sum, item) => sum + item.subtotal);

  void addItem(MenuItemModel menuItem) {
    final existingIndex = _items.indexWhere(
      (item) => item.productId == menuItem.id,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItemModel(
        productId: menuItem.id,
        name: menuItem.name,
        price: menuItem.price,
        image: menuItem.image,
        quantity: 1,
      ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _savedCart = null;
    notifyListeners();
  }

  Future<bool> saveCart(String userId) async {
    if (_items.isEmpty) {
      _error = 'El carrito está vacío';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final cart = CartModel(
        cartItems: _items,
        total: total,
        userId: userId,
      );

      if (_savedCart != null) {
        _savedCart = await _repository.updateCart(_savedCart!.id!, cart);
      } else {
        _savedCart = await _repository.createCart(cart);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> payCart() async {
    if (_savedCart == null) {
      _error = 'Debes guardar el carrito primero';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.payCart(_savedCart!.id!);
      clearCart();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
// lib/data/models/cart_model.dart

import 'cart_item_model.dart';

class CartModel {
  final String? id;
  final List<CartItemModel> cartItems;
  final double total;
  final DateTime? creationDate;
  final String? userId;

  CartModel({
    this.id,
    required this.cartItems,
    required this.total,
    this.creationDate,
    this.userId,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as String?,
      cartItems: (json['cartItems'] as List)
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
      creationDate: json['creationDate'] != null
          ? DateTime.parse(json['creationDate'] as String)
          : null,
      userId: json['user']?['id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'cartItems': cartItems.map((item) => item.toJson()).toList(),
      'total': total,
      if (creationDate != null)
        'creationDate': creationDate!.toIso8601String(),
      if (userId != null) 'user': {'id': userId},
    };
  }

  double calculateTotal() {
    return cartItems.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  CartModel copyWith({
    String? id,
    List<CartItemModel>? cartItems,
    double? total,
    DateTime? creationDate,
    String? userId,
  }) {
    return CartModel(
      id: id ?? this.id,
      cartItems: cartItems ?? this.cartItems,
      total: total ?? this.total,
      creationDate: creationDate ?? this.creationDate,
      userId: userId ?? this.userId,
    );
  }
}
// lib/data/models/cart_item_model.dart

class CartItemModel {
  final String productId;
  final String name;
  final double price;
  final String image;
  int quantity;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }

  double get subtotal => price * quantity;

  CartItemModel copyWith({
    String? productId,
    String? name,
    double? price,
    String? image,
    int? quantity,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
    );
  }
}
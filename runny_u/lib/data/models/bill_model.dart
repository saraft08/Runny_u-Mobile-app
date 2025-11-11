class BillItemModel {
  final String name;
  final String image;
  final double price;
  final int quantity;
  final String productId;

  BillItemModel({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.productId,
  });

  factory BillItemModel.fromJson(Map<String, dynamic> json) {
    return BillItemModel(
      name: json['name'] as String? ?? 'Sin nombre',
      image: json['image'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 0,
      productId: json['productId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'productId': productId,
    };
  }
}

class BillModel {
  final int numberBill;
  final List<BillItemModel> items;
  final double total;

  BillModel({
    required this.numberBill,
    required this.items,
    required this.total,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      numberBill: json['numberBill'] as int? ?? 0,
      items: (json['items'] as List?)
              ?.map((item) => BillItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numberBill': numberBill,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
    };
  }
}
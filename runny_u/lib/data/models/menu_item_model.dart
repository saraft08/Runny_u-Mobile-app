// lib/data/models/menu_item_model.dart

class MenuItemModel {
  final String id;
  final String name;
  final double price;
  final String image;
  final String description;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Sin nombre',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] as String? ?? '',
      description: json['description'] as String? ?? 'Sin descripción',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'description': description,
    };
  }
}

class CategoryModel {
  final String category;
  final List<MenuItemModel> items;

  CategoryModel({
    required this.category,
    required this.items,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      category: json['category'] as String? ?? 'Sin categoría',
      items: (json['items'] as List?)
              ?.map((item) => MenuItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
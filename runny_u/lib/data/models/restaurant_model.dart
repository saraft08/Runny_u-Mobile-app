// lib/data/models/restaurant_model.dart

import 'menu_item_model.dart';

class RestaurantModel {
  final String id;
  final String name;
  final String schedule;
  final String location;
  final String image;
  final String description;
  final List<CategoryModel> menu;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.schedule,
    required this.location,
    required this.image,
    required this.description,
    required this.menu,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Sin nombre',
      schedule: json['schedule'] as String? ?? 'Horario no disponible',
      location: json['location'] as String? ?? 'Ubicación no disponible',
      image: json['image'] as String? ?? '',
      description: json['description'] as String? ?? 'Sin descripción',
      menu: (json['menu'] as List?)
              ?.map((cat) => CategoryModel.fromJson(cat as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'schedule': schedule,
      'location': location,
      'image': image,
      'description': description,
      'menu': menu.map((cat) => cat.toJson()).toList(),
    };
  }
}
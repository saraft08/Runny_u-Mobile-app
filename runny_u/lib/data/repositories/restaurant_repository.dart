// lib/data/repositories/restaurant_repository.dart

import '../../core/constants/api_constants.dart';
import '../models/restaurant_model.dart';
import '../services/api_service.dart';

class RestaurantRepository {
  final ApiService _apiService = ApiService();

  Future<List<RestaurantModel>> getAllRestaurants() async {
    final response = await _apiService.get(ApiConstants.restaurants);
    final List<dynamic> data = response as List<dynamic>;
    return data
        .map((json) => RestaurantModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<RestaurantModel> getRestaurantById(String id) async {
    final response = await _apiService.get('${ApiConstants.restaurants}/$id');
    return RestaurantModel.fromJson(response as Map<String, dynamic>);
  }
}
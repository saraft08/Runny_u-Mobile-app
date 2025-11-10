// lib/data/repositories/user_repository.dart

import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService _apiService = ApiService();

  Future<UserModel> getUserById(String userId) async {
    final response = await _apiService.get(
      '${ApiConstants.user}/$userId',
      requiresAuth: true,
    );
    return UserModel.fromJson(response as Map<String, dynamic>);
  }

  Future<UserModel> updateUser(
    String userId,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiService.patch(
      '${ApiConstants.user}/$userId',
      data,
      requiresAuth: true,
    );
    return UserModel.fromJson(response as Map<String, dynamic>);
  }
}
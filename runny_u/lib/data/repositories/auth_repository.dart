import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/jwt_utils.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _apiService.post(
      ApiConstants.login,
      {
        'email': email,
        'password': password,
      },
    );

    if (response['success'] == true && response['token'] != null) {
      await _saveToken(response['token'] as String);
      final user = JwtUtils.getUserFromToken(response['token'] as String);
      return {
        'success': true,
        'user': user,
        'token': response['token'],
      };
    }

    throw Exception('Credenciales inválidas');
  }

  Future<Map<String, dynamic>> signUp(
    String email,
    String password,
    String fullname,
  ) async {
    final response = await _apiService.post(
      ApiConstants.signUp,
      {
        'email': email,
        'password': password,
        'fullname': fullname,
      },
    );

    if (response['success'] == true && response['token'] != null) {
      await _saveToken(response['token'] as String);
      final user = JwtUtils.getUserFromToken(response['token'] as String);
      return {
        'success': true,
        'user': user,
        'token': response['token'],
      };
    }

    throw Exception('Error al crear cuenta');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConstants.tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ApiConstants.tokenKey);
  }

  Future<UserModel?> getCurrentUser() async {
    final token = await getToken();
    if (token == null) return null;
    return JwtUtils.getUserFromToken(token);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null) return false;
    return !JwtUtils.isTokenExpired(token);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiConstants.tokenKey);
  }
}
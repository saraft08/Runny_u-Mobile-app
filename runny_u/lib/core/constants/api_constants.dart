// lib/core/constants/api_constants.dart

class ApiConstants {
  // IMPORTANTE: Cambia esto a la IP de tu computadora cuando pruebes en dispositivos físicos
  // Ejemplo: 'http://192.168.1.100:3000/api'
  static const String baseUrl = 'http://192.168.1.55:3000/api';
  
  // Auth endpoints
  static const String login = '/v1/auth/login';
  static const String signUp = '/v1/auth/sign-up';
  
  // User endpoints
  static const String user = '/v1/user';
  
  // Restaurant endpoints
  static const String restaurants = '/v1/restaurants';
  
  // Cart endpoints
  static const String cart = '/v1/cart';
  static const String cartCreate = '/v1/cart/create';
  static const String cartByUser = '/v1/cart/user';
  static const String cartPay = '/v1/cart/pay';
  
  // Bill endpoints
  static const String billByUser = '/v1/bill/user';
  
  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}

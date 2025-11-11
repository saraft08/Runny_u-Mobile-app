class ApiConstants {
  static const String baseUrl = 'http://ip_pc:3000/api';
  
  static const String login = '/v1/auth/login';
  static const String signUp = '/v1/auth/sign-up';
  
  static const String user = '/v1/user';
  
  static const String restaurants = '/v1/restaurants';
  
  static const String cart = '/v1/cart';
  static const String cartCreate = '/v1/cart/create';
  static const String cartByUser = '/v1/cart/user';
  static const String cartPay = '/v1/cart/pay';
  
  static const String billByUser = '/v1/bill/user';
  
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}

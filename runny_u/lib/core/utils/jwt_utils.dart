import 'package:jwt_decoder/jwt_decoder.dart';
import '../../data/models/user_model.dart';

class JwtUtils {
  static UserModel? getUserFromToken(String token) {
    try {
      if (JwtDecoder.isExpired(token)) {
        return null;
      }

      final decodedToken = JwtDecoder.decode(token);
      return UserModel.fromJson(decodedToken);
    } catch (e) {
      return null;
    }
  }

  static bool isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true;
    }
  }

  static DateTime? getExpirationDate(String token) {
    try {
      return JwtDecoder.getExpirationDate(token);
    } catch (e) {
      return null;
    }
  }
}
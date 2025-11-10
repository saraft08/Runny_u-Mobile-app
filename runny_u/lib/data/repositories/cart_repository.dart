// lib/data/repositories/cart_repository.dart

import '../../core/constants/api_constants.dart';
import '../models/cart_model.dart';
import '../models/bill_model.dart';
import '../services/api_service.dart';

class CartRepository {
  final ApiService _apiService = ApiService();

  Future<CartModel> createCart(CartModel cart) async {
    final response = await _apiService.post(
      ApiConstants.cartCreate,
      cart.toJson(),
      requiresAuth: true,
    );
    return CartModel.fromJson(response as Map<String, dynamic>);
  }

  Future<List<CartModel>> getUserCarts(String userId) async {
    final response = await _apiService.get(
      '${ApiConstants.cartByUser}/$userId',
      requiresAuth: true,
    );
    final List<dynamic> data = response as List<dynamic>;
    return data
        .map((json) => CartModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<CartModel> getCartById(String cartId) async {
    final response = await _apiService.get(
      '${ApiConstants.cart}/$cartId',
      requiresAuth: true,
    );
    return CartModel.fromJson(response as Map<String, dynamic>);
  }

  Future<CartModel> updateCart(String cartId, CartModel cart) async {
    final response = await _apiService.patch(
      '${ApiConstants.cart}/$cartId',
      {'cartItem': cart.cartItems.map((item) => item.toJson()).toList()},
      requiresAuth: true,
    );
    return CartModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deleteCart(String cartId) async {
    await _apiService.delete(
      '${ApiConstants.cart}/$cartId',
      requiresAuth: true,
    );
  }

  Future<BillModel> payCart(String cartId) async {
    final response = await _apiService.post(
      '${ApiConstants.cartPay}/$cartId',
      {},
      requiresAuth: true,
    );
    return BillModel.fromJson(response as Map<String, dynamic>);
  }
}
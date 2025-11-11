import '../../core/constants/api_constants.dart';
import '../models/bill_model.dart';
import '../services/api_service.dart';

class BillRepository {
  final ApiService _apiService = ApiService();

  Future<List<BillModel>> getUserBills(String userId) async {
    final response = await _apiService.get(
      '${ApiConstants.billByUser}/$userId',
      requiresAuth: true,
    );
    final List<dynamic> data = response as List<dynamic>;
    return data
        .map((json) => BillModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
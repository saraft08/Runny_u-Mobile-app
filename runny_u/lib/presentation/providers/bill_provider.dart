// lib/presentation/providers/bill_provider.dart

import 'package:flutter/material.dart';
import '../../data/models/bill_model.dart';
import '../../data/repositories/bill_repository.dart';

class BillProvider with ChangeNotifier {
  final BillRepository _repository = BillRepository();

  List<BillModel> _bills = [];
  bool _isLoading = false;
  String? _error;

  List<BillModel> get bills => _bills;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUserBills(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _bills = await _repository.getUserBills(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
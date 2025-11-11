import 'package:flutter/material.dart';
import '../../data/models/restaurant_model.dart';
import '../../data/repositories/restaurant_repository.dart';

class RestaurantProvider with ChangeNotifier {
  final RestaurantRepository _repository = RestaurantRepository();

  List<RestaurantModel> _restaurants = [];
  RestaurantModel? _selectedRestaurant;
  bool _isLoading = false;
  String? _error;

  List<RestaurantModel> get restaurants => _restaurants;
  RestaurantModel? get selectedRestaurant => _selectedRestaurant;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadRestaurants() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _restaurants = await _repository.getAllRestaurants();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRestaurantDetails(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedRestaurant = await _repository.getRestaurantById(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSelectedRestaurant() {
    _selectedRestaurant = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
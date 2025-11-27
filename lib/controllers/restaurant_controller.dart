import 'package:flutter/material.dart';
import 'package:responsi/models/restaurant.dart';
import 'package:responsi/models/restaurant_detail.dart';
import 'package:responsi/services/api_service.dart';

class RestaurantController with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Restaurant> _restaurants = [];
  List<Restaurant> _filteredRestaurants = [];
  RestaurantDetail? _restaurantDetail;
  bool _isLoading = false;
  String _errorMessage = '';
  String _currentFilter = '';

  List<Restaurant> get restaurants => _filteredRestaurants.isEmpty && _currentFilter.isEmpty
      ? _restaurants
      : _filteredRestaurants;
  RestaurantDetail? get restaurantDetail => _restaurantDetail;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchRestaurants() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _restaurants = await _apiService.getRestaurants();
      _filteredRestaurants = [];
      _currentFilter = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRestaurantDetail(String id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _restaurantDetail = await _apiService.getRestaurantDetail(id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> filterByCategory(String category) async {
    if (category.isEmpty) {
      _filteredRestaurants = [];
      _currentFilter = '';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _currentFilter = category;
    notifyListeners();

    try {
      final searchResults = await _apiService.searchRestaurants(category);
      _filteredRestaurants = searchResults;
    } catch (e) {
      _errorMessage = e.toString();
      _filteredRestaurants = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearFilter() {
    _filteredRestaurants = [];
    _currentFilter = '';
    notifyListeners();
  }
}
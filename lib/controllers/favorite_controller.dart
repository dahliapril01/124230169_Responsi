import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:responsi/models/restaurant.dart';

class FavoriteController with ChangeNotifier {
  final Box<Restaurant> _favoritesBox = Hive.box<Restaurant>('favorites');

  List<Restaurant> get favorites => _favoritesBox.values.toList();

  bool isFavorite(String restaurantId) {
    return _favoritesBox.containsKey(restaurantId);
  }

  Future<void> addFavorite(Restaurant restaurant) async {
    await _favoritesBox.put(restaurant.id, restaurant);
    notifyListeners();
  }

  Future<void> removeFavorite(String restaurantId) async {
    await _favoritesBox.delete(restaurantId);
    notifyListeners();
  }

  Future<bool> toggleFavorite(Restaurant restaurant) async {
    if (isFavorite(restaurant.id)) {
      await removeFavorite(restaurant.id);
      return false;
    } else {
      await addFavorite(restaurant);
      return true;
    }
  }
}
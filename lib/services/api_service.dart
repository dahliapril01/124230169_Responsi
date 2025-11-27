import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsi/models/restaurant.dart';
import 'package:responsi/models/restaurant_detail.dart';

class ApiService {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<List<Restaurant>> getRestaurants() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/list'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List restaurantsJson = data['restaurants'];
        return restaurantsJson.map((json) => Restaurant.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<RestaurantDetail> getRestaurantDetail(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/detail/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return RestaurantDetail.fromJson(data['restaurant']);
      } else {
        throw Exception('Failed to load restaurant detail');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Restaurant>> searchRestaurants(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/search?q=$query'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List restaurantsJson = data['restaurants'];
        return restaurantsJson.map((json) => Restaurant.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search restaurants');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
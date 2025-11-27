import 'package:hive/hive.dart';

part 'restaurant.g.dart';

@HiveType(typeId: 0)
class Restaurant {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String pictureId;
  
  @HiveField(4)
  final String city;
  
  @HiveField(5)
  final double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      pictureId: json['pictureId'] ?? '',
      city: json['city'] ?? '',
      rating: (json['rating'] is int) 
          ? (json['rating'] as int).toDouble() 
          : (json['rating'] as double? ?? 0.0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureId': pictureId,
      'city': city,
      'rating': rating,
    };
  }

  String get imageUrl =>
      'https://restaurant-api.dicoding.dev/images/small/$pictureId';
}
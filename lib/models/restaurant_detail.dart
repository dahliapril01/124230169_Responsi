import 'package:hive/hive.dart';

part 'restaurant_detail.g.dart';

@HiveType(typeId: 1)
class RestaurantDetail {
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
  final String address;
  
  @HiveField(6)
  final double rating;
  
  @HiveField(7)
  final List<Category> categories;
  
  @HiveField(8)
  final Menus menus;
  
  @HiveField(9)
  final List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.address,
    required this.rating,
    required this.categories,
    required this.menus,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      pictureId: json['pictureId'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : (json['rating'] as double? ?? 0.0),
      categories: (json['categories'] as List?)
              ?.map((e) => Category.fromJson(e))
              .toList() ??
          [],
      menus: Menus.fromJson(json['menus'] ?? {}),
      customerReviews: (json['customerReviews'] as List?)
              ?.map((e) => CustomerReview.fromJson(e))
              .toList() ??
          [],
    );
  }

  String get imageUrl =>
      'https://restaurant-api.dicoding.dev/images/medium/$pictureId';
}

@HiveType(typeId: 2)
class Category {
  @HiveField(0)
  final String name;

  Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json['name'] ?? '');
  }
}

@HiveType(typeId: 3)
class Menus {
  @HiveField(0)
  final List<MenuItem> foods;
  
  @HiveField(1)
  final List<MenuItem> drinks;

  Menus({required this.foods, required this.drinks});

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      foods: (json['foods'] as List?)
              ?.map((e) => MenuItem.fromJson(e))
              .toList() ??
          [],
      drinks: (json['drinks'] as List?)
              ?.map((e) => MenuItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

@HiveType(typeId: 4)
class MenuItem {
  @HiveField(0)
  final String name;

  MenuItem({required this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(name: json['name'] ?? '');
  }
}

@HiveType(typeId: 5)
class CustomerReview {
  @HiveField(0)
  final String name;
  
  @HiveField(1)
  final String review;
  
  @HiveField(2)
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'] ?? '',
      review: json['review'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
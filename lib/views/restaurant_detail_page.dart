import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsi/controllers/restaurant_controller.dart';
import 'package:responsi/controllers/favorite_controller.dart';
import 'package:responsi/models/restaurant.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailPage({Key? key, required this.restaurantId}) : super(key: key);

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final restaurantController = Provider.of<RestaurantController>(context, listen: false);
      restaurantController.fetchRestaurantDetail(widget.restaurantId);
    });
  }

  void _toggleFavorite() async {
    final restaurantController = Provider.of<RestaurantController>(context, listen: false);
    final favoriteController = Provider.of<FavoriteController>(context, listen: false);
    
    final detail = restaurantController.restaurantDetail;
    if (detail == null) return;

    final restaurant = Restaurant(
      id: detail.id,
      name: detail.name,
      description: detail.description,
      pictureId: detail.pictureId,
      city: detail.city,
      rating: detail.rating,
    );

    final isAdded = await favoriteController.toggleFavorite(restaurant);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isAdded ? 'Ditambahkan ke favorit' : 'Dihapus dari favorit'),
        backgroundColor: isAdded ? Colors.green : Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RestaurantController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 80, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error: ${controller.errorMessage}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      controller.fetchRestaurantDetail(widget.restaurantId);
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final detail = controller.restaurantDetail;
          if (detail == null) {
            return Center(child: Text('Restaurant tidak ditemukan'));
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      detail.name,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  background: Image.network(
                    detail.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.restaurant, size: 100, color: Colors.grey),
                      );
                    },
                  ),
                ),
                actions: [
                  Consumer<FavoriteController>(
                    builder: (context, favoriteController, _) {
                      final isFavorite = favoriteController.isFavorite(detail.id);
                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                        ),
                        onPressed: _toggleFavorite,
                      );
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.red, size: 20),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      detail.city,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Icon(Icons.star, color: Colors.amber, size: 20),
                                  SizedBox(width: 4),
                                  Text(
                                    detail.rating.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.place, color: Colors.grey, size: 20),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      detail.address,
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      Text(
                        'Kategori',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: detail.categories.map((category) {
                          return Chip(
                            label: Text(category.name),
                            backgroundColor: Colors.blue.shade100,
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),

                      Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        detail.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 14, height: 1.5),
                      ),
                      SizedBox(height: 16),

                      Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      
                      Text(
                        'Makanan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: detail.menus.foods.map((food) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            child: Text(food.name),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),

                      Text(
                        'Minuman',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: detail.menus.drinks.map((drink) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Text(drink.name),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),

                      Text(
                        'Customer Reviews',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: detail.customerReviews.length,
                        itemBuilder: (context, index) {
                          final review = detail.customerReviews[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  review.name[0].toUpperCase(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(
                                review.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(review.review),
                                  SizedBox(height: 4),
                                  Text(
                                    review.date,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
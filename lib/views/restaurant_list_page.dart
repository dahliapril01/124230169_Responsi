import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsi/controllers/auth_controller.dart';
import 'package:responsi/controllers/restaurant_controller.dart';
import 'package:responsi/models/restaurant.dart';
import 'package:responsi/views/restaurant_detail_page.dart';
import 'package:responsi/views/favorite_page.dart';
import 'package:responsi/views/login_page.dart';

class RestaurantListPage extends StatefulWidget {
  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  String _selectedCategory = '';

  final List<String> _categories = [
    'All',
    'Modern',
    'Italia',
    'Jawa',
    'Sunda',
    'Bali',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = Provider.of<AuthController>(context, listen: false);
      authController.init();
      
      final restaurantController = Provider.of<RestaurantController>(context, listen: false);
      restaurantController.fetchRestaurants();
    });
  }

  void _onCategorySelected(String category) {
    final restaurantController = Provider.of<RestaurantController>(context, listen: false);
    
    setState(() {
      if (category == 'All') {
        _selectedCategory = '';
        restaurantController.clearFilter();
      } else {
        _selectedCategory = category;
        restaurantController.filterByCategory(category);
      }
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final authController = Provider.of<AuthController>(context, listen: false);
                await authController.logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AuthController>(
          builder: (context, authController, _) {
            return Text('Hi, ${authController.username}!');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FavoritePage()),
              );
            },
            tooltip: 'Favorites',
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _showLogoutDialog,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = (category == 'All' && _selectedCategory.isEmpty) ||
                    category == _selectedCategory;

                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      _onCategorySelected(category);
                    },
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: isSelected ? 4 : 0,
                    pressElevation: 2,
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: Consumer<RestaurantController>(
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
                          onPressed: () => controller.fetchRestaurants(),
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.restaurants.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Tidak ada restaurant ditemukan',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        if (_selectedCategory.isNotEmpty) ...[
                          SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              _onCategorySelected('All');
                            },
                            child: Text('Hapus Filter'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.fetchRestaurants(),
                  child: ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: controller.restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = controller.restaurants[index];
                      return RestaurantCard(restaurant: restaurant);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RestaurantDetailPage(restaurantId: restaurant.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                restaurant.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.restaurant, size: 80, color: Colors.grey),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.red),
                      SizedBox(width: 4),
                      Text(
                        restaurant.city,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        restaurant.rating.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
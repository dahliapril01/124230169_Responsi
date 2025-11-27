import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsi/controllers/auth_controller.dart';
import 'package:responsi/controllers/restaurant_controller.dart';
import 'package:responsi/controllers/favorite_controller.dart';
import 'package:responsi/models/restaurant.dart';
import 'package:responsi/models/restaurant_detail.dart';
import 'package:responsi/views/login_page.dart';
import 'package:responsi/views/restaurant_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  
  Hive.registerAdapter(RestaurantAdapter());
  Hive.registerAdapter(RestaurantDetailAdapter());
  
  await Hive.openBox<Restaurant>('favorites');
  
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  
  final authController = AuthController();
  await authController.init();
  
  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    authController: authController,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final AuthController authController;

  const MyApp({
    Key? key, 
    required this.isLoggedIn,
    required this.authController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authController),
        ChangeNotifierProvider(create: (_) => RestaurantController()),
        ChangeNotifierProvider(create: (_) => FavoriteController()),
      ],
      child: MaterialApp(
        title: 'Restaurant App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: isLoggedIn ? RestaurantListPage() : LoginPage(),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginResult { success, notRegistered, wrongCredentials }

class AuthController with ChangeNotifier {
  String _username = '';
  String get username => _username;

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    
    _prefs = await SharedPreferences.getInstance();
    _username = _prefs?.getString('username') ?? '';
    _isInitialized = true;
    notifyListeners();
  }

  Future<LoginResult> login(String username, String password) async {
    if (_prefs == null) {
      await init();
    }

    final storedUsername = _prefs!.getString('username');
    final storedPassword = _prefs!.getString('password');

    await Future.delayed(Duration(milliseconds: 300));

    if (storedUsername == null || storedPassword == null) {
      return LoginResult.notRegistered;
    }

    if (username == storedUsername && password == storedPassword) {
      await _prefs!.setBool('isLoggedIn', true);
      _username = username;
      notifyListeners();
      return LoginResult.success;
    }

    return LoginResult.wrongCredentials;
  }

  Future<bool> register(String username, String password) async {
    if (_prefs == null) {
      await init();
    }

    await Future.delayed(Duration(milliseconds: 300));
    await _prefs!.setString('username', username);
    await _prefs!.setString('password', password);
    return true;
  }

  Future<void> logout() async {
    if (_prefs == null) {
      await init();
    }

    await _prefs!.setBool('isLoggedIn', false);
    await _prefs!.remove('username');
    await _prefs!.remove('password');
    _username = '';
    notifyListeners();
  }
}
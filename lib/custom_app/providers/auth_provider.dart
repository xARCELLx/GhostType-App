import 'package:flutter/material.dart';
import '../services/LoginService.dart';
import '../services/SignUpScreen_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSignedUp = false;
  bool _isLoggedIn = false;
  String? _username;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSignedUp => _isSignedUp;
  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;

  // Initialize AuthProvider and load saved data
  AuthProvider() {
    _loadSavedData();
  }

  // Load saved username from LoginService
  Future<void> _loadSavedData() async {
    _username = await LoginService.getUsername();
    _isLoggedIn = (await LoginService.getAuthToken()) != null; // Consider logged in if auth token exists
    notifyListeners();
  }

  // Method to sign up using the SignUpService
  Future<void> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _isSignedUp = false;
    notifyListeners();

    try {
      await SignUpService.signUp(
        email: email,
        username: username,
        password: password,
      );
      _isSignedUp = true;
      // Since signup API doesn't return username, we can set it from the input
      _username = username;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login method using LoginService
  Future<void> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _isLoggedIn = false;
    notifyListeners();

    try {
      final response = await LoginService.login(
        email: email,
        password: password,
      );
      _isLoggedIn = true;
      _username = response['username'];
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout method
  Future<void> logout() async {
    await LoginService.logout();
    _isLoggedIn = false;
    _username = null;
    notifyListeners();
  }

  // Getters for tokens (delegate to LoginService)
  Future<String?> getAuthToken() async {
    return await LoginService.getAuthToken();
  }

  Future<String?> getRefreshToken() async {
    return await LoginService.getRefreshToken();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static const String baseUrl = "http://192.168.42.156:8000/auth/login/";

  // Login method that handles API call and saves tokens/username
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(baseUrl),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Save tokens and username to shared_preferences
        await _saveData(
          refresh: data['refresh'],
          authToken: data['access'],
          username: data['username'],
        );
        return data; // Return the full response
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message']);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Save tokens and username to shared_preferences
  static Future<void> _saveData({
    required String refresh,
    required String authToken,
    required String username,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh_token', refresh);
    await prefs.setString('auth_token', authToken);
    await prefs.setString('username', username);
  }

  // Clear saved data on logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('refresh_token');
    await prefs.remove('auth_token');
    await prefs.remove('username');
  }

  // Retrieve auth token
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Retrieve refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  // Retrieve username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpService {
  static const String baseUrl = "http://192.168.42.156:8000/auth/register/";

  static Future<bool> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    final Map<String, dynamic> body = {
      "email": email,
      "username": username,
      "password": password
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else{
        final error = jsonDecode(response.body);
        throw Exception(error['message']);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

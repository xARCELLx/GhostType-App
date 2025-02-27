import 'package:http/http.dart' as http;
import 'dart:convert';

class SingUpService{

  static const String baseUrl="http://127.0.0.1:8000/auth/register/";

  static Future<bool> SignUp({required String email, required String username ,required String password}) async{

    final Map<String,dynamic> Body={
      "email":email,
      "username":username,
      "password":password
    };

    try{
      final response=http.post(
          Uri.parse(baseUrl),
          body:jsonEncode(Body),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successful signup (status codes 200 or 201 typically indicate success)
        return true;

    }

  }
}



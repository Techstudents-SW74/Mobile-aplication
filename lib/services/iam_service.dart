
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class AuthService {
  final String baseUrl = 'https://kitchen-tech-fqghavb0fychfkhm.brazilsouth-01.azurewebsites.net/api/kitchentech/v1/auth';

  Future<User?> signIn(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData != null) {
        return User.fromJson(responseData); // Create User from JSON response
      }
    }
    return null; // Return null on failure
  }
}

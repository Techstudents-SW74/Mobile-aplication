import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class ApiService {
  String? _token;

  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$BASE_URL/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al iniciar sesión: ${response.body}');
    }
  }

  Future<String?> getToken() async {
    if (_token != null) return _token;

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    if (token == null) throw Exception('Token no encontrado');

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }



  Future<dynamic> getAccountsByRestaurant(String restaurantId) async {
    final url = Uri.parse('$BASE_URL/account/restaurant/$restaurantId');
    final headers = await _getHeaders();

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Error al obtener cuentas: ${response.body}');
  }

  Future<List<dynamic>> getProductsByRestaurant(String restaurantId) async {
    final url = Uri.parse('$BASE_URL/product/restaurant/$restaurantId');
    final headers = await _getHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Error al obtener productos: ${response.body}');
    }
  }


  Future<void> createClient(Map<String, dynamic> clientData) async {
    final url = Uri.parse('$BASE_URL/client');
    final headers = await _getHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(clientData),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear cliente: ${response.body}');
    }
  }

  Future<void> createSale(String accountId, Map<String, dynamic> saleData) async {
    final url = Uri.parse('$BASE_URL/account/$accountId/products');
    final headers = await _getHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(saleData),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al guardar venta: ${response.body}');
    }
  }
}
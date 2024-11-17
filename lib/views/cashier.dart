import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_application/components/navigator.dart';
import '../services/api_service.dart';

class CashierScreen extends StatefulWidget {
  @override
  _BoxScreenState createState() => _BoxScreenState();
}

class _BoxScreenState extends State<CashierScreen> {
  int _selectedIndex = 0;
  List<dynamic> _products = [];
  bool _isLoading = true;

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final restaurantId = prefs.getInt('restaurantId');
      print(prefs.getInt('restaurantId'));
      if (restaurantId != null) {
        final products = await _apiService.getProductsByRestaurant(restaurantId.toString());
        setState(() {
          _products = products;
          _isLoading = false;
        });
      } else {
        throw Exception('Restaurant ID no encontrado en SharedPreferences.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar productos: $e')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        Navigator.pushReplacementNamed(context, '/chairs');
      } else if (index == 2) {
        Navigator.pushReplacementNamed(context, '/sales_summary');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF31304A),
        title: Text('Caja', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _products.isEmpty
          ? Center(
        child: Text(
          'No hay Productos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              color: Color(0xFFD3D2E5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  product['productName'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Acceso rápido'),
                trailing: Text(
                  'S/${product['productPrice'].toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/account_screen');
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: NavigatorBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}

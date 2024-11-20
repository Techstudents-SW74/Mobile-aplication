import 'package:flutter/material.dart';
import 'package:mobile_application/components/navigator.dart';
import 'package:mobile_application/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesSummaryScreen extends StatefulWidget {
  @override
  _SalesSummaryScreenState createState() => _SalesSummaryScreenState();
}

class _SalesSummaryScreenState extends State<SalesSummaryScreen> {
  int _selectedIndex = 2;
  final ApiService _apiService = ApiService();
  double _totalSalesSoles = 0.0;
  double _totalSalesDollars = 0.0;
  int _salesCount = 0;

  @override
  void initState() {
    super.initState();
    _loadSalesSummary();
  }

  Future<void> _loadSalesSummary() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final restaurantId = prefs.getInt('restaurantId');

      if (restaurantId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restaurant ID no encontrado.')),
        );
        return;
      }

      final accounts = await _apiService.getAccountsByRestaurant(restaurantId);
      print("Cuentas obtenidas para el resumen de ventas: $accounts");

      double totalSalesSoles = 0.0;
      for (var account in accounts) {
        totalSalesSoles += account['totalAccount'] ?? 0.0;
      }

      setState(() {
        _totalSalesSoles = totalSalesSoles;
        _totalSalesDollars = totalSalesSoles * 0.26;
        _salesCount = accounts.length;
      });
    } catch (e) {
      print("Error al cargar resumen de ventas: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar resumen de ventas: $e')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/cashier');
      } else if (index == 1) {
        Navigator.pushReplacementNamed(context, '/chairs');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF31304A),
        title: Text('Resumen de Ventas', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
              Row(
                children: [
                  Expanded(child: _buildSummaryCard('Total de ventas en soles', 'S/ ${_totalSalesSoles.toStringAsFixed(2)}')),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildSummaryCard('Total de ventas en dólares', '\$ ${_totalSalesDollars.toStringAsFixed(2)}')),
                ],
              ),
              SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Cantidad de ventas',
                    '$_salesCount',
                  ),
                ),
              ],
              ),
          ],
        ),
      ),
      bottomNavigationBar: NavigatorBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Container(
      height: 150,
      child: Card(
        color: Color(0xFFD3D2E5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: TextStyle(fontSize: 16, color: Colors.black54)),
              SizedBox(height: 8),
              Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
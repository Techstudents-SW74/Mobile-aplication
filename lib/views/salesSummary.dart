import 'package:flutter/material.dart';
import 'package:mobile_application/components/navigator.dart';

class SalesSummaryScreen extends StatefulWidget {
  @override
  _SalesSummaryScreenState createState() => _SalesSummaryScreenState();
}

class _SalesSummaryScreenState extends State<SalesSummaryScreen> {
  int _selectedIndex = 2;

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
                Expanded(
                    child: _buildSummaryCard(
                        'Total de ventas en soles', 'S/ 746.00')),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: _buildSummaryCard(
                        'Total de ventas en dólares', '\$ 0.00')),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildSummaryCard('Cantidad de ventas', '43')),
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
              Text(title,
                  style: TextStyle(fontSize: 16, color: Colors.black54)),
              SizedBox(height: 8),
              Text(value,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

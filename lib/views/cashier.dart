import 'package:flutter/material.dart';
import 'package:mobile_application/components/navigator.dart';

class CashierScreen extends StatefulWidget {
  @override
  _BoxScreenState createState() => _BoxScreenState();
}

class _BoxScreenState extends State<CashierScreen> {
  int _selectedIndex = 0;

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
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              color: Color(0xFFD3D2E5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  'Product',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Acceso rápido'),
                trailing: Text(
                  'S/0.00',
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

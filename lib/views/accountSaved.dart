import 'package:flutter/material.dart';
import 'package:mobile_application/components/navigator.dart';

class AccountSavedScreen extends StatefulWidget {
  @override
  _AccountSavedScreenState createState() => _AccountSavedScreenState();
}

class _AccountSavedScreenState extends State<AccountSavedScreen> {

  bool isViewingCuentas = true;
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/cashier');
      } else if (index == 2) {
        Navigator.pushReplacementNamed(context, '/sales_summary');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF31304A),
        title: Text('Cuentas Guardadas', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildToggleButton('Ver Mesas', !isViewingCuentas),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildToggleButton('Ver Cuentas', isViewingCuentas),
                ),
              ],
            ),
          ),
          Expanded(
            child: isViewingCuentas ? _buildCuentasView() : _buildMesasView(),
          ),
        ],
      ),
      bottomNavigationBar: NavigatorBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }


  Widget _buildToggleButton(String text, bool isSelected) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isViewingCuentas = text == 'Ver Cuentas';
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Color(0xFF373557) : Color(0xFFD3D2E5),
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(text),
    );
  }

  Widget _buildMesasView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: List.generate(15, (index) {
          return Container(
            decoration: BoxDecoration(
              color: Color(0xFFEDEBF5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text('${index + 1}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
          );
        }),
      ),
    );
  }
}
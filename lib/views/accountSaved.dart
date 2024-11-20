import 'package:flutter/material.dart';
import 'package:mobile_application/components/navigator.dart';
import 'package:mobile_application/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSavedScreen extends StatefulWidget {
  @override
  _AccountSavedScreenState createState() => _AccountSavedScreenState();
}

class _AccountSavedScreenState extends State<AccountSavedScreen> {
  bool isViewingCuentas = true;
  int _selectedIndex = 1;

  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _accounts = [];
  List<Map<String, dynamic>> _tables = [];

  @override
  void initState() {
    super.initState();
    _loadAccountsAndTables();
  }

  Future<void> _loadAccountsAndTables() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final restaurantId = prefs.getInt('restaurantId');
      print("Restaurante ID obtenido: $restaurantId");

      if (restaurantId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restaurant ID no encontrado.')),
        );
        return;
      }

      final accounts = await _apiService.getAccountsByRestaurant(restaurantId);
      final tables = await _apiService.getTablesByRestaurant(restaurantId);

      print("Cuentas obtenidas desde API: $accounts");
      print("Mesas obtenidas desde API: $tables");

      setState(() {
        _accounts =
            accounts.map((account) => account as Map<String, dynamic>).toList();
        _tables = tables.map((table) => table as Map<String, dynamic>).toList();
      });

      print("Estado de cuentas: $_accounts");
      print("Estado de mesas: $_tables");
    } catch (e) {
      print("Error al cargar datos: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e')),
      );
    }
  }

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
    if (_tables.isEmpty) {
      return Center(
        child: Text(
          'No hay mesas disponibles.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: _tables.map((table) {
          final tableStatus = table['tableStatus'];
          final isFree = tableStatus == 'Free';

          return Container(
            decoration: BoxDecoration(
              color: isFree ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Mesa ${table['tableNumber']}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCuentasView() {
    if (_accounts.isEmpty) {
      return Center(
        child: Text(
          'No hay cuentas disponibles.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      itemCount: _accounts.length,
      itemBuilder: (context, index) {
        final account = _accounts[index];
        final clientName = account['client']?['fullName'] ?? 'Sin Cliente';
        final totalAccount = account['totalAccount'] ?? 0.0;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Card(
            color: Color(0xFFEDEBF5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                account['accountName'] ?? 'Sin Nombre',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(clientName),
              trailing: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('S/$totalAccount',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.black),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

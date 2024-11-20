import 'package:flutter/material.dart';
import 'package:mobile_application/components/navigator.dart';
import 'package:mobile_application/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  final String productName;
  final double productPrice;
  final int productId;
  AccountScreen({required this.productName, required this.productPrice,required this.productId,});
  @override
  _AccountScreenState createState() => _AccountScreenState();

}

class _AccountScreenState extends State<AccountScreen> {
  bool showClientForm = false;
  bool clientSaved = false;
  String clientRUC = '';
  String clientName = '';
  int _selectedIndex = 0;
  double _subtotal = 0.0;
  double _igv = 0.0;
  double _total = 0.0;
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _tables = [];
  int? selectedTableId;

  final TextEditingController rucController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController tableController = TextEditingController();

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _initializeProducts();
    _calculateCosts();
    _loadTables();
  }

  void _initializeProducts() {
    setState(() {
      _products.add({
        'id': widget.productId,
        'name': widget.productName,
        'price': widget.productPrice,
        'quantity': 1,
      });
    });
    _calculateCosts();
  }

  void _calculateCosts() {
    setState(() {
      _subtotal = _products.fold(
        0.0, (sum, product) => sum + product['price'] * product['quantity'],
      );
      _igv = _subtotal * 0.18;
      _total = _subtotal + _igv;
    });
  }

  Future<void> _loadTables() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final restaurantId = prefs.getInt('restaurantId');

      if (restaurantId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restaurant ID no encontrado.')),
        );
        return;
      }

      final tables = await _apiService.getTablesByRestaurant(restaurantId);
      setState(() {
        _tables = tables.map((table) => {
          "id": table['id'],
          "tableNumber": table['tableNumber'],
          "tableCapacity": table['tableCapacity'],
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar mesas: $e')),
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

  Future<void> _addClient() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final restaurantId = prefs.getInt('restaurantId');

      if (restaurantId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restaurant ID no encontrado.')),
        );
        return;
      }

      final clientData = {
        "document": rucController.text,
        "fullName": nameController.text,
        "documentType": "DNI",
        "restaurantId": restaurantId,
      };
      print(clientData);
      await _apiService.createClient(clientData);

      setState(() {
        clientSaved = true;
        showClientForm = false;
        clientRUC = rucController.text;
        clientName = nameController.text;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cliente agregado correctamente.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar cliente: $e')),
      );
    }
  }

  Future<void> _createAccount() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final restaurantId = prefs.getInt('restaurantId');

      if (restaurantId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restaurant ID no encontrado.')),
        );
        return;
      }

      final now = DateTime.now().toIso8601String();
      final accountData = {
        "accountName": accountNameController.text,
        "client": {"id": clientRUC},
        "table": {"id": tableController.text},
        "restaurantId": restaurantId,
        "state": "OPEN",
        "totalAccount": _total,
        "dateCreated": now,
        "dateLog": now,
        "products": _products.map((product) {
          return {
            "id": product['id'],
            "quantity": product['quantity'],
            "price": product['price'],
          };
        }).toList(),
      };

      await _apiService.createAccount(accountData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cuenta creada correctamente.')),
      );

      Navigator.pushReplacementNamed(context, '/chairs');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear cuenta: $e')),
      );
    }
  }

  void _showSaveSaleDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Guardar Venta', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: accountNameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de la Cuenta',
                    filled: true,
                    fillColor: Color(0xFFEDEBF5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: selectedTableId,
                  onChanged: (value) {
                    setState(() {
                      selectedTableId = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Seleccionar Mesa',
                    filled: true,
                    fillColor: Color(0xFFEDEBF5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: _tables.map((table) {
                    return DropdownMenuItem<int>(
                      value: table['id'],
                      child: Text('Mesa ${table['tableNumber']} - ${table['tableCapacity']} personas'),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/chairs');
                },
                child: Text(
                  'Guardar Cuenta',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Color(0xFF31304A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFF0F0F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF31304A),
        title: Text('Cuenta', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.receipt),
            onPressed: () {},
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showClientForm = !showClientForm;
                            clientSaved = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFEDEBF5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                showClientForm ? 'Cancelar Cliente' : 'Agregar Cliente',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Icon(
                                showClientForm ? Icons.close : Icons.person_add,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (showClientForm)
                        Column(
                          children: [
                            TextField(
                              controller: rucController,
                              decoration: InputDecoration(
                                labelText: 'DNI',
                                filled: true,
                                fillColor: Color(0xFFEDEBF5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Nombre del Cliente',
                                filled: true,
                                fillColor: Color(0xFFEDEBF5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () async {
                                await _addClient();
                              },
                              child: Text(
                                'Guardar Cliente',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                backgroundColor: Color(0xFF7C73CC),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 20),
                      if (clientSaved)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFEDEBF5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'RUC: $clientRUC',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Nombre: $clientName',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFEDEBF5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Productos Seleccionados:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ..._products.map((product) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nombre: ${product['name']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Precio: S/${product['price'].toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Cantidad: ${product['quantity']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFEDEBF5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: clientSaved ? _showSaveSaleDialog : null,
                                    child: Text(
                                      'Guardar Venta',
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                                      backgroundColor: Color(0xFF31304A),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal:',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                Text(
                                  'S/${_subtotal.toStringAsFixed(2)}',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'I.G.V.:',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                Text(
                                  'S/${_igv.toStringAsFixed(2)}',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: clientSaved ? () {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/payment',
                                        arguments: {
                                          'total': _total,
                                          'igv': _igv,
                                          'document': clientRUC,
                                          'name': clientName,
                                        },
                                      );
                                    }: null,
                                    child: Text(
                                      'Cobrar '+'S/${_total.toStringAsFixed(2)}',
                                      style: TextStyle(color: Colors.white, fontSize: 17),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                                      backgroundColor: Color(0xFF31304A),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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

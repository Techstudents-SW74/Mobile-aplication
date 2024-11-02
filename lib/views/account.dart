import 'package:flutter/material.dart';
import 'package:mobile_application/components/navigator.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool showClientForm = false;
  bool clientSaved = false;
  String clientRUC = '';
  String clientName = '';
  int _selectedIndex = 0;

  final TextEditingController rucController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController tableController = TextEditingController();

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
                TextField(
                  controller: tableController,
                  decoration: InputDecoration(
                    labelText: 'Mesa',
                    filled: true,
                    fillColor: Color(0xFFEDEBF5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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
                                labelText: 'DNI / RUC / CE',
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
                              onPressed: () {
                                setState(() {
                                  clientRUC = rucController.text;
                                  clientName = nameController.text;
                                  clientSaved = true;
                                  showClientForm = false;
                                });
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
                                  'S/0.00',
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
                                  'S/0.00',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(context, '/payment');
                                    },
                                    child: Text(
                                      'Cobrar S/0.00',
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

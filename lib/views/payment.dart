import 'package:flutter/material.dart';
import 'package:mobile_application/components/navigator.dart';

class PaymentScreen extends StatefulWidget {
  final double total;
  final double igv;
  final String document;
  final String name;

  PaymentScreen({required this.total, required this.igv, required this.document, required this.name});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final int _selectedIndex = 0;
  final TextEditingController _cobrarController = TextEditingController();
  double _faltante = 0.0;

  @override
  void initState() {
    super.initState();

    _faltante = widget.total;
    _cobrarController.addListener(_updateFaltante);
  }

  @override
  void dispose() {
    _cobrarController.dispose();
    super.dispose();
  }

  void _updateFaltante() {
    setState(() {
      double cobrar = double.tryParse(_cobrarController.text) ?? 0.0;
      _faltante = widget.total - cobrar;
    });
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index != _selectedIndex) {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/cashier');
      } else if (index == 1) {
        Navigator.pushReplacementNamed(context, '/chairs');
      } else if (index == 2) {
        Navigator.pushReplacementNamed(context, '/sales_summary');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF31304A),
        title: Text('Cobro de Pedido', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Cobro de Pedido',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text('Cobrar', style: TextStyle(color: Colors.black)),
                      Container(
                        margin: EdgeInsets.only(top: 8.0),
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _cobrarController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'S/ 0.00',
                            ),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Faltante', style: TextStyle(color: Colors.black)),
                      Container(
                        margin: EdgeInsets.only(top: 8.0),
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: _faltante > 0 ? Colors.red[100] : Colors.green[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'S/ ${_faltante.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _faltante > 0 ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: PaymentButton(label: 'Efectivo')),
                  SizedBox(width: 10),
                  Expanded(child: PaymentButton(label: 'Tarjeta')),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: PaymentButton(label: 'Yape / Plin')),
                  SizedBox(width: 10),
                  Expanded(child: PaymentButton(label: 'Transferencia')),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color(0xFFEDEBF5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PaymentDetail(label: 'Tarjeta', amount: 'S/ ${widget.total.toStringAsFixed(2)}'),
                    PaymentDetail(label: 'Yape', amount: 'S/ ${widget.total.toStringAsFixed(2)}'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/document',
                    arguments: {
                      'total': widget.total,
                      'igv': widget.igv,
                      'document': widget.document,
                      'name': widget.name,
                    },
                  );
                },
                child: Text('Emitir documento de venta', style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  backgroundColor: Color(0xFF31304A),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigatorBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) => _onItemTapped(context, index),
      ),
    );
  }
}

class PaymentButton extends StatelessWidget {
  final String label;

  PaymentButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(label, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15),
        backgroundColor: Color(0xFF31304A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class PaymentDetail extends StatelessWidget {
  final String label;
  final String amount;

  PaymentDetail({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Text(amount, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
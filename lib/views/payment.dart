import 'package:flutter/material.dart';
import 'package:mobile_application/components/navigator.dart';

class PaymentScreen extends StatelessWidget {
  final int _selectedIndex = 0;

  void _onItemTapped(BuildContext context, int index) {
    if (index != _selectedIndex) {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/cashier');
      } else if (index == 1) {
        Navigator.pushReplacementNamed(context, '/account');
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
        title: Text('Cuenta', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'S/ 20.00',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'S/ 35.00',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
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
                  PaymentDetail(label: 'Tarjeta', amount: 'S/ 15.00'),
                  PaymentDetail(label: 'Tarjeta', amount: 'S/ 7.00'),
                  PaymentDetail(label: 'Yape', amount: 'S/ 12.00'),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/document');
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

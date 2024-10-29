import 'package:flutter/material.dart';
//import 'package:mobile_application/views/account.dart';
//import 'package:mobile_application/views/accountSaved.dart';
//import 'package:mobile_application/views/cashier.dart';
//import 'package:mobile_application/views/document.dart';
import 'package:mobile_application/views/login.dart';
//import 'package:mobile_application/views/payment.dart';
//import 'package:mobile_application/views/salesSummary.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/cashier': (context) => CashierScreen(),
        //'/chairs': (context) => AccountSavedScreen(),
        //'/sales_summary': (context) => SalesSummaryScreen(),
        //'/account_screen': (context) => AccountScreen(),
        '/payment': (context) => PaymentScreen(),
        //'/document': (context) => DocumentScreen(),
      },
    );
  }
}

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
}
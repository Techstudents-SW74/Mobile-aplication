import 'package:flutter/material.dart';

class NavigatorBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  NavigatorBar({required this.selectedIndex, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemSelected,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.calculate),
          label: ''
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: ''
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up),
          label: ''
        ),
      ],
      backgroundColor: Color(0xFF31304A),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}

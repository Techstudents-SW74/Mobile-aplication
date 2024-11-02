// lib/screens/user_profile_screen.dart

import 'package:flutter/material.dart';
import '../components/navigator.dart';
import '../models/user_model.dart';

class UserProfileScreen extends StatefulWidget {
  final User user;

  const UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.pushReplacementNamed(context, '/chairs');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/sales_summary');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF7C73CC),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(widget.user.photo),
            ),
            const SizedBox(height: 20),
            Text(
              '${widget.user.name} ${widget.user.lastname}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              widget.user.email,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const Divider(height: 30, thickness: 1),
            _buildInfoRow(Icons.person, 'Username', widget.user.username),
            _buildInfoRow(Icons.phone, 'Phone', widget.user.phone),
            _buildInfoRow(Icons.calendar_today, 'Birth Date', widget.user.birthDate),
            _buildInfoRow(Icons.work, 'Role', widget.user.role),
            _buildInfoRow(Icons.restaurant, 'Restaurant ID', widget.user.restaurantId.toString()),
          ],
        ),
      ),
      bottomNavigationBar: NavigatorBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF7C73CC)),
          const SizedBox(width: 10),
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_application/views/cashier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'userProfile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  String _responseMessage = '';

  Future<void> _login(BuildContext context) async {
    try {
      final user = await _apiService.login(
        _usernameController.text,
        _passwordController.text,
      );

      final token = await _apiService.getToken();
      if (token != null && user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);
        await prefs.setInt('restaurantId', user['restaurantId']);

        setState(() {
          _responseMessage = 'Inicio de sesión exitoso. Bienvenido!';
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CashierScreen(),
          ),
        );
      } else {
        setState(() {
          _responseMessage = 'Error: No se recibió token o datos del usuario.';
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = 'Error al iniciar sesión. Verifique sus credenciales.';
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    IconData? prefixIcon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.white54) : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.white54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.green, width: 2.0),
        ),
        filled: true,
        fillColor: const Color(0xFF605C83),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF373557),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField(
                controller: _usernameController,
                labelText: 'Usuario',
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _passwordController,
                labelText: 'Contraseña',
                prefixIcon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _login(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C73CC),
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              Text(
                _responseMessage,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: const Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

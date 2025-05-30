import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../routes/app_routes.dart';
import 'profile_screen.dart';
import 'admin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://api-huertos.vercel.app/api/usuarios/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final usuario = data['usuario'];
        
        String uid = data['id'];
        String nombre = usuario['nombres'] ?? 'Usuario';
        String zona = usuario['zona'] ?? 'Zona desconocida';
        String rol = usuario['rol'] ?? 'Sin rol';
        List<dynamic> dias = usuario['dias'] ?? [];
        String diasDisponibles = dias.join(', ');

        debugPrint('Usuario logueado con rol: $rol');

        if (rol == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminScreen(
                nombre: nombre,
                zona: zona,
                rol: rol,
                diasDisponibles: diasDisponibles,
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                nombre: nombre,
                zona: zona,
                rol: rol,
                diasDisponibles: diasDisponibles,
                usuarioId: uid,
              ),
            ),
          );
        }
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo o contraseña incorrectos')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al iniciar sesión')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoGeneral,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', height: 120),
                const SizedBox(height: 16),
                Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textoTitulo,
                  ),
                ),
                const SizedBox(height: 8),
                Container(height: 2, width: 100, color: AppColors.lineaTitulo),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: _emailController,
                  label: 'Correo electrónico',
                  icon: Icons.email,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Iniciar Sesión',
                  onPressed: _login,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.register);
                  },
                  child: Text(
                    '¿No tienes cuenta? Registrarme',
                    style: TextStyle(
                      color: AppColors.textoSecundario,
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

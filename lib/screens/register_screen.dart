import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../constants/colors.dart';
import '../routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _zonaController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  // List to store selected days
  List<String> _selectedDays = [];
  final List<String> _daysOfWeek = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo'
  ];

  @override
  void dispose() {
    _nombresController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _zonaController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor seleccione al menos un día disponible')),
        );
        return;
      }

      final nombres = _nombresController.text.trim();
      final correo = _correoController.text.trim();
      final telefono = _telefonoController.text.trim();
      final zona = _zonaController.text.trim();
      final contrasena = _contrasenaController.text.trim();
      final dias = _selectedDays; // Use the selected days list

      try {
        final response = await http.post(
          Uri.parse('https://api-huertos.vercel.app/api/usuarios'), // Replace with your API URL
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'nombres': nombres,
            'correo': correo,
            'telefono': telefono,
            'zona': zona,
            'dias': dias,
            'password': contrasena,
            'rol': 'usuario',
          }),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuario registrado: $nombres')),
          );
          // Navigate to LoginScreen after successful registration
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        } else {
          final error = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${error['mensaje'] ?? error['error']}')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al conectar con el servidor: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoGeneral,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 100),

              const SizedBox(height: 16),
              Text(
                'Registro',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.verdeTitulo,
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                height: 4,
                width: 120,
                color: AppColors.lineaTitulo,
              ),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nombresController,
                      label: 'Nombres',
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese sus nombres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _correoController,
                      label: 'Correo',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su correo';
                        }
                        if (!value.contains('@')) {
                          return 'Ingrese un correo válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _telefonoController,
                      label: 'Teléfono',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese su teléfono';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _zonaController,
                      label: 'Zona',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 12),
                    // Multi-select chips for days
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Días disponibles',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0,
                          children: _daysOfWeek.map((day) {
                            return ChoiceChip(
                              label: Text(day),
                              selected: _selectedDays.contains(day),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedDays.add(day);
                                  } else {
                                    _selectedDays.remove(day);
                                  }
                                });
                              },
                              selectedColor: AppColors.verdeLinea,
                              backgroundColor: Colors.grey[200],
                              labelStyle: TextStyle(
                                color: _selectedDays.contains(day)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _contrasenaController,
                      label: 'Contraseña',
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese una contraseña';
                        }
                        if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Registrar',
                      onPressed: _registrar,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                child: Text.rich(
                  TextSpan(
                    text: '¿Ya tienes cuenta? ',
                    style: TextStyle(color: AppColors.textoSecundario),
                    children: [
                      TextSpan(
                        text: 'Iniciar sesión',
                        style: TextStyle(
                          color: AppColors.lineaTitulo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
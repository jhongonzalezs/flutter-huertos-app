import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CrearZonaScreen extends StatefulWidget {
  const CrearZonaScreen({super.key});

  @override
  State<CrearZonaScreen> createState() => _CrearZonaScreenState();
}

class _CrearZonaScreenState extends State<CrearZonaScreen> {
  final _formKey = GlobalKey<FormState>();

  String nombre = '';
  String tamano = '';
  String tipoCultivo = '';
  String estado = 'Activa';

  bool _isLoading = false;

  final List<String> estados = ['Activa', 'Inactiva'];

  Future<void> crearZona() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://api-huertos.vercel.app/api/zonas');

    final body = json.encode({
      'nombre': nombre,
      'tamaño': tamano,
      'tipo_cultivo': tipoCultivo,
      'estado': estado,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 201) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Zona creada exitosamente')),
          );
          _formKey.currentState!.reset();
          setState(() {
            estado = 'Activa';
          });
        }
      } else {
        final data = json.decode(response.body);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${data['error'] ?? 'No se pudo crear la zona'}')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      labelStyle: const TextStyle(color: Color(0xFF4CAF50)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF81C784), width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF388E3C), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear zona de cultivo'),
        backgroundColor: const Color(0xFF388E3C),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Para que los botones e inputs ocupen todo el ancho disponible
            children: [
              Text(
                'Registra una nueva zona de cultivo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2E7D32),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Nombre
              TextFormField(
                decoration: inputDecoration.copyWith(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  return null;
                },
                onSaved: (value) {
                  nombre = value!.trim();
                },
              ),

              const SizedBox(height: 16),

              // Tamaño
              TextFormField(
                decoration: inputDecoration.copyWith(labelText: 'Tamaño (ej: 1500 m2)'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa el tamaño';
                  }
                  return null;
                },
                onSaved: (value) {
                  tamano = value!.trim();
                },
              ),

              const SizedBox(height: 16),

              // Tipo de cultivo
              TextFormField(
                decoration: inputDecoration.copyWith(labelText: 'Tipo de cultivo'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa el tipo de cultivo';
                  }
                  return null;
                },
                onSaved: (value) {
                  tipoCultivo = value!.trim();
                },
              ),

              const SizedBox(height: 16),

              // Estado (Dropdown)
              DropdownButtonFormField<String>(
                decoration: inputDecoration.copyWith(labelText: 'Estado'),
                value: estado,
                items: estados
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      estado = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 32),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF388E3C),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: crearZona,
                      child: const Text(
                        'Crear zona',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

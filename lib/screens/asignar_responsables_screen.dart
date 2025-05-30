import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/colors.dart'; // Asegúrate de que esta ruta sea correcta

class AsignarResponsablesScreen extends StatefulWidget {
  @override
  _AsignarResponsablesScreenState createState() => _AsignarResponsablesScreenState();
}

class _AsignarResponsablesScreenState extends State<AsignarResponsablesScreen> {
  String? _usuarioSeleccionado;
  String? _zonaSeleccionada;

  List<Map<String, dynamic>> _usuarios = [];
  List<Map<String, dynamic>> _zonas = [];

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
    _cargarZonas();
  }

  Future<void> _cargarUsuarios() async {
    final response = await http.get(Uri.parse('https://api-huertos.vercel.app/api/usuarios/solo-usuarios'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      setState(() {
        _usuarios = data.cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> _cargarZonas() async {
    final response = await http.get(Uri.parse('https://api-huertos.vercel.app/api/zonas'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      setState(() {
        _zonas = data.cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> _asignarResponsable() async {
    if (_usuarioSeleccionado == null || _zonaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar un usuario y una zona.')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('https://api-huertos.vercel.app/api/asignaciones'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario_id': _usuarioSeleccionado,
        'zona_id': _zonaSeleccionada,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Asignación realizada con éxito')),
      );
      setState(() {
        _usuarioSeleccionado = null;
        _zonaSeleccionada = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al realizar la asignación')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoGeneral,
      appBar: AppBar(
        backgroundColor: AppColors.verdeTitulo,
        title: const Text(
          'Asignar Responsable a Zona',
          style: TextStyle(color: AppColors.botonTexto),
        ),
        iconTheme: const IconThemeData(color: AppColors.botonTexto),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _usuarioSeleccionado,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.tarjetaFondo,
                labelText: 'Seleccionar usuario',
                labelStyle: const TextStyle(color: AppColors.textoSecundario),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.verdeLinea),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.verdeTitulo, width: 2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: _usuarios.map((usuario) {
                return DropdownMenuItem<String>(
                  value: usuario['id'],
                  child: Text(usuario['nombres']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _usuarioSeleccionado = value;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _zonaSeleccionada,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.tarjetaFondo,
                labelText: 'Seleccionar zona de cultivo',
                labelStyle: const TextStyle(color: AppColors.textoSecundario),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.verdeLinea),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.verdeTitulo, width: 2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: _zonas.map((zona) {
                return DropdownMenuItem<String>(
                  value: zona['id'],
                  child: Text(zona['nombre']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _zonaSeleccionada = value;
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.boton,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: _asignarResponsable,
                child: const Text(
                  'Asignar Responsable',
                  style: TextStyle(
                    color: AppColors.botonTexto,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

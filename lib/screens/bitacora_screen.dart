import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants/colors.dart';

class BitacoraScreen extends StatefulWidget {
  final String usuarioId;

  const BitacoraScreen({super.key, required this.usuarioId});

  @override
  State<BitacoraScreen> createState() => _BitacoraScreenState();
}

class _BitacoraScreenState extends State<BitacoraScreen> {
  List<Map<String, dynamic>> zonasAsignadas = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchZonasAsignadas();
  }

  Future<void> fetchZonasAsignadas() async {
    try {
      final asignacionesUrl = Uri.parse(
          'https://api-huertos.vercel.app/api/asignaciones/${widget.usuarioId}');
      final asignacionesRes = await http.get(asignacionesUrl);

      if (asignacionesRes.statusCode != 200) {
        throw Exception('Error al obtener asignaciones');
      }

      final List<dynamic> asignaciones = json.decode(asignacionesRes.body);

      List<Map<String, dynamic>> zonas = [];

      for (var asignacion in asignaciones) {
        final zonaId = asignacion['zona_id'];
        final zonaUrl =
            Uri.parse('https://api-huertos.vercel.app/api/zonas/$zonaId');

        final zonaRes = await http.get(zonaUrl);

        if (zonaRes.statusCode == 200) {
          final zonaData = json.decode(zonaRes.body);
          zonas.add({
            'nombre': zonaData['nombre'],
            'tamaño': zonaData['tamaño'],
            'tipo_cultivo': zonaData['tipo_cultivo'],
            'estado': zonaData['estado'],
          });
        }
      }

      setState(() {
        zonasAsignadas = zonas;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zonas Asignadas'),
        backgroundColor: AppColors.verdeLinea,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(child: Text('Error: $error'))
                : zonasAsignadas.isEmpty
                    ? const Center(child: Text('No hay zonas asignadas'))
                    : ListView.builder(
                        itemCount: zonasAsignadas.length,
                        itemBuilder: (context, index) {
                          final zona = zonasAsignadas[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.agriculture,
                                  color: AppColors.verdeLinea),
                              title: Text(zona['nombre'] ?? 'Sin nombre'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tamaño: ${zona['tamaño']}'),
                                  Text('Cultivo: ${zona['tipo_cultivo']}'),
                                  Text('Estado: ${zona['estado']}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalendarioTareasScreen extends StatefulWidget {
  const CalendarioTareasScreen({super.key});

  @override
  State<CalendarioTareasScreen> createState() => _CalendarioTareasScreenState();
}

class _CalendarioTareasScreenState extends State<CalendarioTareasScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedZonaId;
  String? selectedResponsableId;
  String? selectedActividad;
  DateTime? selectedDate;
  String descripcion = '';

  List<Map<String, dynamic>> zonas = [];
  List<Map<String, dynamic>> responsables = [];

  List<String> actividades = [
    'Siembra',
    'Riego',
    'Poda',
    'Limpieza',
    'Cosecha',
    'Fertilización',
    'Control de plagas',
  ];

  @override
  void initState() {
    super.initState();
    fetchZonasYResponsables();
  }

  Future<void> fetchZonasYResponsables() async {
    final zonasResponse = await http.get(
      Uri.parse('https://api-huertos.vercel.app/api/zonas'),
    );
    final usuariosResponse = await http.get(
      Uri.parse('https://api-huertos.vercel.app/api/usuarios/solo-usuarios'),
    );

    if (!mounted) return;

    if (zonasResponse.statusCode == 200 && usuariosResponse.statusCode == 200) {
      final zonasData = json.decode(zonasResponse.body) as List;
      final usuariosData = json.decode(usuariosResponse.body) as List;

      if (!mounted) return;
      setState(() {
        zonas = zonasData.cast<Map<String, dynamic>>();
        responsables = usuariosData.cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> enviarTarea() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (selectedZonaId == null ||
        selectedResponsableId == null ||
        selectedActividad == null ||
        selectedDate == null ||
        descripcion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    final Map<String, dynamic> tareaData = {
      'zonaId': selectedZonaId!,
      'fecha': selectedDate!.toIso8601String().split('T')[0],
      'responsable': selectedResponsableId!,
      'tipo_actividad': selectedActividad!,
      'descripcion': descripcion,
    };

    final response = await http.post(
      Uri.parse('https://api-huertos.vercel.app/api/tareas/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(tareaData),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarea creada correctamente')),
      );
      setState(() {
        selectedZonaId = null;
        selectedResponsableId = null;
        selectedActividad = null;
        selectedDate = null;
        descripcion = '';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear tarea: ${response.body}')),
      );
    }
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textoSecundario),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.verdeLinea),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.verdeTitulo, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de tareas'),
        backgroundColor: AppColors.boton,
        foregroundColor: AppColors.botonTexto,
      ),
      body:
          zonas.isEmpty || responsables.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: _buildInputDecoration('Zona'),
                        value: selectedZonaId,
                        items:
                            zonas
                                .map(
                                  (zona) => DropdownMenuItem<String>(
                                    value: zona['id'],
                                    child: Text(zona['nombre']),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (value) => setState(() => selectedZonaId = value),
                        validator:
                            (value) =>
                                value == null ? 'Seleccione una zona' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: _buildInputDecoration('Responsable'),
                        value: selectedResponsableId,
                        items:
                            responsables
                                .map(
                                  (r) => DropdownMenuItem<String>(
                                    value: r['id'],
                                    child: Text(r['nombres']),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (value) =>
                                setState(() => selectedResponsableId = value),
                        validator:
                            (value) =>
                                value == null
                                    ? 'Seleccione un responsable'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: _buildInputDecoration('Actividad'),
                        value: selectedActividad,
                        items:
                            actividades
                                .map(
                                  (a) => DropdownMenuItem<String>(
                                    value: a,
                                    child: Text(a),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (value) =>
                                setState(() => selectedActividad = value),
                        validator:
                            (value) =>
                                value == null
                                    ? 'Seleccione una actividad'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: AppColors.verdeLinea),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        tileColor: Colors.white,
                        title: Text(
                          selectedDate == null
                              ? 'Seleccione una fecha'
                              : 'Fecha seleccionada: ${selectedDate!.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(
                            color: AppColors.textoSecundario,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.calendar_today,
                          color: AppColors.verdeLinea,
                        ),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: _buildInputDecoration('Descripción'),
                        maxLines: 3,
                        onSaved: (value) => descripcion = value ?? '',
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Ingrese una descripción'
                                    : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: enviarTarea,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.boton,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Crear Tarea',
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
              ),
    );
  }
}

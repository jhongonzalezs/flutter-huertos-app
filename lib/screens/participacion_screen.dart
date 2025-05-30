import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/colors.dart';
import '../widgets/participation_card.dart';

class RegistroParticipacionScreen extends StatefulWidget {
  final String usuarioId;

  const RegistroParticipacionScreen({super.key, required this.usuarioId});

  @override
  State<RegistroParticipacionScreen> createState() =>
      _RegistroParticipacionScreenState();
}

class _RegistroParticipacionScreenState
    extends State<RegistroParticipacionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tiempoController = TextEditingController();
  String? _selectedTareaId;
  List<Map<String, dynamic>> _tareas = [];
  List<Map<String, dynamic>> _participaciones = [];
  Map<String, dynamic> _zonas = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTareas();
    _fetchParticipaciones();
    _fetchZonas();
  }

  @override
  void dispose() {
    _tiempoController.dispose();
    super.dispose();
  }

  Future<void> _fetchTareas() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('https://api-huertos.vercel.app/api/tareas/'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _tareas = data.cast<Map<String, dynamic>>().toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        _showError('Error al cargar tareas: Código ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Error al cargar tareas: $e');
    }
  }

  Future<void> _fetchZonas() async {
    try {
      final response = await http.get(
        Uri.parse('https://api-huertos.vercel.app/api/zonas/'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Zonas API Response: $data'); // Debug log
        setState(() {
          _zonas = {};
          for (var zona in data) {
            final id = zona['id']?.toString() ?? 'unknown';
            final nombre = zona['nombre']?.toString() ?? 'Zona desconocida';
            final tipoCultivo =
                zona['tipo_cultivo']?.toString() ?? 'Desconocido';
            _zonas[id] = {'nombre': nombre, 'tipo_cultivo': tipoCultivo};
          }
        });
      } else {
        _showError('Error al cargar zonas: Código ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error al cargar zonas: $e');
    }
  }

  Future<void> _fetchParticipaciones() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api-huertos.vercel.app/api/participaciones/${widget.usuarioId}',
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          _participaciones = List<Map<String, dynamic>>.from(
            jsonDecode(response.body),
          );
        });
      } else {
        setState(() {
          _participaciones = [];
        });
        _showError(
          'Error al cargar participaciones: Código ${response.statusCode}',
        );
      }
    } catch (e) {
      setState(() {
        _participaciones = [];
      });
      _showError('Error al cargar participaciones: $e');
    }
  }

  Future<void> _guardarRegistro() async {
    if (_formKey.currentState!.validate() && _selectedTareaId != null) {
      try {
        final response = await http.post(
          Uri.parse('https://api-huertos.vercel.app/api/participaciones/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'usuarioId': widget.usuarioId,
            'tareaId': _selectedTareaId,
            'horas': int.parse(_tiempoController.text),
          }),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Participación registrada con éxito')),
          );
          _tiempoController.clear();
          setState(() {
            _selectedTareaId = null;
          });
          await _fetchParticipaciones();
        } else {
          _showError(
            'Error al registrar participación: Código ${response.statusCode}',
          );
        }
      } catch (e) {
        _showError('Error al guardar: $e');
      }
    } else if (_selectedTareaId == null) {
      _showError('Por favor, selecciona una tarea');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Participación'),
        backgroundColor: AppColors.verdeLinea,
        centerTitle: true,
        elevation: 4,
        leading: const Icon(Icons.assignment_turned_in),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Usuario ID: ${widget.usuarioId}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _isLoading
                      ? const Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      )
                      : _tareas.isEmpty
                      ? const Center(
                        child: Text(
                          'No hay tareas disponibles',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                      : DropdownButtonFormField<String>(
                        value: _selectedTareaId,
                        decoration: InputDecoration(
                          labelText: 'Seleccionar Tipo de Actividad',
                          prefixIcon: const Icon(
                            Icons.task_alt,
                            color: Colors.green,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.verdeLinea,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.verdeLinea,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items:
                            _tareas.map((tarea) {
                              return DropdownMenuItem<String>(
                                value: tarea['id'],
                                child: Text(
                                  tarea['tipo_actividad'] ?? 'Sin tipo',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTareaId = value;
                          });
                        },
                        validator:
                            (value) =>
                                value == null ? 'Selecciona una tarea' : null,
                      ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _tiempoController,
                    decoration: InputDecoration(
                      labelText: 'Tiempo dedicado (horas)',
                      prefixIcon: const Icon(Icons.timer, color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.verdeLinea,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.verdeLinea,
                          width: 3,
                        ),

                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa el tiempo dedicado';
                      }
                      if (int.tryParse(value) == null ||
                          int.parse(value) <= 0) {
                        return 'Ingresa un número entero positivo';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _tareas.isEmpty ? null : _guardarRegistro,
                      icon: const Icon(Icons.save),
                      label: const Text(
                        'Guardar Registro',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textoSecundario,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.verdeLinea,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 48,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            Text(
              'Historial de Participaciones',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87.withOpacity(0.9),
              ),
            ),

            const SizedBox(height: 10),

            _participaciones.isEmpty
                ? const Center(
                  child: Text(
                    'No hay participaciones registradas',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                : Container(
                  height: 280,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _participaciones.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ParticipationCard(
                          participacion: _participaciones[index],
                          tareas: _tareas,
                          zonas: _zonas,
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

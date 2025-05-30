import 'package:flutter/material.dart';
import 'package:rubrica_corte_3_huertos/constants/colors.dart';

class ParticipationCard extends StatelessWidget {
  final Map<String, dynamic> participacion;
  final List<Map<String, dynamic>> tareas;
  final Map<String, dynamic> zonas;

  const ParticipationCard({
    super.key,
    required this.participacion,
    required this.tareas,
    required this.zonas,
  });

  @override
  Widget build(BuildContext context) {
    // Buscar la tarea correspondiente
    final tarea = tareas.firstWhere(
      (t) => t['id'] == participacion['tareaId'],
      orElse: () => {
        'tipo_actividad': 'Sin tipo',
        'zonaId': '',
        'descripcion': 'Tarea desconocida',
      },
    );

    // Extraer zona asociada a la tarea
    final zonaId = tarea['zonaId']?.toString() ?? '';
    final zonaData = zonas[zonaId] ?? {
      'nombre': 'Zona desconocida',
      'tipo_cultivo': 'Desconocido',
    };

    final tipoActividad = tarea['tipo_actividad'] ?? 'Sin tipo';
    final nombreZona = zonaData['nombre']?.toString() ?? 'Zona desconocida';
    final tipoCultivo = zonaData['tipo_cultivo']?.toString() ?? 'Desconocido';
    final horas = participacion['horas']?.toString() ?? '0';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: AppColors.lineaTitulo.withOpacity(0.6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tipoActividad,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text('Nombre de la Zona: $nombreZona'),
            const SizedBox(height: 4),
            Text('Tipo de Cultivo: $tipoCultivo'),
            const SizedBox(height: 4),
            Text('Horas: $horas'),
          ],
        ),
      ),
    );
  }
}

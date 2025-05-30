import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/colors.dart';

class EnvironmentalStatisticsScreen extends StatefulWidget {
  final String usuarioId;

  const EnvironmentalStatisticsScreen({Key? key, required this.usuarioId}) : super(key: key);

  @override
  _EnvironmentalStatisticsScreenState createState() => _EnvironmentalStatisticsScreenState();
}

class _EnvironmentalStatisticsScreenState extends State<EnvironmentalStatisticsScreen> {
  double totalHoras = 0;
  Map<String, double> horasPorActividad = {};
  bool isLoading = true;

  final List<Color> colorList = [
    Color(0xFF81C784), // Verde suave
    Color(0xFF64B5F6), // Azul
    Color(0xFFFFB74D), // Naranja
    Color(0xFFE57373), // Rojo claro
    Color(0xFFBA68C8), // Morado
    Color(0xFF4DB6AC), // Turquesa
  ];

  @override
  void initState() {
    super.initState();
    fetchParticipaciones();
  }

  Future<void> fetchParticipaciones() async {
    final url = Uri.parse('https://api-huertos.vercel.app/api/participaciones/${widget.usuarioId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        double horasTotales = 0;
        Map<String, double> actividadHoras = {};

        for (var item in data) {
          // Validate participation data
          if (item['horas'] == null || item['tareaId'] == null) continue;
          final horas = (item['horas'] as num?)?.toDouble() ?? 0;
          final tareaId = item['tareaId'] as String?;

          if (tareaId == null) continue;

          final tareaUrl = Uri.parse('https://api-huertos.vercel.app/api/tareas/$tareaId');
          final tareaResponse = await http.get(tareaUrl);
          if (tareaResponse.statusCode == 200) {
            final tareaData = json.decode(tareaResponse.body);
            final tipoActividad = tareaData['tipo_actividad'] as String? ?? 'Otro';
            actividadHoras[tipoActividad] = (actividadHoras[tipoActividad] ?? 0) + horas;
            horasTotales += horas;
          }
        }

        // Sort activities to ensure consistent color assignment
        final sortedHorasPorActividad = Map.fromEntries(
          actividadHoras.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
        );

        setState(() {
          totalHoras = horasTotales;
          horasPorActividad = sortedHorasPorActividad;
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar participaciones: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
        horasPorActividad = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoGeneral,
      appBar: AppBar(
        title: const Text('Estadísticas Ambientales'),
        backgroundColor: AppColors.verdeLinea,
        foregroundColor: AppColors.botonTexto,
        elevation: 3,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Horas Totales de Trabajo Comunitario',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.verdeTitulo,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${totalHoras.toStringAsFixed(1)} horas',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textoSecundario,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Distribución por Tipo de Actividad',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.verdeTitulo,
                    ),
                  ),
                  const SizedBox(height: 16),
                  horasPorActividad.isNotEmpty
                      ? PieChart(
                          dataMap: horasPorActividad,
                          animationDuration: const Duration(milliseconds: 1000),
                          chartRadius: MediaQuery.of(context).size.width * 0.7,
                          colorList: colorList.length >= horasPorActividad.length
                              ? colorList
                              : List.generate(
                                  horasPorActividad.length,
                                  (index) => colorList[index % colorList.length],
                                ),
                          chartType: ChartType.ring,
                          ringStrokeWidth: 30,
                          centerText: "Actividades",
                          legendOptions: const LegendOptions(
                            showLegends: true,
                            legendPosition: LegendPosition.bottom,
                            legendTextStyle: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValues: true,
                            showChartValuesInPercentage: true,
                            showChartValueBackground: false,
                            decimalPlaces: 1,
                          ),
                        )
                      : const Text('No hay datos para mostrar.'),
                ],
              ),
            ),
    );
  }
}
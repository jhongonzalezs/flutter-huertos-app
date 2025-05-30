import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';

class EnvironmentalEducationScreen extends StatelessWidget {
  const EnvironmentalEducationScreen({super.key});

  final List<Map<String, String>> contenidos = const [
    {
      'titulo': '¿Qué es la agricultura urbana?',
      'descripcion':
          'Descubre cómo cultivar alimentos en espacios reducidos y contribuir al desarrollo sostenible.',
      'imagen': 'assets/agricultura_urbana.png',
      'url': 'https://es.wikipedia.org/wiki/Agricultura_urbana'
    },
    {
      'titulo': 'Uso eficiente del agua',
      'descripcion':
          'Aprende técnicas para conservar agua en el riego de huertas urbanas.',
      'imagen': 'assets/agua.png',
      'url': 'https://eos.com/es/blog/uso-del-agua-en-agricultura/'
    },
    {
      'titulo': 'Taller: Compostaje casero',
      'descripcion':
          'Participa en nuestro taller el 15 de junio y aprende a convertir residuos en abono.',
      'imagen': 'assets/compostaje.png',
      'url': 'https://www.ecologiaverde.com/como-hacer-compost-casero-1989.html'
    },
    {
      'titulo': 'Charla: Agricultura vertical',
      'descripcion':
          'El 20 de junio, conoce cómo cultivar en estructuras verticales desde casa.',
      'imagen': 'assets/vertical.png',
      'url': 'https://www.sostenibilidad.com/medio-ambiente/como-hacer-huerto-vertical/'
    },
  ];

  Future<void> _abrirEnlace(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir el enlace: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoGeneral,
      appBar: AppBar(
        title: const Text('Educación Ambiental'),
        backgroundColor: AppColors.verdeLinea,
        foregroundColor: AppColors.botonTexto,
        elevation: 3,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: contenidos.length,
        itemBuilder: (context, index) {
          final item = contenidos[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: AppColors.tarjetaFondo,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.asset(
                        item['imagen']!,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.0),
                              Colors.black.withOpacity(0.4),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    item['titulo'] ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.verdeTitulo,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    item['descripcion'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textoSecundario,
                      height: 1.4,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () => _abrirEnlace(item['url']!),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Ver más'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.boton,
                        foregroundColor: AppColors.botonTexto,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

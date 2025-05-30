import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'bitacora_screen.dart';
import 'participacion_screen.dart';
import './Environmental_Education_Screen.dart';
import 'Environmental_statistics_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String nombre;
  final String zona;
  final String rol;
  final String diasDisponibles;
  final String usuarioId;

  const ProfileScreen({
    super.key,
    required this.nombre,
    required this.zona,
    required this.rol,
    required this.diasDisponibles,
    required this.usuarioId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo blanco por defecto
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
        backgroundColor: AppColors.verdeLinea,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.person, size: 100, color: AppColors.verdeLinea),
              const SizedBox(height: 24),
              Text(
                nombre,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.verdeTitulo,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                zona,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.textoSecundario,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Rol: $rol',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Días disponibles: $diasDisponibles',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
                softWrap: true,
              ),

              const SizedBox(height: 40),

              ElevatedButton.icon(
                icon: const Icon(Icons.assignment_turned_in),
                label: const Text('Registro de Participación'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.boton,
                  foregroundColor: AppColors.botonTexto,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              RegistroParticipacionScreen(usuarioId: usuarioId),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.history),
                label: const Text('Bitácora de Usuario'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.boton,
                  foregroundColor: AppColors.botonTexto,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BitacoraScreen(usuarioId: usuarioId),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.eco),
                label: const Text('Educación Ambiental'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.boton,
                  foregroundColor: AppColors.botonTexto,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EnvironmentalEducationScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.bar_chart),
                label: const Text('Estadísticas Ambiental'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.boton,
                  foregroundColor: AppColors.botonTexto,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => EnvironmentalStatisticsScreen(
                            usuarioId: usuarioId,
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

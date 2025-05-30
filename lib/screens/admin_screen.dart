import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'crear_zona_screen.dart';
import 'asignar_responsables_screen.dart';
import 'calendario_tareas_screen.dart';

class AdminScreen extends StatelessWidget {
  final String nombre;
  final String zona;
  final String rol;
  final String diasDisponibles;

  const AdminScreen({
    super.key,
    required this.nombre,
    required this.zona,
    required this.rol,
    required this.diasDisponibles,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoGeneral,
      appBar: AppBar(
        title: const Text('Panel de Administrador'),
        backgroundColor: AppColors.textoTitulo,
        foregroundColor: AppColors.botonTexto,
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Bienvenida
            Text(
              'Bienvenido, $nombre',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.verdeTitulo,
              ),
            ),
            const SizedBox(height: 20),

            /// Información personal
            _infoRow(Icons.admin_panel_settings, 'Rol', rol),
            _infoRow(Icons.place, 'Zona', zona),
            _infoRow(Icons.calendar_today, 'Días disponibles', diasDisponibles),
            
            const SizedBox(height: 30),
            Divider(color: AppColors.lineaTitulo, thickness: 2),
            const SizedBox(height: 20),

            /// Título de sección
            Text(
              'Funciones del Administrador',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textoSecundario,
              ),
            ),
            const SizedBox(height: 16),

            /// Opciones
            _actionButton(
              context,
              icon: Icons.park,
              label: 'Crear zona de cultivo',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CrearZonaScreen()),
              ),
            ),
            _actionButton(
              context,
              icon: Icons.person_add,
              label: 'Asignar responsables',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AsignarResponsablesScreen()),
              ),
            ),
            _actionButton(
              context,
              icon: Icons.calendar_month,
              label: 'Calendario de tareas',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarioTareasScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textoSecundario),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$label: $value',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textoSecundario,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.boton,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.botonTexto),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppColors.botonTexto,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

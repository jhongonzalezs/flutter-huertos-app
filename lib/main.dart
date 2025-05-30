import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'constants/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Participación',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.fondoGeneral,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.verdeLinea,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.verdeTitulo,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: AppColors.textoSecundario,
          ),
        ),
      ),
      initialRoute: AppRoutes.login,
      routes: AppRoutes.getRoutes(),
    );
  }
}
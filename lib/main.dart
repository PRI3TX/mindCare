// main.dart corregido
import 'package:flutter/material.dart';
import 'package:mindtrack_app/screens/login_screen.dart';
import 'package:provider/provider.dart';

import 'providers/rutina_provider.dart';
import 'providers/tratamiento_provider.dart';
import 'providers/dashboard_provider.dart';
import 'screens/home_screen.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RutinaProvider()),
        ChangeNotifierProvider(create: (_) => TratamientoProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindTrack',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        // MODIFICADO: Quitamos el 'double.infinity' global para evitar romper Rows horizontales
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ), // Cierre de ThemeData
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return auth.estaLogueado ? const HomeScreen() : const LoginScreen();
        },
      ), // Cierre del Consumer
    ); // Cierre del MaterialApp
  } // Cierre del método Widget build
} // Cierre de la clase MyApp 👈 Corregido: Removida la 'x' sobrante al final
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/rutina_provider.dart';
import 'providers/tratamiento_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 1. Inicializamos Autenticación primero
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        
        // 2. Inicializamos el Dashboard
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        
        // 🛠️ CORREGIDO: Cambiamos a ProxyProvider para inyectar dinámicamente el usuarioIdActual
        ChangeNotifierProxyProvider<AuthProvider, RutinaProvider>(
          create: (_) => RutinaProvider(usuarioIdActual: -1),
          update: (_, auth, __) => RutinaProvider(usuarioIdActual: auth.usuarioIdActual),
        ),
        
        // 🛠️ CORREGIDO: Lo mismo para Tratamientos
        ChangeNotifierProxyProvider<AuthProvider, TratamientoProvider>(
          create: (_) => TratamientoProvider(usuarioIdActual: -1),
          update: (_, auth, __) => TratamientoProvider(usuarioIdActual: auth.usuarioIdActual),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MindTrack',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
              useMaterial3: true,
            ),
            home: auth.isLoggedIn ? const HomeScreen() : const LoginScreen(),
          );
        },
      ),
    );
  }
}
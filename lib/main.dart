import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/rutina_provider.dart';
import 'providers/tratamiento_provider.dart';
import 'providers/dashboard_provider.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RutinaProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => TratamientoProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => DashboardProvider(),
        ),
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

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),

        scaffoldBackgroundColor:
            const Color(0xFFF5F7FA),

        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),

        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16),
          ),
        ),

        elevatedButtonTheme:
            ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize:
                const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),
        ),
      ),

      home: const HomeScreen(),
    );
  }
}
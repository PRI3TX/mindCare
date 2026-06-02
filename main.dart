import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mindtrack_app/providers/rutina_provider.dart';
import 'package:mindtrack_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RutinaProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MindTrack',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
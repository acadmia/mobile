import 'package:flutter/material.dart';

void main() {
  runApp(const GymApp());
}

class GymApp extends StatelessWidget {
  const GymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Academia',
      theme: ThemeData.dark(), // Espaço para o nosso futuro Design System Bordô
      home: const Scaffold(
        body: Center(
          child: Text('Setup Inicial Completo! (Pronto para TDD)'),
        ),
      ),
    );
  }
}

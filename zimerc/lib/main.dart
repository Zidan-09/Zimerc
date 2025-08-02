import 'package:flutter/material.dart';
import 'screens/home_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomeController(),
    );
  }
}
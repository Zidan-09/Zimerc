import 'package:flutter/material.dart';
import 'screens/register_user_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RegisterUserScreen(),
    );
  }
}
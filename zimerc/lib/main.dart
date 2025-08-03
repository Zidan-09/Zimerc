import 'package:flutter/material.dart';
import 'screens/home_controller.dart';
import 'utils/db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalDatabase().database;
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zimerc',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomeController(),
    );
  }
}
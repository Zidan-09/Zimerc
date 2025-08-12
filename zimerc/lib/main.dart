// lib/main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart'; // <-- adicione
import 'screens/general/home_controller.dart';
import 'screens/welcome_screen.dart';
import 'screens/user/login/login_screen.dart';
import 'utils/db.dart';
import 'services/session.dart';
import 'providers/cart_provider.dart'; // <-- adicione (caminho conforme seu projeto)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalDatabase().database;
  await Session().loadFromPrefs();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _decideStartScreen() async {
    final prefs = await SharedPreferences.getInstance();

    final hasSeenWelcome = prefs.getBool('has_seen_welcome') ?? false;
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      return const HomeController();
    } else if (!hasSeenWelcome) {
      return const WelcomeScreen();
    } else {
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zimerc',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FutureBuilder<Widget>(
        future: _decideStartScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            return snapshot.data!;
          }
        },
      ),
    );
  }
}
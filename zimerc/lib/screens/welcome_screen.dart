import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user/login/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Future<void> _setHasSeenWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_welcome', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Bem-vindo à Zimerc',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  final ctx = context;
                  await _setHasSeenWelcome();

                  if (!mounted) return;

                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(
                      content: Text('Fluxo de cadastro ainda não implementado'),
                    ),
                  );
                },
                child: const Text('Próximo'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  final ctx = context; // captura antes do await
                  await _setHasSeenWelcome();

                  if (!mounted) return;

                  Navigator.pushReplacement(
                    ctx,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text('Já tenho cadastro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
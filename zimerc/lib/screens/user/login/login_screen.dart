import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/login_service.dart';
import '../../general/home_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final LoginService _loginService = LoginService();

  bool _isLoading = false;
  String? _message;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    final result = await _loginService.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return; // Protege o uso do context após await

    setState(() {
      _isLoading = false;
      if (result['success'] == true) {
        _message = 'Login realizado com sucesso!';
        _saveTokenAndNavigate(result['data']);
      } else {
        _message = result['message'] ?? 'Erro desconhecido';
      }
    });
  }

  Future<void> _saveTokenAndNavigate(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);

    if (!mounted) return; // Protege o uso do context

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeController()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Text('Entrar'),
                  ),
            const SizedBox(height: 20),
            if (_message != null)
              Text(
                _message!,
                style: TextStyle(
                  color: _message == 'Login realizado com sucesso!'
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

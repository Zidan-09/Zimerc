import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'services/login_service.dart';
import '../../general/home_controller.dart';
import '../../../services/session.dart';

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

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      dynamic data = result['data'];
      String? token;
      
      token = data;

      if (token == null || token.isEmpty) {
        setState(() {
          _message = 'Erro: token de autenticação ausente.';
        });
        return;
      }

      String? userId;
      String? userType;
      try {
        final payload = Jwt.parseJwt(token);
        userId = payload['user_id']?.toString();
        userType = payload['user_type']?.toString();
      } catch (e) {
        debugPrint('JWT decode falhou: $e');
      }

      await Session().setFromLogin(
        tokenValue: token,
        userIdValue: userId,
        userTypeValue: userType,
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeController()),
        (route) => false,
      );
    } else {
      setState(() {
        _message = result['message'] ?? 'Erro desconhecido';
      });
    }
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
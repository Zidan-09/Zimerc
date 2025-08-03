import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String baseUrl;

  LoginService({required this.baseUrl});

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Resposta OK
      final data = jsonDecode(response.body);
      return {
        'success': true,
        'token': data['token'],
        'user_id': data['user_id'],
        'user_type': data['user_type'],
      };
    } else {
      // Erro de autenticação ou outro
      return {
        'success': false,
        'message': 'Falha ao fazer login. Verifique suas credenciais.',
      };
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl;

  AuthService({required this.baseUrl});

  Future<void> register({
    required Map<String, dynamic> user,
    Map<String, dynamic>? company,
  }) async {
    final url = Uri.parse('$baseUrl/user/register');

    final body = {
      'user': user,
      if (company != null) 'company': company,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print('Resposta da API: ${response.body}');
    
    if (response.statusCode != 201) {
      throw Exception('Erro: ${response.body}');
    }
  }
}
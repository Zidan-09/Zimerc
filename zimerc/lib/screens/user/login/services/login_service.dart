import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  LoginService();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('http://100.103.165.109:3333/user/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'success': true,
        'message': data['message'],
        'data': data['data']
      };
    } else {
      final data = jsonDecode(response.body);
      return {
        'success': false,
        'message': data['message'],
      };
    }
  }
}
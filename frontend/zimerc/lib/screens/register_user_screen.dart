import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_company_screen.dart';

class RegisterUserScreen extends StatefulWidget {
  final String? companyId;

  const RegisterUserScreen({this.companyId, super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService(baseUrl: 'https://localhost:3333');

  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedUserType = 'AMBULANT'; // Padrão

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Preencha o email';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return 'Email inválido';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Preencha a senha';
    if (value.length < 8) return 'Senha deve ter ao menos 8 caracteres';
    return null;
  }

  Future<void> _nextOrRegister() async {
    if (_formKey.currentState!.validate()) {
      final userData = {
        'name': _nameController.text,
        'cpf': _cpfController.text,
        'dob': _dobController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'user_type': _selectedUserType,
      };

      if (widget.companyId != null) {
        userData['company_id'] = widget.companyId!;
      }

      if (_selectedUserType == 'OWNER') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterCompanyScreen(userData: userData),
          ),
        );
      } else {
        try {
          await _authService.register(user: userData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cadastro realizado!')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro Usuário')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Preencha o nome' : null,
              ),
              TextFormField(
                controller: _cpfController,
                decoration: InputDecoration(labelText: 'CPF'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Preencha o CPF' : null,
              ),
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(labelText: 'Data de Nascimento (YYYY-MM-DD)'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Preencha a data' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: _validatePassword,
              ),
              DropdownButtonFormField<String>(
                value: _selectedUserType,
                items: [
                  DropdownMenuItem(value: 'AMBULANT', child: Text('Ambulante')),
                  DropdownMenuItem(value: 'OWNER', child: Text('Dono de empresa')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedUserType = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Tipo de conta'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _nextOrRegister,
                child: Text('Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
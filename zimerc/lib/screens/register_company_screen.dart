import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterCompanyScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const RegisterCompanyScreen({required this.userData, super.key});

  @override
  State<RegisterCompanyScreen> createState() => _RegisterCompanyScreenState();
}

class _RegisterCompanyScreenState extends State<RegisterCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService(baseUrl: 'https://localhost:3333');

  final _companyNameController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _contactController = TextEditingController();
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();

  Future<void> _registerFull() async {
    if (_formKey.currentState!.validate()) {
      final companyData = {
        'name': _companyNameController.text,
        'cnpj': _cnpjController.text,
        'contact': _contactController.text,
        'country': _countryController.text,
        'state': _stateController.text,
        'city': _cityController.text,
        'street': _streetController.text,
        'number': int.tryParse(_numberController.text) ?? 0,
      };

      try {
        await _authService.register(
          user: widget.userData,
          company: companyData,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cadastro completo realizado!')),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro Empresa')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _companyNameController,
                decoration: InputDecoration(labelText: 'Nome da empresa'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Preencha o nome da empresa' : null,
              ),
              TextFormField(
                controller: _cnpjController,
                decoration: InputDecoration(labelText: 'CNPJ'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Preencha o CNPJ' : null,
              ),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: 'Contato'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Preencha o contato' : null,
              ),
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(labelText: 'País'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Preencha o país' : null,
              ),
              TextFormField(
                controller: _stateController,
                decoration: InputDecoration(labelText: 'Estado'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Preencha o estado' : null,
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'Cidade'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Preencha a cidade' : null,
              ),
              TextFormField(
                controller: _streetController,
                decoration: InputDecoration(labelText: 'Rua'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Preencha a rua' : null,
              ),
              TextFormField(
                controller: _numberController,
                decoration: InputDecoration(labelText: 'Número'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Preencha o número' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerFull,
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
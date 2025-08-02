import 'package:flutter/material.dart';

class ExtrasMenu extends StatelessWidget {
  const ExtrasMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.settings, color: Colors.white),
          title: const Text('Configurações', style: TextStyle(color: Colors.white)),
          onTap: () {
            // TODO: Navegar para tela de Configurações
          },
        ),
        ListTile(
          leading: const Icon(Icons.account_circle, color: Colors.white),
          title: const Text('Conta', style: TextStyle(color: Colors.white)),
          onTap: () {
            // TODO: Navegar para tela de Conta
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline, color: Colors.white),
          title: const Text('Sobre', style: TextStyle(color: Colors.white)),
          onTap: () {
            // TODO: Mostrar informações do app
          },
        ),
      ],
    );
  }
}

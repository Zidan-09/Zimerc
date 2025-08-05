import 'package:flutter/material.dart';
import '../../../../utils/constants.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final String nome;
  final double preco;
  final NumberFormat currencyFormatter;

  const ProductCard({
    super.key,
    required this.nome,
    required this.preco,
    required this.currencyFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          children: [
            // Nome do produto
            Expanded(
              child: Text(
                nome,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),

            // Preço formatado
            Text(
              currencyFormatter.format(preco),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
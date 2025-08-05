// lib/screens/general/products/widgets/product_cards.dart
import 'package:flutter/material.dart';
import '../../../../utils/constants.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final String nome;
  final double preco;
  final NumberFormat currencyFormatter;
  final bool selected;
  final VoidCallback? onTap; // usado para seleção

  const ProductCard({
    super.key,
    required this.nome,
    required this.preco,
    required this.currencyFormatter,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Cor do card: vermelho se selecionado, senão cor primária
    final bgColor = selected ? Colors.red : AppColors.primary.withOpacity(0.9);
    final textColor = Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: selected ? 6 : 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            children: [
              // Nome do produto
              Expanded(
                child: Text(
                  nome,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),

              // Preço formatado
              Text(
                currencyFormatter.format(preco),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),

              // pequeno check quando selecionado
              if (selected) ...[
                const SizedBox(width: 12),
                const Icon(Icons.check_circle, color: Colors.white),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../../utils/constants.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final String nome;
  final double preco;
  final NumberFormat currencyFormatter;
  final bool selected;
  final VoidCallback? onTap;  

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

              Text(
                currencyFormatter.format(preco),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),

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
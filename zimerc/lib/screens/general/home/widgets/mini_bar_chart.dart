import 'package:flutter/material.dart';
import '../../../../../utils/constants.dart';

class MiniBarChart extends StatelessWidget {
  final List<int> vendasPorDia;
  final List<String> diasSemana;

  const MiniBarChart({
    super.key,
    required this.vendasPorDia,
    required this.diasSemana,
  });

  @override
  Widget build(BuildContext context) {
    final maxVenda =
        vendasPorDia.isEmpty ? 1 : vendasPorDia.reduce((a, b) => a > b ? a : b);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        final vendas = index < vendasPorDia.length ? vendasPorDia[index] : 0;
        final barHeight = 60 * ((vendas > 0 ? vendas : 0.5) / maxVenda);

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              vendas.toString(),
              style: const TextStyle(fontSize: 12),
            ),
            Container(
              width: 12,
              height: barHeight,
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Text(
              diasSemana[index],
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }),
    );
  }
}
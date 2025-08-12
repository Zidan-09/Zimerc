import 'package:flutter/material.dart';
import '../../../../../utils/constants.dart';

class MiniBarChart extends StatefulWidget {
  final List<int> vendasPorDia;
  final List<String> diasSemana;

  const MiniBarChart({
    super.key,
    required this.vendasPorDia,
    required this.diasSemana,
  });

  @override
  State<MiniBarChart> createState() => _AnimatedMiniBarChartState();
}

class _AnimatedMiniBarChartState extends State<MiniBarChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxVenda = widget.vendasPorDia.isEmpty
        ? 1
        : widget.vendasPorDia.reduce((a, b) => a > b ? a : b);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            final vendas = index < widget.vendasPorDia.length
                ? widget.vendasPorDia[index]
                : 0;
            final targetHeight = 60 * ((vendas > 0 ? vendas : 0.5) / maxVenda);
            final barHeight = targetHeight * _animation.value;

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
                  widget.diasSemana[index],
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
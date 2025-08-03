import 'package:flutter/material.dart';
import '../../../../utils/constants.dart';
import 'widgets/mini_bar_chart.dart';
import 'widgets/last_sell_panel.dart';
import 'widgets/mini_map_shortcut.dart';
import 'utils/helpers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> itensVendidos = [
      {'nome': 'Pastel de Queijo', 'valor': 10.00},
      {'nome': 'Pastel de Frango', 'valor': 10.00},
      {'nome': 'Suco de Acerola', 'valor': 5.00},
    ];
    final double valorTotal = 25.00;
    final String horario = '14:37';
    final String metodoPagamento = 'Dinheiro';

    final List<int> vendasPorDia = [5, 12, 9, 7, 10];
    final List<String> diasSemanaMostrados = HomeHelpers.getUltimos5Dias();
    final int metaDiaria = 20;
    final int vendasHoje = 10;
    final double progressoMeta = vendasHoje / metaDiaria;

    return Padding(
      padding: const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Frase motivacional
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              HomeHelpers.fraseMotivacional("Samuel", progressoMeta),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Meta de vendas
          Text(
            'Meta de vendas $vendasHoje/$metaDiaria',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progressoMeta,
              minHeight: 12,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),

          const SizedBox(height: 24),

          // Painel Última Venda
          UltimaVendaPanel(
            itensVendidos: itensVendidos,
            valorTotal: valorTotal,
            horario: horario,
            metodoPagamento: metodoPagamento,
          ),

          const SizedBox(height: 12),

          // Linha com gráfico + atalho do mapa
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 180,
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            '📊 Vendas da Semana',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MiniBarChart(
                                vendasPorDia: vendasPorDia,
                                diasSemana: diasSemanaMostrados,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(
                  height: 180,
                  child: MiniMapShortcut(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
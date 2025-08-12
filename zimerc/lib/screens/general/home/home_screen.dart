import 'package:flutter/material.dart';
import '../../../../utils/constants.dart';
import 'widgets/mini_bar_chart.dart';
import 'widgets/last_sell_panel.dart';
import 'widgets/mini_map_shortcut.dart';
import 'utils/helpers.dart';
import '../../../services/sale_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<Map<String, dynamic>> _loadData() async {
    final saleService = SaleService();

    final lastSale = await saleService.getLastSale();
    final salesPerDay = await saleService.getSalesPerDay();

    return {
      "lastSale": lastSale,
      "salesPerDay": salesPerDay,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Erro: ${snapshot.error}"));
        }

        final data = snapshot.data!;
        final lastSale = data["lastSale"] as List<Map<String, dynamic>>;
        final salesPerDay = data["salesPerDay"] as List<Map<String, dynamic>>;

        // Configurações fixas (exemplo)
        final diasSemanaMostrados = HomeHelpers.getUltimos5Dias();
        const int metaDiaria = 20;
        const int vendasHoje = 10;
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
              if (lastSale.isEmpty)
                Container(
                  width: 400,
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Nenhuma venda cadastrada",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              else
                UltimaVendaPanel(
                  itensVendidos: [
                    // Aqui você vai adaptar para buscar itens reais dessa venda
                    {"nome": "Produto Exemplo", "valor": 10.0}
                  ],
                  valorTotal: 10.0,
                  horario: "14:37",
                  metodoPagamento: "Dinheiro",
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
                                    vendasPorDia: salesPerDay
                                        .map((e) => e['total_sales'] as int)
                                        .toList(),
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
      },
    );
  }
}
class HomeHelpers {
  static List<String> getDiasSemana() {
    return ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab'];
  }

  static List<String> getUltimos5Dias() {
    final dias = getDiasSemana();
    final hoje = DateTime.now().weekday;

    int indexHoje = hoje == 7 ? 0 : hoje;

    List<String> ultimos5 = [];
    for (int i = 4; i >= 0; i--) {
      int index = (indexHoje - i) % 7;
      if (index < 0) index += 7;
      ultimos5.add(dias[index]);
    }
    return ultimos5;
  }

  static String fraseMotivacional(String nome, double progresso) {
    if (progresso >= 1) {
      return "🎉 Parabéns, $nome! Você atingiu sua meta de vendas de hoje com muito esforço e dedicação! Continue brilhando e conquistando novos clientes todos os dias! 🚀✨";
    } else if (progresso >= 0.75) {
      return "🔥 Quase lá, $nome! Falta pouco para bater sua meta do dia. Continue vendendo com esse ritmo e mostre toda sua garra! 💪🚀";
    } else if (progresso >= 0.5) {
      return "💡 Você está indo bem, $nome! Já chegou na metade da meta diária, mantenha o foco para conquistar ainda mais vendas e novos clientes! 🌟💪";
    } else {
      return "🚀 Vamos em frente, $nome! Ainda há muito tempo para alcançar sua meta de hoje. Confie no seu potencial, ofereça o melhor atendimento e faça acontecer! ✨🙌";
    }
  }
}
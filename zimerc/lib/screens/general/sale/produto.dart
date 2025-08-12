class Produto {
  final int productId;
  final String nome;
  final double valor;

  Produto({
    required this.productId,
    required this.nome,
    required this.valor,
  });

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      productId: map['product_id'],
      nome: map['name'] ?? '',
      valor: map['unit_price'] is int
          ? (map['unit_price'] as int).toDouble()
          : (map['unit_price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
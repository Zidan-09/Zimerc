// lib/services/product_service.dart
import 'package:sqflite/sqflite.dart';
import '../utils/db.dart';

class ProductService {
  final LocalDatabase _localDb = LocalDatabase();

  /// Retorna lista de produtos do banco.
  /// Cada item é um map com keys compatíveis com sua UI:
  /// - 'name' (String)
  /// - 'unit_price' (double)
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final Database db = await _localDb.database;
    final rows = await db.query(
      'product',
      columns: ['product_id', 'id_server', 'name', 'stock_quantity', 'unit_price', 'company_id', 'user_id', 'is_synced'],
      orderBy: 'name COLLATE NOCASE ASC',
    );

    // Normalizar/garantir tipos
    final List<Map<String, dynamic>> mapped = rows.map((r) {
      return {
        'product_id': r['product_id'],
        'id_server': r['id_server'],
        'name': r['name'] ?? '',
        'stock_quantity': r['stock_quantity'],
        'unit_price': (r['unit_price'] is int) ? (r['unit_price'] as int).toDouble() : (r['unit_price'] as num?)?.toDouble() ?? 0.0,
        'company_id': r['company_id'],
        'user_id': r['user_id'],
        'is_synced': r['is_synced'],
      };
    }).toList();

    return mapped;
  }
}
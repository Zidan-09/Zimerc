// lib/services/product_service.dart
import 'package:sqflite/sqflite.dart';
import '../utils/db.dart';

class ProductService {
  final LocalDatabase _localDb = LocalDatabase();

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final Database db = await _localDb.database;
    final rows = await db.query(
      'product',
      columns: [
        'product_id',
        'id_server',
        'name',
        'stock_quantity',
        'unit_price',
        'company_id',
        'user_id',
        'is_synced'
      ],
      orderBy: 'name COLLATE NOCASE ASC',
    );

    return rows.map((r) {
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
  }

  Future<int> addProduct(Map<String, dynamic> product) async {
    final Database db = await _localDb.database;
    final toInsert = Map<String, dynamic>.from(product)..removeWhere((k, v) => v == null);
    final id = await db.insert('product', toInsert);
    return id;
  }

  /// Deleta produto por product_id
  Future<int> deleteProduct(int productId) async {
    final Database db = await _localDb.database;
    return await db.delete('product', where: 'product_id = ?', whereArgs: [productId]);
  }
}
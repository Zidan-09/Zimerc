import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../utils/db.dart';

class SaleService {
  final LocalDatabase _localDb = LocalDatabase();

  Future<List<Map<String, dynamic>>> getLastSale() async {
    final db = await _localDb.database;
    final result = await db.query(
      'sale',
      orderBy: 'sale_date DESC',
      limit: 1,
    );

    debugPrint("📦 Última venda (raw): ${jsonEncode(result)}");
    return result.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<List<Map<String, dynamic>>> getSalesPerDay() async {
    final db = await _localDb.database;
    final result = await db.rawQuery('''
      SELECT 
        substr(sale_date, 1, 10) AS date, 
        COUNT(*) AS total_sales
      FROM sale
      GROUP BY date
      ORDER BY date ASC
    ''');

    debugPrint("📊 Vendas por dia (raw): ${jsonEncode(result)}");
    return result.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<int> addSale(Map<String, dynamic> sale) async {
    final db = await _localDb.database;
    final toInsert = Map<String, dynamic>.from(sale)
      ..removeWhere((k, v) => v == null);

    final insertedId = await db.insert('sale', toInsert);
    debugPrint("✅ Venda adicionada: ID $insertedId");
    return insertedId;
  }

  Future<int> addSaleWithProducts({
    required Map<String, dynamic> sale,
    required List<Map<String, dynamic>> produtos,
  }) async {
    final db = await _localDb.database;
    return await db.transaction((txn) async {
      final saleToInsert = Map<String, dynamic>.from(sale)
        ..removeWhere((k, v) => v == null);

      final saleId = await txn.insert('sale', saleToInsert);

      for (final produto in produtos) {
        final saleProduct = {
          'sale_id': saleId,
          'product_id': produto['product_id'],
          'quantity': produto['quantity'] ?? 1,
          'unit_price': produto['unit_price'] ?? 0.0,
          'is_synced': 0,
          'id_server': null,
        };
        await txn.insert('sale_product', saleProduct);
      }

      return saleId;
    });
  }
}
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();

  factory LocalDatabase() => _instance;

  LocalDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'zimerc.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Cria todas as tabelas
    await db.execute('''
      CREATE TABLE company (
        company_id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        cnpj TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user (
        user_id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        cpf TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        user_type TEXT NOT NULL,
        company_id INTEGER,
        FOREIGN KEY (company_id) REFERENCES company(company_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE product (
        product_id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_server INTEGER,
        name TEXT NOT NULL,
        stock_quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        company_id INTEGER,
        user_id INTEGER,
        is_synced INTEGER DEFAULT 0,
        FOREIGN KEY (company_id) REFERENCES company(company_id),
        FOREIGN KEY (user_id) REFERENCES user(user_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE sale (
        sale_id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_server INTEGER,
        company_id INTEGER,
        user_id INTEGER,
        sale_date TEXT NOT NULL,
        total_amount REAL NOT NULL,
        latitude REAL,
        longitude REAL,
        is_synced INTEGER DEFAULT 0,
        FOREIGN KEY (company_id) REFERENCES company(company_id),
        FOREIGN KEY (user_id) REFERENCES user(user_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE sale_product (
        sale_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        id_server INTEGER,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        is_synced INTEGER DEFAULT 0,
        PRIMARY KEY (sale_id, product_id),
        FOREIGN KEY (sale_id) REFERENCES sale(sale_id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implementar atualizações futuras de banco aqui
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
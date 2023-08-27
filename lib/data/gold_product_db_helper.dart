import 'package:kuyumcu_stok/models/stock_gold_product.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class GoldProductDbHelper {
  static final GoldProductDbHelper _instance = GoldProductDbHelper._internal();

  factory GoldProductDbHelper() {
    return _instance;
  }

  GoldProductDbHelper._internal();

  Database? _db;

  late List<StockGoldProduct> products;

  String tableName = "product_golds";

  Future<void> open() async {
    products = [];
    sqfliteFfiInit();

    String path = 'kuyumcu.db';
    _db = await databaseFactoryFfi.openDatabase(path);
    //await _db!.execute('DROP TABLE product_golds');
    await _createTable();
  }

  Future<void> _createTable() async {
    await _db!.execute('''
      CREATE TABLE IF NOT EXISTS product_golds (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        barcodeText TEXT NOT NULL,
        enteredDate TEXT NOT NULL,
        soldDate TEXT,
        name TEXT NOT NULL,
        isSold INTEGER NOT NULL,
        carat INTEGER NOT NULL,
        purityRate DECIMAL NOT NULL,
        laborCost DECIMAL NOT NULL,
        gram DECIMAL NOT NULL,
        cost DECIMAL NOT NULL,
        costPrice DECIMAL,
        soldPrice DECIMAL,
        earnedProfit DECIMAL
      )
    ''');
  }

  Future<void> close() async {
    await _db!.close();
  }

  Future<int> insert(Map<String, dynamic> data) async {
    if (_db == null) {
      throw Exception("Database is not open.");
    }

    return await _db!.insert(tableName, data);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db!.query(tableName);
  }

  Future<List<Map<String, dynamic>>> querySoldRows() async {
    return await _db!.query(
      tableName,
      where: 'isSold = ?',
      whereArgs: [1],
    );
  }

  Future<List<Map<String, dynamic>>> queryNotSoldRows() async {
    return await _db!.query(
      tableName,
      where: 'isSold = ?',
      whereArgs: [0],
    );
  }

  Future<Map<String, dynamic>?> getProductById(int id) async {
    final List<Map<String, dynamic>> results = await _db!.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    }

    return null;
  }

  Future<Map<String, dynamic>?> getProductByBarcodeText(
      String barcodeText) async {
    final List<Map<String, dynamic>> results = await _db!.query(
      tableName,
      where: 'barcodeText = ?',
      whereArgs: [barcodeText],
    );

    if (results.isNotEmpty) {
      return results.first;
    }

    return null;
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    return await _db!.update(tableName, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    return await _db!.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}

import 'package:kuyumcu_stok/models/product_diamond.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ProductDiamondDbHelper {
  static final ProductDiamondDbHelper _instance = ProductDiamondDbHelper._internal();

  factory ProductDiamondDbHelper() {
    return _instance;
  }

  ProductDiamondDbHelper._internal();

  late Database _db;

  late List<ProductDiamond> products;

  String tableName = "product_diamonds";

  Future<void> open() async {
    products = [];
    sqfliteFfiInit();

    // Path to your database file
    String path = 'kuyumcu.db';

    _db = await databaseFactoryFfi.openDatabase(path);
    await _createTable();
  }

  Future<void> _createTable() async {
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS product_diamonds (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        barcodeText TEXT NOT NULL,
        name TEXT,
        gram DECIMAL NOT NULL,
        price DECIMAL NOT NULL,
      )
    ''');
  }

  Future<void> close() async {
    // Close the database
    await _db.close();
  }

  Future<int> insert(Map<String, dynamic> data) async {

    return await _db.insert(tableName, data);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(tableName);
  }

  Future<Map<String, dynamic>?> getProductById(int id) async {
    final List<Map<String, dynamic>> results = await _db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    }

    return null;
  }

  Future<Map<String, dynamic>?> getProductByBarcodeText(String barcodeText) async {
    final List<Map<String, dynamic>> results = await _db.query(
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
    return await _db.update(tableName, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    return await _db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

}
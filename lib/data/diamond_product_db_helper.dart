import 'package:kuyumcu_stok/models/diamond_product.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DiamondProductDbHelper {
  static final DiamondProductDbHelper _instance = DiamondProductDbHelper._internal();

  factory DiamondProductDbHelper() {
    return _instance;
  }

  DiamondProductDbHelper._internal();

  late Database _db;

  late List<DiamondProduct> products;

  String tableName = "product_diamonds";

  Future<void> open() async {
    products = [];
    sqfliteFfiInit();

    String path = 'kuyumcu.db';

    _db = await databaseFactoryFfi.openDatabase(path);
    //await _db.execute('DROP TABLE product_diamonds');
    await _createTable();
  }

  Future<void> _createTable() async {
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS product_diamonds (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        barcodeText TEXT NOT NULL,
        name TEXT,
        gram DECIMAL NOT NULL,
        price DECIMAL NOT NULL
      )
    ''');
  }

  Future<void> close() async {
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
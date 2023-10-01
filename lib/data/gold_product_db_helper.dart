import 'dart:io' as io;
import 'package:path/path.dart' as p;
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kuyumcu_stok/model/gold_product.dart';

class GoldProductDbHelper {
  static final GoldProductDbHelper _instance = GoldProductDbHelper._internal();

  factory GoldProductDbHelper() {
    return _instance;
  }

  GoldProductDbHelper._internal();

  late Database _db;
  late List<GoldProduct> products;

  // String dbName = 'kuyumcu_stok_takibi.db';
  String tableName = "gold_products";


  Future<void> open() async {
    products = [];
    final io.Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String dbPath = p.join(appDocumentsDir.path, "databases", "kuyumcu_stok_takibi.db");

    _db = await databaseFactory.openDatabase(dbPath);

    print("Path: $dbPath");

    // await _db.execute('DROP TABLE gold_products');
    await _createTable();

    await GoldProductDbHelper().queryAllRows().then((value) {
      for (int i = 0; i < value.length; i++) {
        GoldProductDbHelper()
            .products
            .add(GoldProduct.fromJson(value[i], value[i]['id']));
      }
    });
  }

  Future<void> _createTable() async {
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS gold_products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        barcodeText TEXT NOT NULL,
        piece INTEGER NOT NULL,
        name TEXT NOT NULL,
        carat INTEGER NOT NULL,
        purityRate DECIMAL NOT NULL,
        laborCost DECIMAL NOT NULL,
        gram DECIMAL NOT NULL,
        cost DECIMAL NOT NULL,
        salesGrams DECIMAL NOT NULL
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

  Future<List<Map<String, dynamic>>> querySoldRows() async {
    return await _db.query(
      tableName,
      where: 'isSold = ?',
      whereArgs: [1],
    );
  }

  Future<List<Map<String, dynamic>>> queryNotSoldRows() async {
    return await _db.query(
      tableName,
      where: 'isSold = ?',
      whereArgs: [0],
    );
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

  Future<Map<String, dynamic>?> getProductByBarcodeText(
      String barcodeText) async {
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

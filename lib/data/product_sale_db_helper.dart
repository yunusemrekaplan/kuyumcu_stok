import 'dart:io' as io;
import 'package:path/path.dart' as p;
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kuyumcu_stok/model/product_sale.dart';

class ProductSaleDbHelper {
  static final ProductSaleDbHelper _instance = ProductSaleDbHelper._internal();

  factory ProductSaleDbHelper() {
    return _instance;
  }

  ProductSaleDbHelper._internal();

  late Database _db;
  late List<ProductSale> sales;

  // String dbName = 'kuyumcu_stok_takibi.db';
  String tableName = "product_sales";

  Future<void> open() async {
    sales = [];
    final io.Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String dbPath = p.join(appDocumentsDir.path, "databases", "kuyumcu_stok_takibi.db");

    _db = await databaseFactory.openDatabase(dbPath);
    // await _db.execute('DROP TABLE product_sales');
    await _createTable();
    await ProductSaleDbHelper().queryAllRows().then((value) {
      for (int i = 0; i < value.length; i++) {
        ProductSaleDbHelper()
            .sales
            .add(ProductSale.fromJson(value[i], value[i]['id']));
      }
    });
  }

  Future<void> _createTable() async {
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS product_sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product TEXT NOT NULL,
        soldDate TEXT NOT NULL,
        piece INTEGER NOT NULL,
        costPrice DECIMAL NOT NULL,
        soldPrice DECIMAL NOT NULL,
        soldGram DECIMAL NOT NULL,
        earnedProfitTL DECIMAL NOT NULL,
        earnedProfitGram DECIMAL NOT NULL
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

  Future<Map<String, dynamic>?> getProductSaleById(int id) async {
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

  Future<int> update(Map<String, dynamic> data, int id) async {
    return await _db.update(tableName, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    return await _db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

}
import 'package:kuyumcu_stok/model/product_sale.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ProductSaleDbHelper {
  static final ProductSaleDbHelper _instance = ProductSaleDbHelper._internal();

  factory ProductSaleDbHelper() {
    return _instance;
  }

  ProductSaleDbHelper._internal();

  late Database _db;
  late List<ProductSale> sales;

  String path = 'kuyumcu.db';
  String tableName = "product_sales";

  Future<void> open() async {
    sales = [];
    sqfliteFfiInit();

    _db = await databaseFactoryFfi.openDatabase(path);
    //await _db.execute('DROP TABLE product_sales');
    await _createTable();
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
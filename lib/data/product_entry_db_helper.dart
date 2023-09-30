import 'dart:io';

import 'package:kuyumcu_stok/model/product_entry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ProductEntryDbHelper {
  static final ProductEntryDbHelper _instance = ProductEntryDbHelper._internal();

  factory ProductEntryDbHelper() {
    return _instance;
  }

  ProductEntryDbHelper._internal();

  late Database _db;
  late List<ProductEntry> entries;


  String dbName = 'kuyumcu.db';
  late String path;
  String tableName = "product_entries";

  Future<void> open() async {
    Directory directory = await getApplicationDocumentsDirectory();

    path = '${directory.path}/$dbName';

    entries = [];

    _db = await databaseFactoryFfi.openDatabase(dbName);
    //await _db.execute('DROP TABLE product_entries');
    await _createTable();

    await ProductEntryDbHelper().queryAllRows().then((value) {
      for (int i = 0; i < value.length; i++) {
        ProductEntryDbHelper()
            .entries
            .add(ProductEntry.fromJson(value[i], value[i]['id']));
      }
    });
  }

  Future<void> _createTable() async {
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS product_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product TEXT NOT NULL,
        enteredDate TEXT NOT NULL,
        piece INTEGER NOT NULL
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

  Future<Map<String, dynamic>?> getProductEntryById(int id) async {
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

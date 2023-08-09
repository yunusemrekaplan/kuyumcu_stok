import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class BarcodeDbHelper {
  static final BarcodeDbHelper _instance = BarcodeDbHelper._internal();

  factory BarcodeDbHelper() {
    return _instance;
  }

  BarcodeDbHelper._internal();

  Database? _db;

  Future<void> open() async {
    sqfliteFfiInit();

    String path = 'kuyumcu.db';

    _db = await databaseFactoryFfi.openDatabase(path);
    await _createTable();
  }

  Future<void> _createTable() async {
    await _db!.execute('''
      CREATE TABLE IF NOT EXISTS barcodes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        text TEXT NOT NULL,
        path TEXT NOT NULL
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
    return await _db!.insert('barcodes', data);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db!.query('barcodes');
  }

  Future<Map<String, dynamic>?> getBarcodeByText(String text) async {
    final List<Map<String, dynamic>> results = await _db!.query(
      'barcodes',
      where: 'text = ?',
      whereArgs: [text],
    );

    if (results.isNotEmpty) {
      return results.first;
    }

    return null;
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    return await _db!.update('barcodes', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    return await _db!.delete('barcodes', where: 'id = ?', whereArgs: [id]);
  }
}
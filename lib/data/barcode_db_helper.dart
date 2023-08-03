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

    // Path to your database file
    String path = 'kuyumcu.db';

    // Open the database
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
    // Close the database
    await _db!.close();
  }

  Future<int> insert(Map<String, dynamic> data) async {
    // Güncellenmiş kontrol
    if (_db == null) {
      throw Exception("Database is not open.");
    }
    // Insert the data into the given table
    return await _db!.insert('barcodes', data);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    // Retrieve all rows from the given table
    return await _db!.query('barcodes');
  }

  Future<Map<String, dynamic>?> getBarcodeByText(String text) async {
    // Get the barcode from the table based on the given id
    final List<Map<String, dynamic>> results = await _db!.query(
      'barcodes',
      where: 'text = ?',
      whereArgs: [text],
    );

    // If the result is not empty, return the first item (since id is unique)
    if (results.isNotEmpty) {
      return results.first;
    }

    return null; // Return null if no barcode with the given id is found
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    // Update a row in the given table with the specified ID
    return await _db!.update('barcodes', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    // Delete a row from the given table with the specified ID
    return await _db!.delete('barcodes', where: 'id = ?', whereArgs: [id]);
  }
}
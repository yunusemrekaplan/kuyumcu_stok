import 'package:kuyumcu_stok/models/product.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ProductDbHelper {
  static final ProductDbHelper _instance = ProductDbHelper._internal();

  factory ProductDbHelper() {
    return _instance;
  }

  ProductDbHelper._internal();

  Database? _db;

  late List<Product> products;

  /*List<Product> get _products {
    return
  }*/

  Future<void> open() async {
    products = [];
    sqfliteFfiInit();

    // Path to your database file
    String path = 'kuyumcu.db';

    // Open the database
    _db = await databaseFactoryFfi.openDatabase(path);
    //await _db!.execute('DROP TABLE products');
    await _createTable();
  }

  Future<void> _createTable() async {
    await _db!.execute('''
      CREATE TABLE IF NOT EXISTS products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        barcodeText TEXT NOT NULL,
        name TEXT,
        carat INTEGER NOT NULL,
        purityRate DECIMAL NOT NULL,
        laborCost DECIMAL NOT NULL,
        gram DECIMAL NOT NULL,
        costPrice DECIMAL NOT NULL
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

    products.add(Product.fromJson(data));
    // Insert the data into the given table
    return await _db!.insert('products', data);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    // Retrieve all rows from the given table
    return await _db!.query('products');
  }

  Future<Map<String, dynamic>?> getBarcodeById(int id) async {
    // Get the barcode from the table based on the given id
    final List<Map<String, dynamic>> results = await _db!.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );

    // If the result is not empty, return the first item (since id is unique)
    if (results.isNotEmpty) {
      return results.first;
    }

    return null; // Return null if no barcode with the given id is found
  }

  Future<int> update(Map<String, dynamic> data, int id) async {
    // Update a row in the given table with the specified ID
    return await _db!.update('products', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    // Delete a row from the given table with the specified ID
    return await _db!.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pedidos/modelo/producto.dart';

class DB {
  static final DB _myDatabase = DB._privateConstructor();

  // private constructor
  DB._privateConstructor();

  // databse
  static late Database _database;
  //
  factory DB() {
    return _myDatabase;
  }
  // variables para la base de datos
  final String tableProducto = 'producto';
  final String columnId = "id";
  final String columnNombre = 'nombre';
  final String columnCosto = 'costo';
  final String columnPrecio = 'precio';

  // init database
  initializeDatabase() async {
    // Get path where to store database
    Directory directory = await getApplicationDocumentsDirectory();
    // path
    String path = '${directory.path}pedidos_4.db';
    // create Database
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE $tableProducto ($columnId INTEGER PRIMARY KEY, $columnNombre TEXT, $columnCosto DOUBLE, $columnPrecio DOUBLE)');
        // for (int i = 0; i < 11; i++) {
        //   String sql =
        //       "insert into $tableProducto ($columnId, $columnNombre, $columnCosto, $columnPrecio) values ($i, 'producto $i', 0.75, 1.00)";
        //   await db.rawInsert(sql);
        // }
      },
    );
  }

  // CRUD
  // Read
  Future<List<Map<String, Object?>>> getListaProductos() async {
    //
    // List<Map<String, Object?>> result = await _database.rawQuery('SELECT * FROM $tableProducto');
    List<Map<String, Object?>> result =
        await _database.query(tableProducto, orderBy: columnNombre);
    return result;
  }

  // Insert
  // ignore: non_constant_identifier_names
  Future<int> inset_Productos(Producto producto) async {
    int rowsInserted = await _database.insert(tableProducto, producto.toMap());
    return rowsInserted;
  }

  // Update
  // ignore: non_constant_identifier_names
  Future<int> update_producto(Producto producto) async {
    //
    int rowsUpdated = await _database.update(tableProducto, producto.toMap(),
        where: '$columnId= ?', whereArgs: [producto.id]);
    return rowsUpdated;
    //
  }

  // Delete
  // ignore: non_constant_identifier_names
  Future<int> delete_Producto(Producto producto) async {
    //
    int rowsDeleted = await _database
        .delete(tableProducto, where: '$columnId= ?', whereArgs: [producto.id]);
    return rowsDeleted;
    //
  }

  // Count
  // ignore: non_constant_identifier_names
  Future<int> count_Producto() async {
    //
    List<Map<String, Object?>> result =
        await _database.rawQuery('SELECT COUNT(*) FROM $tableProducto');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count;
    //
  }

  Future<int> maximo_id_prod() async {
    final List<Map<String, dynamic>> result =
        await _database.rawQuery('SELECT MAX(id) FROM $tableProducto');
    final maxValue = result[0]['MAX(id)'];
    if (maxValue == null) {
      return 0;
    } else {
      return maxValue;
    }
  }
}

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
  final String tableName = 'producto';
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
            'CREATE TABLE $tableName ($columnId INTEGER PRIMARY KEY, $columnNombre TEXT, $columnCosto DOUBLE, $columnPrecio DOUBLE)');

        //agregarRegistro(_database, 'Valor 1', 1, 1, 0); esto da error
      },
    );
  }

  void agregarRegistro(
      Database db, String nombre, int id, double costo, double precio) async {
    await db.rawInsert(
        'INSERT INTO $tableName($columnId, $columnNombre, $columnCosto,$columnPrecio) VALUES(?, ?,?,?)',
        [id, nombre, costo, precio]);
  }

  // CRUD
  // Read
  Future<List<Map<String, Object?>>> getListaProductos() async {
    //
    // List<Map<String, Object?>> result = await _database.rawQuery('SELECT * FROM $tableName');
    List<Map<String, Object?>> result =
        await _database.query(tableName, orderBy: columnNombre);
    return result;
  }

  // Insert
  // ignore: non_constant_identifier_names
  Future<int> inset_Productos(Producto producto) async {
    int rowsInserted = await _database.insert(tableName, producto.toMap());
    return rowsInserted;
  }

  // Update
  // ignore: non_constant_identifier_names
  Future<int> update_producto(Producto producto) async {
    //
    int rowsUpdated = await _database.update(tableName, producto.toMap(),
        where: '$columnId= ?', whereArgs: [producto.id]);
    return rowsUpdated;
    //
  }

  // Delete
  // ignore: non_constant_identifier_names
  Future<int> delete_Producto(Producto producto) async {
    //
    int rowsDeleted = await _database
        .delete(tableName, where: '$columnId= ?', whereArgs: [producto.id]);
    return rowsDeleted;
    //
  }

  // Count
  // ignore: non_constant_identifier_names
  Future<int> count_Producto() async {
    //
    List<Map<String, Object?>> result =
        await _database.rawQuery('SELECT COUNT(*) FROM $tableName');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count;
    //
  }
}

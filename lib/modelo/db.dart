import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pedidos/componentes/utilidades.dart';
import 'package:pedidos/modelo/detalle_pedido.dart';
import 'package:pedidos/modelo/encabazo_pedido.dart';
import 'package:pedidos/modelo/eventos.dart';
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

  //tabla eventos
  //final String id='id';
  final String tableEvento = "evento";
  final String columnfecha = 'fecha';
  final String columnestado = 'estado';

  //tabla encabezado
  final String tableEncabezado = "encabezado";
  final String columidEvento = "idEvento";
  final String columcliente = "cliente";

  // tabla detalle
  final String tableDetalle = "detalle";
  final String columidEncabezado = "idEncabezado";
  final String columidProducto = "idProducto";
  final String columcantidad = "cantidad";

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
            'CREATE TABLE $tableProducto ($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnNombre TEXT, $columnCosto DOUBLE, $columnPrecio DOUBLE)');
        await db.execute(
            'CREATE TABLE $tableEvento ($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnfecha DATE, $columnestado INTEGER)');
        await db.execute(
            'CREATE TABLE $tableEncabezado ($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columidEvento INTEGER, $columcliente TEXT, FOREIGN KEY ($columidEvento) REFERENCES $tableEvento ($columnId) ON UPDATE CASCADE ON DELETE CASCADE)');
        await db.execute(
            'CREATE TABLE $tableDetalle ($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columidEncabezado INTEGER, $columidProducto INTEGER, $columcantidad INTEGER, FOREIGN KEY ($columidEncabezado) REFERENCES $tableEncabezado ($columnId) ON UPDATE CASCADE ON DELETE CASCADE , FOREIGN KEY ($columidProducto) REFERENCES $tableProducto ($columnId) ON UPDATE CASCADE ON DELETE CASCADE)');

        for (int i = 0; i < 11; i++) {
          String sql =
              "insert into $tableProducto ($columnId, $columnNombre, $columnCosto, $columnPrecio )values (${i + 1}, '${Utilidades.productos[i]}', ${Utilidades.costos[i]}, ${Utilidades.precios[i]})";
          await db.rawInsert(sql);
          DateTime myDate = DateTime(2023, 01, i); // verificar
          String dateString = myDate.toString().substring(0, 10);
          sql =
              "insert into $tableEvento ( $columnfecha, $columnestado) values ('$dateString' , 1)";
          await db.rawInsert(sql);
        }
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

// *************************************************************crud eventos****************************
  Future<List<Map<String, Object?>>> getListaEventos() async {
    //
    // List<Map<String, Object?>> result = await _database.rawQuery('SELECT * FROM $tableProducto');
    List<Map<String, Object?>> result =
        await _database.query(tableEvento, orderBy: "$columnfecha desc");
    return result;
  }

  // ignore: non_constant_identifier_names
  Future<int> inset_Eventos(Evento evento) async {
    int rowsInserted = await _database.insert(tableEvento, evento.toMap());
    return rowsInserted;
  }

  // ignore: non_constant_identifier_names
  Future<int> update_Evento(Evento evento) async {
    //
    int rowsUpdated = await _database.update(tableEvento, evento.toMap(),
        where: '$columnId= ?', whereArgs: [evento.id]);
    return rowsUpdated;
    //
  }

  Future<int> count_Evento() async {
    //
    List<Map<String, Object?>> result =
        await _database.rawQuery('SELECT COUNT(*) FROM $tableEvento');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count;
    //
  }

// *************************************************************crud eventos fin****************************

//*************************************************************crud encabezado****************************
  Future<List<Map<String, Object?>>> getListaEncabezado() async {
    //
    // List<Map<String, Object?>> result = await _database.rawQuery('SELECT * FROM $tableEncabezado where $columidEvento = ${Utilidades.idEvento}');
    List<Map<String, Object?>> result = await _database.query(tableEncabezado,
        where: '$columidEvento=?', whereArgs: [Utilidades.idEvento]);
    return result;
  }

  // ignore: non_constant_identifier_names
  Future<int> insert_Encabezado(Encabezado encabezado) async {
    int rowsInserted =
        await _database.insert(tableEncabezado, encabezado.toMap());
    return rowsInserted;
  }

  Future<int> delete_Encabezado(Encabezado encabezado) async {
    //
    int rowsDeleted = await _database.delete(tableEncabezado,
        where: '$columnId= ?', whereArgs: [encabezado.id]);
    return rowsDeleted;
    //
  }

  Future<int> update_Encabezado(Encabezado encabezado) async {
    //
    int rowsUpdated = await _database.update(
        tableEncabezado, encabezado.toMap(),
        where: '$columnId= ?', whereArgs: [encabezado.id]);
    return rowsUpdated;
    //
  }

  Future<int> count_Encabezado() async {
    //
    List<Map<String, Object?>> result =
        await _database.rawQuery('SELECT COUNT(*) FROM $tableEncabezado');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count;
    //
  }

// *************************************************************crud encabezado fin****************************

//*************************************************************crud detalles****************************
  Future<List<Map<String, Object?>>> getListaDetalle() async {
    //
    // List<Map<String, Object?>> result = await _database.rawQuery('SELECT * FROM $tableProducto');
    List<Map<String, Object?>> result =
        await _database.query(tableDetalle, orderBy: columnId + " desc");
    return result;
  }

  // ignore: non_constant_identifier_names
  Future<int> insert_Detalle(Detalle detalle) async {
    int rowsInserted = await _database.insert(tableDetalle, detalle.toMap());
    return rowsInserted;
  }

  Future<int> delete_Detalles(Detalle detalle) async {
    //
    int rowsDeleted = await _database
        .delete(tableDetalle, where: '$columnId= ?', whereArgs: [detalle.id]);
    return rowsDeleted;
    //
  }

  Future<int> update_Detalles(Detalle detalle) async {
    //
    int rowsUpdated = await _database.update(tableDetalle, detalle.toMap(),
        where: '$columnId= ?', whereArgs: [detalle.id]);
    return rowsUpdated;
    //
  }

  Future<int> count_Detalles() async {
    //
    List<Map<String, Object?>> result =
        await _database.rawQuery('SELECT COUNT(*) FROM $tableDetalle');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count;
    //
  }

// *************************************************************crud detalles fin****************************

  Future<List<Map<String, Object?>>> getListaPedido(int enc) async {
    //
    //String consulta='select ee.cliente,p.nombre,d.cantidad,e.fecha,e.estado from $tableEvento as e inner JOIN $tableEncabezado as ee on e.$columnId=ee.$columidEvento inner join $tableDetalle as d on ee.$columnId=d.$columidEncabezado inner join $tableProducto as p on p.$columnId=d.$columidProducto where $tableEvento=${Utilidades.idEvento}';
    List<Map<String, Object?>> result = await _database.rawQuery(
        "select e.id as encabezado,d.id, e.$columcliente,d.$columcantidad, p.$columnNombre,p.$columnPrecio from $tableEvento as ev inner JOIN $tableEncabezado as e on ev.$columnId=e.$columidEvento inner JOIN $tableDetalle as d on e.$columnId=d.$columidEncabezado inner join $tableProducto as p on p.$columnId= d.$columidProducto where ev.$columnId=${Utilidades.idEvento} and e.$columnId = $enc");

    return result;
  }

  Future<List<Map<String, Object?>>> getListaPedidos() async {
    //
    //String consulta='select ee.cliente,p.nombre,d.cantidad,e.fecha,e.estado from $tableEvento as e inner JOIN $tableEncabezado as ee on e.$columnId=ee.$columidEvento inner join $tableDetalle as d on ee.$columnId=d.$columidEncabezado inner join $tableProducto as p on p.$columnId=d.$columidProducto where $tableEvento=${Utilidades.idEvento}';
    List<Map<String, Object?>> result = await _database.rawQuery(
        "select e.id as encabezado,d.id, e.$columcliente,d.$columcantidad, p.$columnNombre,p.$columnPrecio*d.$columcantidad as precioT ,p.$columnCosto*d.$columcantidad as costoT,p.id as idProducto from $tableEvento as ev inner JOIN $tableEncabezado as e on ev.$columnId=e.$columidEvento inner JOIN $tableDetalle as d on e.$columnId=d.$columidEncabezado inner join $tableProducto as p on p.$columnId= d.$columidProducto where ev.$columnId=${Utilidades.idEvento} order by p.id ASC");

    return result;
  }

  Future<List<Map<String, Object?>>> getListaPedidoEventoCliente() async {
    //
    //String consulta='select ee.cliente,p.nombre,d.cantidad,e.fecha,e.estado from $tableEvento as e inner JOIN $tableEncabezado as ee on e.$columnId=ee.$columidEvento inner join $tableDetalle as d on ee.$columnId=d.$columidEncabezado inner join $tableProducto as p on p.$columnId=d.$columidProducto where $tableEvento=${Utilidades.idEvento}';
    List<Map<String, Object?>> result = await _database.rawQuery(
        "select e.id as encabezado,d.id, e.$columcliente,d.$columcantidad, p.$columnNombre,p.$columnPrecio from $tableEvento as ev inner JOIN $tableEncabezado as e on ev.$columnId=e.$columidEvento inner JOIN $tableDetalle as d on e.$columnId=d.$columidEncabezado inner join $tableProducto as p on p.$columnId= d.$columidProducto where ev.$columnId=${Utilidades.idEvento} order by e.$columcliente");

    return result;
  }
}

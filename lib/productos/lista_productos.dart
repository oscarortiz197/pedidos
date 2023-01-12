import 'package:flutter/material.dart';
import 'package:pedidos/modelo/producto.dart';
import 'package:pedidos/productos/editar_producto.dart';
import 'package:pedidos/productos/nuevo_producto.dart';

import '../modelo/db.dart';

class lista_productos extends StatefulWidget {
  const lista_productos({super.key});

  @override
  State<lista_productos> createState() => _lista_productosState();
}

class _lista_productosState extends State<lista_productos> {
  bool isLoading = false;
  List<Producto> productos = List.empty(growable: true);
  final DB _myDatabase = DB();
  int count = 0;

  // getData from DATABASE
  getDataFromDb() async {
    await _myDatabase.initializeDatabase();
    //_myDatabase.agregarRegistro(db, 'Valor 1', 1, 1, 0);
    List<Map<String, Object?>> map = await _myDatabase.getListaProductos();
    for (int i = 0; i < map.length; i++) {
      productos.add(Producto.toEmp(map[i]));
    }

    count = await _myDatabase.count_Producto();

    // print(productos);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : productos.isEmpty
              ? const Center(
                  child: Text('Aun no hay productos! '),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditarProducto(
                                        myDatabase: _myDatabase,
                                        producto: productos[index],
                                      )));
                        },
                        title: Text('${productos[index].nombre} '),
                        subtitle: Text('${productos[index].costo}'),
                        trailing: SizedBox(
                          width: 100,
                          child: IconButton(
                              onPressed: () {}, icon: const Icon(Icons.delete)),
                        ),
                      ),
                    );
                  },
                  itemCount: count,
                ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NuevoProducto(
                          myDatabase: _myDatabase,
                        )));
          },
          child: const Icon(Icons.add)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pedidos/componentes/alertas.dart';
import 'package:pedidos/inicio.dart';
import 'package:pedidos/modelo/producto.dart';
import 'package:pedidos/productos/editar_producto.dart';
import 'package:pedidos/productos/nuevo_producto.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../modelo/db.dart';

class lista_productos extends StatefulWidget {
  const lista_productos({super.key});

  @override
  State<lista_productos> createState() => _lista_productosState();
}

class _lista_productosState extends State<lista_productos> {
  bool isLoading = true;
  List<Producto> productos = List.empty(growable: true);
  final DB _myDatabase = DB();
  int count = 0;

  // getData from DATABASE
  getDataFromDb() async {
    productos.clear();
    await _myDatabase.initializeDatabase();
    //_myDatabase.agregarRegistro(db, 'Valor 1', 1, 1, 0);
    List<Map<String, Object?>> map = await _myDatabase.getListaProductos();
    //print("hola"+map[3]['nombre'].toString());
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
                        onTap: ()async {
                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditarProducto(
                                        myDatabase: _myDatabase,
                                        producto_select: productos[index],
                                      )));
                                      //print(result);
                                      if(result){
                                        setState(() {
                                          getDataFromDb();
                                        });
                                      }
                        },
                        title: Text('${productos[index].nombre} '),
                        subtitle: Text('${productos[index].costo}'),
                        trailing: SizedBox(
                          width: 100,
                          child: IconButton(
                              onPressed: () async {
                               
                                bool estado= await  Alerta.borrar(context);
                                //print(estado);
                                if(estado){
                                  _myDatabase.delete_Producto(productos[index]);
                                  setState(() {
                                    getDataFromDb();
                                  });
                                }
                              },
                              icon: const Icon(Icons.delete)),
                        ),
                      ),
                    );
                  },
                  itemCount: count,
                ),
      floatingActionButton: FloatingActionButton(
          onPressed: ()async {
            final result=await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NuevoProducto(
                          myDatabase: _myDatabase,
                        )));
                        print("holaa  $result");
                        if(result!=null){
                          setState(() {
                            getDataFromDb();
                          });
                        }
          },
          child: const Icon(Icons.add)),
    );
  }
}

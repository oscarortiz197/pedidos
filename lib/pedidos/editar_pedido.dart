import 'package:flutter/material.dart';
import 'package:pedidos/componentes/alertas.dart';
import 'package:pedidos/componentes/utilidades.dart';
import 'package:pedidos/modelo/producto.dart';
import 'package:pedidos/pedidos/confirmar_pedido.dart';
import '../modelo/db.dart';

class EditarPedido extends StatefulWidget {
  List<Producto> anterior = [];
  List can = [];
  EditarPedido({super.key, required this.anterior, required this.can});

  @override
  State<EditarPedido> createState() => _EditarPedidoState();
}

class _EditarPedidoState extends State<EditarPedido> {
  bool isLoading = true;
  List<Producto> productos = List.empty(growable: true);
  List<int> cantidades = [];
  final DB _myDatabase = DB();
  int count = 0;

  // getData from DATABASE
  getDataFromDb() async {
    productos.clear();
    await _myDatabase.initializeDatabase();
    //_myDatabase.agregarRegistro(db, 'Valor 1', 1, 1, 0);
    List<Map<String, Object?>> map = await _myDatabase.getListaProductos();

    for (int i = 0; i < map.length; i++) {
      productos.add(Producto.toEmp(map[i]));
    }
    debugPrint(widget.anterior.toString());
    cantidades = List.filled(productos.length, 0);
    count = await _myDatabase.count_Producto();

    for (int i = 0; i < widget.anterior.length; i++) {
      for (int j = 0; j < map.length; j++) {
        if (productos[j].id == widget.anterior[i].id) {
          cantidades[j] = widget.can[i];
        }
      }
    }

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
      appBar: AppBar(
        title: Text(Utilidades.fechaEvento),
      ),
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
                      color: cantidades[index] > 0
                          ? Colors.green[500]
                          : Colors.white,
                      child: ListTile(
                        title: Text('${productos[index].nombre} '),
                        //subtitle: Text('${productos[index].costo}'),
                        trailing: SizedBox(
                          width: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    num(false, index);
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.remove)),
                              Text(cantidades[index].toString()),
                              IconButton(
                                  onPressed: () async {
                                    num(true, index);
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.add)),
                              IconButton(
                                  onPressed: () async {
                                    if (cantidades[index] == 0) {
                                      num(true, index);
                                    } else {
                                      cantidades[index] = 0;
                                    }
                                    setState(() {});
                                  },
                                  color: cantidades[index] > 0
                                      ? Colors.white
                                      : Colors.grey,
                                  icon: const Icon(Icons.shopping_cart)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: count,
                ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            datos();
          },
          child: const Icon(Icons.shopping_cart)),
    );
  }

  num(bool estado, int index) {
    estado
        ? cantidades[index] += 1
        : cantidades[index] != 0
            ? cantidades[index] -= 1
            : cantidades[index] = 0;
  }

  datos() {
    bool estado = false;
    for (var element in cantidades) {
      if (element > 0) {
        estado = true;
      }
    }

    if (estado) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmarPedido(
                    myDatabase: _myDatabase,
                    cantidades: cantidades,
                    productos: productos,
                  )));
    } else {
      Alerta.mensaje(context, "Selecciones un registro", Colors.red);
    }
  }
}

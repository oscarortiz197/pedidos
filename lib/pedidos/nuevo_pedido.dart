import 'package:flutter/material.dart';
import 'package:pedidos/pedidos/confirmar_pedido.dart';

class NuevoPedido extends StatefulWidget {
  const NuevoPedido({super.key});

  @override
  State<NuevoPedido> createState() => _NuevoPedidoState();
}

class _NuevoPedidoState extends State<NuevoPedido> {
  List<String> productos = [];
  List<int> ids = [];
  List<int> cantidades = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data();
  }

  data() {
    productos = ["product 1", "product 2", "product 3"];
    ids = [22, 55, 33];
    cantidades = List.filled(productos.length, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de productos"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            color: cantidades[index] > 0 ? Colors.green : Colors.white,
            child: ListTile(
              title: Text(productos[index]),
              trailing: SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            num(cantidades[index], false, index);
                          });
                        },
                        icon: const Icon(Icons.remove)),
                    Text(cantidades[index].toString()),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            num(cantidades[index], true, index);
                          });
                        },
                        icon: const Icon(Icons.add)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (cantidades[index] == 0) {
                              num(cantidades[index], true, index);
                            } else {
                              cantidades[index] = 0;
                            }
                          });
                        },
                        icon: const Icon(Icons.shopping_cart),
                        color:
                            cantidades[index] > 0 ? Colors.white : Colors.grey),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: productos.length,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            enviarDatos();
            // Navigator.push(context, MaterialPageRoute(builder:(context)=>ConfirmarPedido() ));
          },
          child: const Icon(Icons.shopping_cart)),
    );
  }

  enviarDatos() {
    final List<String> products = [];
    final List<int> id = [];
    final List<int> cantidad = [];
    bool estado = false;
    for (int i = 0; i < productos.length; i++) {
      if (cantidades[i] > 0) {
        products.add(productos[i]);
        id.add(ids[i]);
        cantidad.add(cantidades[i]);
        estado = true;
      }
    }
    estado
        ? Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmarPedido(
                    productos: products, id: id, cantidades: cantidad)))
        : estado = false;
  }

  num(int numero, bool estado, int index) {
    estado
        ? cantidades[index] += 1
        : cantidades[index] != 0
            ? cantidades[index] -= 1
            : cantidades[index] = 0;
    return cantidades[index];
  }
}

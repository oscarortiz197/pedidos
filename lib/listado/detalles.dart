import 'package:flutter/material.dart';
import 'package:pedidos/componentes/utilidades.dart';
import 'package:pedidos/modelo/detalle_pedido.dart';
import 'package:pedidos/modelo/encabazo_pedido.dart';
import 'package:pedidos/pedidos/nuevo_pedido.dart';
//import 'package:pedidos/productos/lista_productos.dart';

import '../componentes/texfield.dart';
import '../modelo/db.dart';
import '../modelo/producto.dart';

class Detalles extends StatefulWidget {
  const Detalles({super.key});

  @override
  State<Detalles> createState() => _DetallesState();
}

class _DetallesState extends State<Detalles> {
  @override

  final DB _myDatabase = DB();

  getDataFromDb() async {
    await _myDatabase.initializeDatabase();
    List<Map<String, Object?>> map = await _myDatabase.getListaPedidos();
    print(map);
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromDb();

  }

  

  double total = 0;
  Map<String, dynamic> productos_select = {};
  final TextEditingController _ClinteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confimar pedido"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 280,
            child: Column(
              children: [
                Texto(controller: _ClinteController, msj: "Nombre Cliente"),
                Container(
                  margin: EdgeInsets.only(top: 45),
                  height: 350,
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        
                          return Card(
                            child: ListTile(
                                title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Text(widget.cantidades[index].toString()),
                                // Text(widget.productos[index].nombre),
                              ],
                            )),
                          );
                        
                      },
                      itemCount: 1//widget.productos.length //productos.length,
                      ),
                ),
                Text("Total a pagar  $total")
              ],
            ),
          ),
        ),
      ),
      
    );
  }
}

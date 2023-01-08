import 'package:flutter/material.dart';
import 'package:pedidos/pedidos/nuevo_pedido.dart';

import '../componentes/texfield.dart';

class ConfirmarPedido extends StatelessWidget {
  final List<String> productos;
  final List<int> id;
  final List<int> cantidades;
  ConfirmarPedido(
      {super.key,
      required this.productos,
      required this.id,
      required this.cantidades});
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
                  margin: EdgeInsets.only(top: 25),
                  height: 350,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(cantidades[index].toString()),
                          trailing: SizedBox(
                            width: 150,
                            child: Text(productos[index]),
                          ),
                        ),
                      );
                    },
                    itemCount: productos.length,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (guardar()) {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NuevoPedido()));
            } else {
              print("Clienete es un campo requerido ");
            }
          },
          child: const Icon(Icons.save)),
    );
  }

  bool guardar() {
    if (_ClinteController.text.isEmpty) {
      return false;
    } else {
      // guardar la data
      return true;
    }
  }
}

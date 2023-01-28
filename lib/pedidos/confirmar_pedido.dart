import 'package:flutter/material.dart';
import 'package:pedidos/componentes/alertas.dart';
import 'package:pedidos/componentes/utilidades.dart';
import 'package:pedidos/modelo/detalle_pedido.dart';
import 'package:pedidos/modelo/encabazo_pedido.dart';
import 'package:pedidos/pedidos/nuevo_pedido.dart';
//import 'package:pedidos/productos/lista_productos.dart';

import '../componentes/texfield.dart';
import '../listado/encabezados_pedidos.dart';
import '../modelo/db.dart';
import '../modelo/producto.dart';

class ConfirmarPedido extends StatefulWidget {
  final DB myDatabase;
  final List<Producto> productos;
  final List cantidades;

  const ConfirmarPedido(
      {super.key,
      required this.myDatabase,
      required this.productos,
      required this.cantidades});

  @override
  State<ConfirmarPedido> createState() => _ConfirmarPedidoState();
}

class _ConfirmarPedidoState extends State<ConfirmarPedido> {
  final TextEditingController _ClinteController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    if (Utilidades.cliente != "") {
      _ClinteController.text = Utilidades.cliente;
      Utilidades.cliente = '';
    }

    super.initState();
    procesar();
  }

  double total = 0;
  Map<String, dynamic> productos_select = {};

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confimar pedido"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 280,
            child: Column(
              children: [
                Texto(controller: _ClinteController, msj: "Nombre Cliente"),
                Container(
                  margin: const EdgeInsets.only(top: 45),
                  height: size.height - 250,
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        if (widget.cantidades[index] > 0) {
                          return Card(
                            child: ListTile(
                                title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                    width: 50,
                                    child: Text(
                                        widget.cantidades[index].toString())),
                                SizedBox(
                                    width: 150,
                                    child:
                                        Text(widget.productos[index].nombre)),
                              ],
                            )),
                          );
                        } else {
                          return const Divider(
                            color: Colors.white,
                            height: 0,
                          );
                        }
                      },
                      itemCount: widget.productos.length //productos.length,
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text("Total a pagar  $total")
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (await guardar()) {
              Navigator.pop(context);
              Navigator.pop(context);
              if (modificacion) {
                Navigator.pop(context);

                Utilidades.idEliminar = 0;
                modificacion = false;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Encabezados()));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NuevoPedido()));
              }
            } else {
              Alerta.mensaje(
                  context, "Ingrese el nombre del cliente", Colors.red);
            }
          },
          child: const Icon(Icons.save)),
    );
  }

  bool modificacion = false;
  Future<bool> guardar() async {
    if (Utilidades.idEliminar != 0) {
      await widget.myDatabase.delete_Encabezado(
          Encabezado(id: Utilidades.idEliminar, idEvento: null, cliente: ""));

      await widget.myDatabase.delete_Detalles(Detalle(
          id: null,
          idEncabezado: Utilidades.idEliminar,
          idProducto: null,
          cantidad: null));
      modificacion = true;
    }

    if (_ClinteController.text.isEmpty) {
      return false;
    } else {
      Encabezado enc = Encabezado(
          id: modificacion ? Utilidades.idEliminar : null,
          idEvento: Utilidades.idEvento,
          cliente: _ClinteController.text);

      int idenc = await widget.myDatabase.insert_Encabezado(enc);
      if (idenc != 0) {
        for (int i = 0; i < widget.productos.length; i++) {
          if (widget.cantidades[i] > 0) {
            Detalle dt = Detalle(
                id: null,
                idEncabezado: idenc,
                idProducto: widget.productos[i].id,
                cantidad: widget.cantidades[i]);
            await widget.myDatabase.insert_Detalle(dt);
          }
        }
      }

      // Detalle dt=Detalle(id: null, idEncabezado: idenc, idProducto: idProducto, cantidad: cantidad)
      return true;
    }
  }

  procesar() {
    for (int i = 0; i < widget.productos.length; i++) {
      if (widget.cantidades[i] > 0) {
        total += widget.productos[i].precio! * widget.cantidades[i]!;
      }
    }
  }
}

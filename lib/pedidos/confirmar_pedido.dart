import 'package:flutter/material.dart';
import 'package:pedidos/componentes/alertas.dart';
import 'package:pedidos/componentes/utilidades.dart';
import 'package:pedidos/modelo/detalle_pedido.dart';
import 'package:pedidos/modelo/encabazo_pedido.dart';
import 'package:pedidos/pedidos/nuevo_pedido.dart';
//import 'package:pedidos/productos/lista_productos.dart';

import '../componentes/texfield.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    procesar();
  }
  double total =0;
  Map <String,dynamic> productos_select={};
  final TextEditingController _ClinteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  margin:const EdgeInsets.only(top: 45),
                  height: 350,
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        if (widget.cantidades[index] > 0) {
                          return Card(
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                Text(widget.cantidades[index].toString()),
                                Text(widget.productos[index].nombre),

                              ],)
                              
                            ),
                          );
                        } 
                        else {
                          return const Divider(
                            color: Colors.white,
                            height: 0,
                          );
                        }
                      },
                      itemCount: widget.productos.length //productos.length,
                      ),
                ),
                Text("Total a pagar  $total")
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: ()async {
            if (await guardar()) {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NuevoPedido()));
            } else {
             Alerta.mensaje(context, "Ingrese el nombre del cliente", Colors.red);
            }
          },
          child: const Icon(Icons.save)),
    );
  }

  Future<bool> guardar()async {
    if (_ClinteController.text.isEmpty) {
      return false;
    } else {
      Encabezado enc = Encabezado(id: null, idEvento: Utilidades.idEvento, cliente: _ClinteController.text);
      int idenc = await widget.myDatabase.insert_Encabezado(enc);
      if(idenc!=0){
      for (int i=0;i<widget.productos.length;i++){
      if (widget.cantidades[i]>0){   
         Detalle dt=Detalle(id: null, idEncabezado: idenc, idProducto: widget.productos[i].id, cantidad:widget.cantidades[i]);
         await widget.myDatabase.insert_Detalle(dt);
      }
      }
      }

     // Detalle dt=Detalle(id: null, idEncabezado: idenc, idProducto: idProducto, cantidad: cantidad)
      return true;
    }
  }

  procesar(){
   
    for (int i=0;i<widget.productos.length;i++){
      
      if (widget.cantidades[i]>0){
        
         total+=widget.productos[i].precio!*widget.cantidades[i]!;
      }
      

    }
  }


}

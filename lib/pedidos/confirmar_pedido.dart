import 'package:flutter/material.dart';
import 'package:pedidos/pedidos/nuevo_pedido.dart';
//import 'package:pedidos/productos/lista_productos.dart';

import '../componentes/texfield.dart';
import '../modelo/db.dart';
import '../modelo/producto.dart';

class ConfirmarPedido extends StatefulWidget {
  final DB myDatabase;
  final List<Producto> productos;
  final List cantidades;
  
  ConfirmarPedido(
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
          onPressed: () {
            if (guardar()) {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NuevoPedido()));
            } else {
              print("Cliente es un campo requerido ");
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

  procesar(){
   
    for (int i=0;i<widget.productos.length;i++){
      
      if (widget.cantidades[i]>0){
        
         total+=widget.productos[i].precio!*widget.cantidades[i]!;
         //productos.addAll("producto","widget.productos[i].nombre");
      }
      

    }
  }


}

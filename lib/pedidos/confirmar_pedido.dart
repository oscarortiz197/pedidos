import 'package:flutter/material.dart';
import 'package:pedidos/pedidos/nuevo_pedido.dart';

import '../componentes/texfield.dart';

class ConfirmarPedido extends StatelessWidget {
  final List <String> productos;
  final List <int> id;
  final List <int> cantidades;
   const ConfirmarPedido({super.key,required this.productos,required this.id,required this.cantidades});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _ClinteController = TextEditingController();
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
          itemCount:productos.length,
        ),
                  )
                
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => ConfirmarPedido()));
            Navigator.pop(context);
            Navigator.pop(context);
            //MaterialPageRoute(builder: (context) => NuevoPedido());
          },
          child: const Icon(Icons.save)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pedidos/componentes/texfield.dart';

class EditarProducto extends StatelessWidget {
   EditarProducto({super.key});
  final TextEditingController _NombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _costoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    
    var size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Producto"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
             margin: EdgeInsets.symmetric(vertical: 30),
             width: 280,
             height:size.height>400? size.height-180 :300 ,
            child: Column(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:  [
                 Texto(controller: _NombreController, msj: "Ingrese el nombre"),
                NumDouble(controller: _precioController, msj: "Ingrese el precio"),
                NumDouble(controller: _costoController, msj: "Ingrese el costo"),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Guardar"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

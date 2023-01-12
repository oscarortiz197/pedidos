import 'package:flutter/material.dart';
import 'package:pedidos/componentes/texfield.dart';
import 'package:pedidos/modelo/producto.dart';

import '../modelo/db.dart';

class EditarProducto extends StatelessWidget {
  final DB myDatabase;
  final Producto producto;
  EditarProducto({super.key, required this.myDatabase, required this.producto});
  TextEditingController _NombreController = TextEditingController();
  TextEditingController _precioController = TextEditingController();
  TextEditingController _costoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _NombreController.text = producto.nombre.toString();
    _precioController.text = producto.precio.toString();
    _costoController.text = producto.costo.toString();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Producto"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            width: 280,
            height: size.height > 400 ? size.height - 180 : 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Texto(controller: _NombreController, msj: "Ingrese el nombre"),
                NumDouble(
                    controller: _precioController, msj: "Ingrese el precio"),
                NumDouble(
                    controller: _costoController, msj: "Ingrese el costo"),
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

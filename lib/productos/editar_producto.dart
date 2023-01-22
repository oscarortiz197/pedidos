import 'package:flutter/material.dart';
import 'package:pedidos/componentes/texfield.dart';
import 'package:pedidos/componentes/validacion.dart';
import 'package:pedidos/modelo/producto.dart';

import '../componentes/alertas.dart';
import '../modelo/db.dart';

class EditarProducto extends StatefulWidget {
  final DB myDatabase;
  final Producto producto_select;

  const EditarProducto(
      {super.key, required this.myDatabase, required this.producto_select});

  @override
  State<EditarProducto> createState() => _EditarProductoState();
}

class _EditarProductoState extends State<EditarProducto> {
  final TextEditingController _nombreController = TextEditingController();

  final TextEditingController _precioController = TextEditingController();

  final TextEditingController _costoController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nombreController.text = widget.producto_select.nombre.toString();
    _precioController.text = widget.producto_select.precio.toString();
    _costoController.text = widget.producto_select.costo.toString();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          Navigator.maybePop(context, false);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Editar Producto"),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                width: 280,
                height: size.height > 400 ? size.height - 180 : 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Texto(
                        controller: _nombreController,
                        msj: "Ingrese el nombre"),
                    NumDouble(
                        controller: _precioController,
                        msj: "Ingrese el precio"),
                    NumDouble(
                        controller: _costoController, msj: "Ingrese el costo"),
                    ElevatedButton(
                      onPressed: () async {
                        List<String> campos = [
                          _nombreController.text,
                          _precioController.text,
                          _costoController.text
                        ];
                        if (Validar.validar(campos)) {
                          String nombre = _nombreController.text;
                          double? costo =
                              double.tryParse(_costoController.text);
                          double? precio =
                              double.tryParse(_precioController.text);
                          Producto pro = Producto(
                              id: widget.producto_select.id,
                              nombre: nombre,
                              costo: costo,
                              precio: precio);
                          if (await widget.myDatabase.update_producto(pro) >
                              0) {
                            Alerta.mensaje(context,
                                "Se ha actualizado el registro", Colors.green);
                            Navigator.pop(context, true);
                          }
                        }
                      },
                      child: const Text("Guardar"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

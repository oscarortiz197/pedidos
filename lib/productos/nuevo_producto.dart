import 'package:flutter/material.dart';
import 'package:pedidos/componentes/texfield.dart';
import 'package:pedidos/componentes/validacion.dart';
import 'package:pedidos/modelo/producto.dart';
import '../componentes/alertas.dart';
import '../modelo/db.dart';

class NuevoProducto extends StatefulWidget {
  final DB myDatabase;
  const NuevoProducto({super.key, required this.myDatabase});

  @override
  State<NuevoProducto> createState() => _NuevoProductoState();
}

class _NuevoProductoState extends State<NuevoProducto> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _costoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nuevo Producto"),
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
                Texto(controller: _nombreController, msj: "Ingrese el nombre"),
                NumDouble(
                    controller: _precioController, msj: "Ingrese el precio"),
                NumDouble(
                    controller: _costoController, msj: "Ingrese el costo"),
                ElevatedButton(
                  onPressed: () async {
                    int id = await widget.myDatabase.maximo_id_prod() + 1;
                    List<String> datos = [
                      _nombreController.text,
                      _precioController.text,
                      _costoController.text
                    ];
                    if (Validar.validar(datos)) {
                      datos.clear();
                      String nombre = _nombreController.text;
                      double? costo = double.tryParse(_costoController.text);
                      double? precio = double.tryParse(_precioController.text);
                      Producto prod = Producto(
                          id: null, nombre: nombre, costo: costo, precio: precio);
                      if (await widget.myDatabase.inset_Productos(prod) > 0) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('${prod.nombre} agregado.')));
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context, true);
                      }
                    } else {
                       Alerta.mensaje(context,'Ingrese todos los datos',Colors.red);
                    }
                  },
                  child: const Text("Guardar"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

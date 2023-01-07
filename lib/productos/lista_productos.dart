import 'package:flutter/material.dart';
import 'package:pedidos/productos/editar_producto.dart';
import 'package:pedidos/productos/nuevo_producto.dart';

class lista_productos extends StatefulWidget {
  const lista_productos({super.key});

  @override
  State<lista_productos> createState() => _lista_productosState();
}

class _lista_productosState extends State<lista_productos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return 
              Card(
                child: ListTile(  
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>EditarProducto() ));
                  },
                  title: Text("Jalapeño paqueño  $index"),
                  subtitle: Text("precio 0.75"),
                  trailing: SizedBox(
                    width: 100,
                    child: IconButton(onPressed:(){} ,icon: Icon(Icons.delete)),
                  ),
                ),
              );
        },
        itemCount: 10,
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder:(context)=>Nuevo_Producto() ));
          }, child: const Icon(Icons.add)),
    );
  }
}

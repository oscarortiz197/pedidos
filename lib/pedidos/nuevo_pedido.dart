import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../componentes/texfield.dart';

class NuevoPedido extends StatefulWidget {
  const NuevoPedido({super.key});

  @override
  State<NuevoPedido> createState() => _NuevoPedidoState();
}

class _NuevoPedidoState extends State<NuevoPedido> {
  int cantidad=1;
  @override
  Widget build(BuildContext context) {
     var size=MediaQuery.of(context).size;
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return 
              Card(
                child: ListTile(  
                  title: Text("Jalapeño paqueño  $index"),
                  trailing: SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(onPressed:(){
                          setState(() {
                            num(cantidad, false);
                          });
                        } ,icon: Icon(Icons.remove)),
                        Text("$cantidad"),
                        IconButton(onPressed:(){
                          setState(() {
                            num(cantidad, true);
                          });
                        } ,icon: Icon(Icons.add)),
                        IconButton(onPressed:(){} ,icon: Icon(Icons.shopping_cart)),
                      ],
                    ),
                    
                  ),
                ),
              );
        },
        itemCount: 10,
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: () {
           // Navigator.push(context, MaterialPageRoute(builder:(context)=>Nuevo_Producto() ));
          }, child: const Icon(Icons.shopping_cart)),
    );
  }

  num(int numero,bool estado){
    return estado? cantidad+=1: cantidad!=0? cantidad-=1:cantidad=0;
  }
}
import 'package:flutter/material.dart';
import 'package:pedidos/pedidos/nuevo_evento.dart';
import 'package:pedidos/pedidos/nuevo_pedido.dart';

class lista_eventos extends StatefulWidget {
  const lista_eventos({super.key});

  @override
  State<lista_eventos> createState() => _lista_eventosState();
}

class _lista_eventosState extends State<lista_eventos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return 
              Card(
                child: ListTile(  
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>NuevoPedido()));
                  },
                  title: Text("evento 10-2-2023 $index"),
                  trailing: SizedBox(
                    width: 100,
                   // child: IconButton(onPressed:(){ } ,icon: Icon(Icons.delete)),
                  ),
                ),
              );
        },
        itemCount: 5,
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder:(context)=>NuevoEvento()));
          }, child: const Icon(Icons.add)),
    );
  }
}

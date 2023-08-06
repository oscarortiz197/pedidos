import 'package:flutter/material.dart';
import 'package:pedidos/pedidos/lista_eventos.dart';
import 'package:pedidos/productos/lista_productos.dart';

import 'listado/lista_Eventos.dart';

// prueba de cambio
class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    debugPrint("hola");
    return const DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              TabBar(
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    text: "Listado",
                  ),
                  Tab(
                    text: "pedidos",
                  ),
                  Tab(
                    text: "productos",
                  )
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ListaEventos(),
                    LstaEventos(),
                    lista_productos(),
                  ],
                ),
              ),
              //  Container(
              //   margin: const EdgeInsets.only(top: 10),
              //   color: Color.fromARGB(50, 0, 0, 0),
              //   child: Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     IconButton(onPressed: (){
              //       SystemNavigator.pop();
              //     }, icon: Icon(Icons.exit_to_app)),
              //     IconButton(onPressed: (){}, icon: Icon(Icons.update)),
              //     IconButton(onPressed: (){}, icon: Icon(Icons.add)),
              //   ],
              //  ),
              //  )
            ],
          ),
        ),
      ),
    );
  }
}

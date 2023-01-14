import 'package:flutter/material.dart';
import 'package:pedidos/modelo/eventos.dart';

import '../modelo/db.dart';

class NuevoEvento extends StatefulWidget {
  const NuevoEvento({super.key});

  @override
  State<NuevoEvento> createState() => _NuevoEventoState();
}

class _NuevoEventoState extends State<NuevoEvento> {
  @override
  Widget build(BuildContext context) {
    DB myDatabase = DB();

    //myDatabase.inset_Productos(prod)
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
                const Text("calendario"),
                ElevatedButton(
                  onPressed: () async {
                    int result = await myDatabase.count_Evento();
                    DateTime myDate = DateTime.now(); // verificar
                    String dateString = myDate.toIso8601String();
                    print(dateString);
                    Evento ev =
                        Evento(id: null, estado: 0, fecha: "2023-10-10");
                    result = await myDatabase.inset_Eventos(ev);
                    print(result);
                    result = await myDatabase.count_Evento();
                    print("Despues $result");
                    print(await myDatabase.getListaEventos());
                  },
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

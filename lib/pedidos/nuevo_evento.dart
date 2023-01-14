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
        title: Text("Nuevo Producto"),
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
                Text("calendario"),
                ElevatedButton(
                  onPressed: () async {
                    int result = await myDatabase.count_Evento();
                    final date = DateTime.now();
                    // final formatter = DateFormat('yyyy-MM-dd');
                    // final dateString = formatter.format(date);
                    // print(dateString);

                    // final date = DateTime.now();
                    // final formatter = DateFormat('yyyy-MM-dd');
                    // final dateString =
                    //     date == null ? null : formatter.format(date);

                    print("antes $result");

                    Evento ev =
                       Evento( estado: false, fecha: "2023-10-10");
                    result=await myDatabase.inset_Eventos(ev);
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

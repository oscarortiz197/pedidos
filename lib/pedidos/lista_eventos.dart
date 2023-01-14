import 'package:flutter/material.dart';
import 'package:pedidos/modelo/eventos.dart';
import 'package:pedidos/pedidos/nuevo_evento.dart';
import 'package:pedidos/pedidos/nuevo_pedido.dart';

import '../componentes/alertas.dart';
import '../modelo/db.dart';

class LstaEventos extends StatefulWidget {
  const LstaEventos({super.key});

  @override
  State<LstaEventos> createState() => _LstaEventosState();
}

class _LstaEventosState extends State<LstaEventos> {
  bool isLoading = true;
  List<Evento> eventos = List.empty(growable: true);
  final DB _myDatabase = DB();
  int count = 0;

  getDataFromDb() async {
    eventos.clear();
    await _myDatabase.initializeDatabase();
    List<Map<String, Object?>> map = await _myDatabase.getListaEventos();
    print(map);
    for (int i = 0; i < map.length; i++) {
      eventos.add(Evento.toEmp(map[i]));
    }
    count = eventos.length;

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getDataFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : eventos.isEmpty
              ? const Center(
                  child: Text('Aun no hay eventos! '),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () async {
                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditarEvento(
                                      // myDatabase: _myDatabase,
                                      // producto_select: eventos[index],
                                      )));

                          if (result) {
                            setState(() {
                              getDataFromDb();
                            });
                          }
                        },
                        title: Text('Entrega ${eventos[index].fecha}'),
                        // subtitle: Text('${eventos[index].fecha}'),
                        trailing: SizedBox(
                          width: 100,
                          child: IconButton(
                              onPressed: () async {
                                bool estado = await Alerta.borrar(context);
                                //print(estado);
                                if (estado) {
                                  // _myDatabase.delete_Evento(eventos[index]);
                                  setState(() {
                                    getDataFromDb();
                                  });
                                }
                              },
                              icon: const Icon(Icons.delete)),
                        ),
                      ),
                    );
                  },
                  itemCount: count,
                ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            /*  final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NuevoProducto(
                          myDatabase: _myDatabase,
                        )));
            print("holaa  $result");
            if (result != null) {
              setState(() {
                getDataFromDb();
              });
            } */
          },
          child: const Icon(Icons.add)),
    );
  }

  EditarEvento() {}
}

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
                    return InkWell(
                      // permite la utilizacion del evento onLongPress
                      onLongPress: () {
                        print("you got it ");
                      },
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const NuevoPedido()));
                          },
                          title: Text('Entrega ${eventos[index].fecha}'),
                        ),
                      ),
                    );
                  },
                  itemCount: count,
                ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NuevoEvento()));
          },
          child: const Icon(Icons.add)),
    );
  }

  EditarEvento() {}
}

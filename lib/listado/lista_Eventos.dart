import 'package:flutter/material.dart';
import 'package:pedidos/componentes/utilidades.dart';
import 'package:pedidos/modelo/eventos.dart';
import '../modelo/db.dart';
import 'encabezados_pedidos.dart';

class ListaEventos extends StatefulWidget {
  const ListaEventos({super.key});

  @override
  State<ListaEventos> createState() => _ListaEventosState();
}

class _ListaEventosState extends State<ListaEventos> {
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
                      onLongPress: () {
                        print("generar pedidos resumenes");
                      },
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            Utilidades.idEvento = eventos[index].id;
                            Utilidades.fechaEvento = eventos[index].fecha;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Encabezados()));
                          },
                          title: Text('Entrega ${eventos[index].fecha}'),
                        ),
                      ),
                    );
                  },
                  itemCount: count,
                ),
    );
  }
}

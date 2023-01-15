import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:pedidos/componentes/utilidades.dart';
import 'package:pedidos/modelo/eventos.dart';
import 'package:pedidos/pedidos/nuevo_pedido.dart';
import 'package:sqflite/sqflite.dart';

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
                            Utilidades.idEvento=eventos[index].id;
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
            datechoicer();
          },
          child: const Icon(Icons.add)),
    );
  }

  datechoicer() {
    int year = DateTime.now().year;
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(year, 1, 1),
        maxTime: DateTime(year, 12, 31),
        onChanged: (date) {}, onConfirm: (date) {
      // realizar insert y cerrar
      String dateString = date.toString().substring(0, 10);
      guardarEvento(dateString, _myDatabase);
    }, currentTime: DateTime.now(), locale: LocaleType.es);
  }

  guardarEvento(String fecha, DB myDatabase) async {
    Evento evento = Evento(id: null, fecha: fecha, estado: 1);
    if (await myDatabase.inset_Eventos(evento) > 0) {
      // ignore: use_build_context_synchronously
      Alerta.mensaje(context, "${evento.fecha} Agregado ", Colors.green);
      setState(() {
        getDataFromDb();
      });
    }
  }
}

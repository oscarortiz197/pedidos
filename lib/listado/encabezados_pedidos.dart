import 'package:flutter/material.dart';
import 'package:pedidos/componentes/utilidades.dart';
import 'package:pedidos/listado/detalles.dart';
import 'package:pedidos/modelo/encabazo_pedido.dart';
import 'package:pedidos/modelo/eventos.dart';
import '../modelo/db.dart';

class Encabezados extends StatefulWidget {
  const Encabezados({super.key});

  @override
  State<Encabezados> createState() => _EncabezadosState();
}

class _EncabezadosState extends State<Encabezados> {
  bool isLoading = true;
  List<Encabezado> encabezados = List.empty(growable: true);
  final DB _myDatabase = DB();
  int count = 0;

  getDataFromDb() async {
    await _myDatabase.initializeDatabase();
    List<Map<String, Object?>> map = await _myDatabase.getListaEncabezado();
    for (int i = 0; i < map.length; i++) {
      encabezados.add(Encabezado.toEmp(map[i]));
      Utilidades.listaEncabezado.add(map[i]['id']as int);
     print(map[i]);
    }
    print(Utilidades.listaEncabezado);
    count = encabezados.length;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    encabezados.clear();
    Utilidades.listaEncabezado.clear();
    getDataFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrega   ${Utilidades.fechaEvento}"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : encabezados.isEmpty
              ? const Center(
                  child: Text('Aun no hay pedidos '),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Utilidades.idEncabezado=index;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const  Detalles() ));
                        },
                        title: Text('Cliente: ${encabezados[index].cliente}'),
                      ),
                    );
                  },
                  itemCount: count,
                ),
    );
  }

  
  }
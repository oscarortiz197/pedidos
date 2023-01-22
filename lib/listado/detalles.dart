import 'package:flutter/material.dart';
import 'package:pedidos/componentes/alertas.dart';
import 'package:pedidos/componentes/utilidades.dart';
import '../modelo/db.dart';

class Detalles extends StatefulWidget {
  const Detalles({super.key});

  @override
  State<Detalles> createState() => _DetallesState();
}

class _DetallesState extends State<Detalles> {
  final DB _myDatabase = DB();
  List<Map<String, Object?>> map = [];
  double total = 0;

  getDataFromDb() async {
    await _myDatabase.initializeDatabase();
    map = await _myDatabase
        .getListaPedido(Utilidades.listaEncabezado[Utilidades.idEncabezado]);
      
    for (int i = 0; i < map.length; i++) {
      total += (map[i]["cantidad"] as int) * (map[i]["precio"] as double);
    }
    setState(() {});
  }

  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getDataFromDb();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (map.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Detalles de pedido"),
          ),
          body: const Text("Sin datos"));
    } else {
      return Scaffold(
        appBar: AppBar(
          title:const Text("Detalles de pedido"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      if (Utilidades.idEncabezado > 0) {
                        Utilidades.idEncabezado -= 1;
                        getDataFromDb();
                      } else {
                        Alerta.mensaje(
                            context,
                            "Este es el primer registro de la lista",
                            Colors.black);
                      }
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                    color: const Color.fromARGB(255, 219, 213, 213),
                    iconSize: 60),
                SizedBox(
                  width: size.width - 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                          child: Text(
                        map[0]["cliente"].toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      )),
                      Container(
                        margin: EdgeInsets.only(top: 50, bottom: 50),
                        height: size.height - 350,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                  title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(map[index]['cantidad'].toString()),
                                  Text(map[index]['nombre'].toString()),
                                ],
                              )),
                            );
                          },
                          itemCount: map.length,
                        ),
                      ),
                      Text(
                        "Total a pagar  $total",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 17),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (Utilidades.listaEncabezado[Utilidades.idEncabezado] !=
                        Utilidades.listaEncabezado[Utilidades.listaEncabezado.length-1]) {
                      Utilidades.idEncabezado += 1;
                      getDataFromDb();
                    } else {
                      Alerta.mensaje(
                          context,
                          "Este es el ultimo registro de la lista",
                          Colors.black);
                    }
                  },
                  icon: const Icon(Icons.arrow_forward_ios_outlined),
                  iconSize: 60,
                  color: const Color.fromARGB(255, 219, 213, 213),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

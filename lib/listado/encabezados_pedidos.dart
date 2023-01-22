import 'package:flutter/material.dart';
import 'package:pedidos/componentes/utilidades.dart';
import 'package:pedidos/listado/detalles.dart';
import 'package:pedidos/modelo/encabazo_pedido.dart';
import 'package:pedidos/modelo/eventos.dart';
import 'package:printing/printing.dart';
import '../modelo/db.dart';
import 'package:pdf/widgets.dart' as pw;

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
      Utilidades.listaEncabezado.add(map[i]['id'] as int);
      // print(map[i]);
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
                          Utilidades.idEncabezado = index;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Detalles()));
                        },
                        title: Text('Cliente: ${encabezados[index].cliente}'),
                      ),
                    );
                  },
                  itemCount: count,
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getPedidos();
        },
        child: const Icon(Icons.print),
      ),
    );
  }

  void getPedidos() async {
    List<Map<String, Object?>> mapZ = [];
    List<Map<String, Object?>> map = [];
    List<double> totales = [];
    double total = 0;
    await _myDatabase.initializeDatabase();

    for (int i = 0; i < Utilidades.listaEncabezado.length; i++) {
      map = await _myDatabase.getListaPedido(Utilidades.listaEncabezado[i]);
      print(map[i]["cliente"]);
      // mapZ.addAll([map[i]["cliente"]]);
      for (int j = 0; j < map.length; j++) {
        print('${map[j]["cantidad"]}  ${map[j]["nombre"]}  ');
        total += (map[j]["cantidad"] as int) * (map[j]["precio"] as double);
      }
      totales.add(total);
      total = 0;
    }
    print(map);
    // pdf
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
        build: (pw.Context context) => pw.Column(children: [
              pw.Table(children: [
                for (int i = 0; i < Utilidades.listaEncabezado.length; i++)
                  //  map = await _myDatabase.getListaPedido(Utilidades.listaEncabezado[i]);
                  pw.TableRow(children: [
                    pw.Column(children: [pw.Text("${map[i]["cliente"]}")])
                  ])
              ])
            ])));
    Printing.sharePdf(bytes: await pdf.save(), filename: 'example.pdf');

    //print(totales);
    // setState(() {});
  }
}


import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pedidos/componentes/alertas.dart';
import 'package:pedidos/componentes/utilidades.dart';
import 'package:pedidos/listado/detalles.dart';
import 'package:pedidos/modelo/encabazo_pedido.dart';
import 'package:pedidos/modelo/producto.dart';
import 'package:pedidos/pedidos/editar_pedido.dart';
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
    encabezados = [];
    await _myDatabase.initializeDatabase();
    List<Map<String, Object?>> map = await _myDatabase.getListaEncabezado();
    for (int i = 0; i < map.length; i++) {
      encabezados.add(Encabezado.toEmp(map[i]));
      Utilidades.listaEncabezado.add(map[i]['id'] as int);
    }

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
                    return InkWell(
                      onLongPress: () async {
                        Utilidades.idEncabezado = encabezados[index].id;

                        int resultado = await Alerta.dialogoOpciones(context);
                        if (resultado == 1) {
                          List<Map<String, Object?>> map;
                          List<Producto> productos = [];
                          List can = [];

                          map =
                              await _myDatabase.getListaPedidoEventoCliente1();
                          for (int i = 0; i < map.length; i++) {
                            productos.add(Producto.toEmp(map[i]));
                            can.add(map[i]['cantidad']);
                          }
                          Utilidades.cliente = encabezados[index].cliente;
                          Utilidades.idEliminar = map[0]["idencabezado"] as int;
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditarPedido(
                                        anterior: productos,
                                        can: can,
                                      )));
                        } else if (resultado == 2) {
                          if (await _myDatabase
                                  .delete_Encabezado(encabezados[index]) >
                              0) {
                            getDataFromDb();
                            setState(() {});
                          }
                        }
                      },
                      child: Card(
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
    List<Map<String, dynamic>> data = [];
    List<Map<String, dynamic>> db = [];
    String cliente = "";
    double total = 0;
    List pro = [];
    List cantidad = [];
    for (int i = 0; i < Utilidades.listaEncabezado.length; i++) {
      db = await _myDatabase.getListaPedido(Utilidades.listaEncabezado[i]);
      cliente = db[0]["cliente"];
      total = 0;
      for (int j = 0; j < db.length; j++) {
        total += ((db[j]["cantidad"] as int) * db[j]["precio"]);
        pro.add(db[j]["nombre"]);
        cantidad.add(db[j]["cantidad"]);
      }
      data.add({
        "cliente": cliente,
        "productos": pro,
        "cantidades": cantidad,
        "total": total
      });
      pro = [];
      cantidad = [];
    }

    List<pw.Widget> widgets = [];

//*********************** */*************** */*************** */
    widgets.add(pw.Center(
        child:
            pw.Text("FECHA DE ENTREGA ${Utilidades.fechaEvento}")));
    widgets.add(pw.SizedBox(height: 10));
    for (int i = 0; i < data.length; i++) {
      widgets.add(pw.SizedBox(height: 2));
      widgets.add(pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            pw.Text(data[i]['cliente']),
            pw.Text('total \$${data[i]['total']}')
          ]));
      widgets.add(pw.SizedBox(height: 5));
      widgets.add(pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            pw.Container(width: 150, child: pw.Text("producto")),
            pw.Text("cantidad")
          ]));
      widgets.add(pw.SizedBox(height: 5));

      for (int j = 0; j < data[i]["productos"].length; j++) {
        widgets.add(pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              pw.Container(
                  width: 150,
                  child: pw.Text(data[i]['productos'][j].toString())),
              pw.Text(data[i]['cantidades'][j].toString()),
            ]));
      }
      widgets.add(pw.Divider());
    }
//*************** */*************** */*************** */*************** */*************** */
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4, build: (context) => widgets));
    Printing.sharePdf(bytes: await pdf.save(), filename: 'pedido_cliente.pdf');
  }
}

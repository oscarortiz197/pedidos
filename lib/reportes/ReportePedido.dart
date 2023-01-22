import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';

import 'package:pedidos/componentes/alertas.dart';
import 'package:pedidos/componentes/utilidades.dart';
import 'package:pedidos/main.dart';
import 'package:pedidos/modelo/db.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Reportes extends StatefulWidget {
  const Reportes({super.key});

  @override
  State<Reportes> createState() => _ReportesState();
}

class _ReportesState extends State<Reportes> {
  final DB myDatabase = DB();
  List<Map<String, Object?>> _pedidos = [];
  double _precio = 0;
  double _costo = 0;
  int _totalProductos = 0;
  List<int> cantidad = [];
  List<String> producto = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataBase();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reportes"),
      ),
      body: producto.isNotEmpty
          ? SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: 280,
                  height: size.height - 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(Utilidades.fechaEvento),
                      Container(
                        margin: const EdgeInsets.only(top: 45),
                        height: 350,
                        child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                    title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(cantidad[index].toString()),
                                    Text(producto[index]),
                                  ],
                                )),
                              );
                            },
                            itemCount: producto.length //productos.length,
                            ),
                      ),
                      Column(children: [
                        Text("Costo del pedido $_costo "),
                        Text("Total venta $_precio "),
                        Text("Ganancia ${_precio - _costo} "),
                      ]),
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: Text("No existen reportes para este evento"),
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final pdf = pw.Document();

            pdf.addPage(pw.Page(
                build: (pw.Context context) => pw.Column(children: [
                      pw.Table(children: [
                        pw.TableRow(children: [
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text(
                                  "PEDIDO PARA EL PROVEEDOR ${Utilidades.fechaEvento}",
                                  style: pw.TextStyle(
                                      fontSize: 16,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.SizedBox(height: 40)
                              ]),
                          pw.SizedBox(height: 15)
                        ]),
                        pw.TableRow(children: [
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("PRODUCTO",
                                    style: pw.TextStyle(
                                        fontSize: 12,
                                        fontWeight: pw.FontWeight.bold)),
                                pw.Divider(thickness: 1)
                              ]),
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("CANTIDAD",
                                    style: pw.TextStyle(
                                        fontSize: 12,
                                        fontWeight: pw.FontWeight.bold)),
                                pw.Divider(thickness: 1)
                              ])
                        ]),
                        for (var i = 0; i < producto.length; i++)
                          pw.TableRow(children: [
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.Text(producto[i],
                                      style: pw.TextStyle(fontSize: 12)),
                                  pw.Divider(thickness: 1)
                                ]),
                            pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.Text(cantidad[i].toString(),
                                      style: pw.TextStyle(fontSize: 12)),
                                  pw.Divider(thickness: 1)
                                ]),
                          ]),
                        pw.TableRow(children: [
                          pw.Text(
                            "Total: ${_costo}",
                          )
                        ])
                      ])
                    ])));

            Printing.sharePdf(bytes: await pdf.save(), filename: 'example.pdf');
          },
          child: const Icon(Icons.print)),
    );
  }

  getDataBase() async {
    _pedidos = await myDatabase.getListaPedidos();

    int idpro = 0;
    int contador = 0;
    String nombrePro = "";
    if (_pedidos.isNotEmpty) {
      idpro = _pedidos[0]["idProducto"] as int;
      _totalProductos = _pedidos.length;
      nombrePro = (_pedidos[0]["nombre"].toString());
    }
    for (var element in _pedidos) {
      print(element["nombre"].toString() +
          " : " +
          element["cantidad"].toString() +
          " : " +
          element["costo"].toString());

      _precio += element["precioT"]! as double;
      _costo += element["costoT"] as double;
      if (idpro != element["idProducto"]) {
        idpro = element["idProducto"] as int;
        cantidad.add(contador);
        producto.add(nombrePro);
        nombrePro = (element['nombre'].toString());
        contador = 0; //element["cantidad"] as int;
        contador = element["cantidad"] as int;
      } else {
        contador += element['cantidad'] as int;
      }
    }
    cantidad.add(contador);
    producto.add(nombrePro);

    setState(() {});
  }
}

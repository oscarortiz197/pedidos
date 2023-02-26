import 'package:flutter/material.dart';
import 'package:pedidos/componentes/utilidades.dart';
import 'package:pedidos/modelo/db.dart';
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
                                    // arreglar esto
                                    title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      child: Text(cantidad[index].toString()),
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Text(producto[index].toString()),
                                    ),
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
            List<pw.Widget> widgets = [];
            final pdf = pw.Document();
            widgets.add(
              pw.Center(
                child: pw.Text(
                  "PEDIDO PARA EL PROVEEDOR ${Utilidades.fechaEvento}",
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
              ),
            );
            widgets.add(pw.SizedBox(height: 20));
            widgets.add(pw.Table(children: [
              pw.TableRow(children: [
                pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                      children: [
                        pw.Container(width: 200, child: pw.Text("CANTIDAD")),
                        pw.Container(
                          width: 200,
                          child: pw.Text("PRODUCTO"),
                        )
                      ]),
                ),
              ]),
            ]));
            widgets.add(pw.Divider());

            for (var i = 0; i < producto.length; i++) {
              // ignore: curly_braces_in_flow_control_structures
              widgets.add(pw.Table(children: [
                pw.TableRow(children: [
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                      children: [
                        pw.Container(
                            width: 150, child: pw.Text(cantidad[i].toString())),
                        pw.Container(
                          width: 150,
                          child: pw.Text(producto[i].toString()),
                        ),
                      ]),
                ]),
              ]));
              widgets.add(pw.Divider());
            }

            widgets.add(pw.Text(
              "Total: $_costo",
            ));
            pdf.addPage(pw.MultiPage(
              build: (context) => widgets,
            ));

            Printing.sharePdf(
                bytes: await pdf.save(), filename: 'pedido_proveedor.pdf');
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

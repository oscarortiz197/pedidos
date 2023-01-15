import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Alerta {
  static mensaje(BuildContext context, String mensaje, Color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(backgroundColor: Color, content: Text(mensaje)));
  }

  static Future<int> dialogoOpciones(BuildContext context) async {
    int opcion = 0;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Elige una opción'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.of(context).pop();
                    opcion = 2;
                  },
                  child: const Text('Eliminar'),
                ),
                SimpleDialogOption(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    opcion = 1;
                    // devolver 1
                  },
                  child: const Text('Editar'),
                ),
              ],
            ),
          ),
        );
      },
    );
    return opcion;
  }

  static Future<bool> borrar(BuildContext context) async {
    bool estado = false;
    await Alert(
      context: context,
      type: AlertType.warning,
      title: "Advertencia",
      style: const AlertStyle(
        descTextAlign: TextAlign.start,
      ),
      desc: "Ésta apunto de borrar un registro",
      buttons: [
        DialogButton(
          onPressed: () async {
            estado = true;
            Navigator.pop(context);
          },
          child: const Text(
            "Borrar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: Colors.red,
        ),
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancelar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
    return estado;
  }
}

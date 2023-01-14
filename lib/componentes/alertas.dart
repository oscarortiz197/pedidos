import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Alerta {

  static mensaje(BuildContext context,String mensaje,Color){
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Color,
                          content: Text(mensaje)));
  }


   static Future <bool> borrar(BuildContext context)async {
    bool estado=false;
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
             estado=true;
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

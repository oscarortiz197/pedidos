import 'package:flutter/material.dart';


class NuevoEvento extends StatelessWidget {
  const NuevoEvento({super.key});

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Nuevo Producto"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
             margin: EdgeInsets.symmetric(vertical: 30),
             width: 280,
             height:size.height>400? size.height-180 :300 ,
            child: Column(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:  [
               Text("calendario"),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Guardar"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
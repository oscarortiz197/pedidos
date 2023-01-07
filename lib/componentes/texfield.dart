import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Texto extends StatelessWidget {
  const Texto({super.key, required this.controller, required this.msj});
  final controller;
  final String msj;
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(labelText: msj),
      controller: controller,
  );
  }
}

class NumInt extends StatelessWidget {
  const NumInt({super.key, required this.controller, required this.msj});
  final controller;
  final String msj;
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(labelText: msj),
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*$'))],
    );
  }
}


class NumDouble extends StatelessWidget {
  const NumDouble({super.key, required this.controller, required this.msj});
  final  controller;
  final String msj;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: msj, ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (String value) {},
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
      ],
    );
  }
}
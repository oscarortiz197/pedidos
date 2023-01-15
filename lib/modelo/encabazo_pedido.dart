class Encabezado {
  final int? id;
  final int? idEvento;
  final String cliente;
  

  Encabezado({required this.id, required this.idEvento, required this.cliente});

  // convert to Map
  Map<String, dynamic> toMap() => {"id": id, "idEvento": idEvento, "cliente": cliente};
  // convert Map to event
  factory Encabezado.toEmp(Map<String, dynamic> map) =>
      Encabezado(id: map["id"], idEvento: map["idEvento"], cliente: map["cliente"]);
}

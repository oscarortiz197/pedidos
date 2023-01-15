class Detalle {
  final int? id;
  final int? idEncabezado;
  final int? idProducto;
  final int? cantidad;
  

  Detalle({required this.id, required this.idEncabezado, required this.idProducto,required this.cantidad});

  // convert to Map
  Map<String, dynamic> toMap() => {"id": id, "idEncabezado": idEncabezado, "idProducto": idProducto,"cantidad":cantidad};
  // convert Map to event
  factory Detalle.toEmp(Map<String, dynamic> map) =>
      Detalle(id: map["id"], idEncabezado: map["idEncabezado"], idProducto: map["idProducto"],cantidad: map["cantidad"]);
}

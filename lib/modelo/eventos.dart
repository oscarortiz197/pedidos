class Evento {
  final int? id;
  final String fecha;
  final int? estado;

  Evento({required this.id, required this.fecha, required this.estado});

  // convert to Map
  Map<String, dynamic> toMap() => {"id": id, "fecha": fecha, "estado": estado};
  // convert Map to event
  factory Evento.toEmp(Map<String, dynamic> map) =>
      Evento(id: map["id"], fecha: map["fecha"], estado: map["estado"]);
}

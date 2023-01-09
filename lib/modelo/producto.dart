class Producto {
  final int? id;
  final String nombre;
  final double costo;
  final double precio;

  Producto({
    required this.id,
    required this.nombre,
    required this.costo,
    required this.precio,
  });

  // convert to Map
  Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "costo": costo,
        "precio": precio,
      };
  // convert Map to Employee
  factory Producto.toEmp(Map<String, dynamic> map) => Producto(
        id: map["id"],
        nombre: map["nombre"],
        costo: map["costo"],
        precio: map["precio"],
      );
}

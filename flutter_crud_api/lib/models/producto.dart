class Producto {
  final String id;
  final String nombre;
  final double precio;

  Producto({required this.id, required this.nombre, required this.precio});

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['_id'],
      nombre: json['nombre'],
      precio: (json['precio'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'nombre': nombre, 'precio': precio};
}

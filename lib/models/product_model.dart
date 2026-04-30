class Product {
  String id;
  String nombre;
  double precio;
  int stock;
  String categoria;
  bool activo;

  Product({required this.id, required this.nombre, required this.precio, required this.stock, required this.categoria, this.activo = true});

  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'precio': precio,
    'stock': stock,
    'categoria': categoria,
    'activo': activo,
  };
}
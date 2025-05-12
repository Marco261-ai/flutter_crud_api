import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';

class ApiService {
  static const String baseUrl =
      'https://crudcrud.com/api/370a98d816174f5488f5fb00a4a946cc/productos';

  Future<List<Producto>> getProductos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Producto.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener productos');
    }
  }

  Future<void> addProducto(Producto producto) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(producto.toJson()),
    );
  }

  Future<void> updateProducto(String id, Producto producto) async {
    await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(producto.toJson()),
    );
  }

  Future<void> deleteProducto(String id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}

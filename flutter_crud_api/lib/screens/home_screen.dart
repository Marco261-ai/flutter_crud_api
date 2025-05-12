import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/api_service.dart';
import 'add_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final api = ApiService();
  late Future<List<Producto>> productos;

  @override
  void initState() {
    super.initState();
    productos = api.getProductos();
  }

  void _refresh() {
    setState(() {
      productos = api.getProductos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: FutureBuilder(
        future: productos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final p = items[index];
                return ListTile(
                  title: Text(p.nombre),
                  subtitle: Text('\$${p.precio}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await api.deleteProducto(p.id);
                      _refresh();
                    },
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditScreen(producto: p),
                      ),
                    );
                    _refresh();
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditScreen()),
          );
          _refresh();
        },
      ),
    );
  }
}

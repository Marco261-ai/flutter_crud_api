import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/api_service.dart';

class AddEditScreen extends StatefulWidget {
  final Producto? producto;

  const AddEditScreen({super.key, this.producto});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final api = ApiService();

  late TextEditingController _nombreController;
  late TextEditingController _precioController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(
      text: widget.producto?.nombre ?? '',
    );
    _precioController = TextEditingController(
      text: widget.producto?.precio.toString() ?? '',
    );
  }

  void _guardar() async {
    if (_formKey.currentState!.validate()) {
      final producto = Producto(
        id: widget.producto?.id ?? '',
        nombre: _nombreController.text,
        precio: double.parse(_precioController.text),
      );

      if (widget.producto == null) {
        await api.addProducto(producto);
      } else {
        await api.updateProducto(producto.id, producto);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = widget.producto != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? 'Editar Producto' : 'Nuevo Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator:
                    (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _precioController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator:
                    (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardar,
                child: Text(esEditar ? 'Actualizar' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

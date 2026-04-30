import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});
  @override
  _CrudScreenState createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  final FirebaseService _service = FirebaseService();

  void _showForm(String? id, Map<String, dynamic>? data) {
    final nombreController = TextEditingController(text: data?['nombre'] ?? '');
    final precioController = TextEditingController(text: data?['precio']?.toString() ?? '');
    final stockController = TextEditingController(text: data?['stock']?.toString() ?? '');
    final catController = TextEditingController(text: data?['categoria'] ?? '');
    bool isActive = data?['activo'] ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 15, right: 15, top: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nombreController, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: precioController, decoration: const InputDecoration(labelText: 'Precio'), keyboardType: TextInputType.number),
            TextField(controller: stockController, decoration: const InputDecoration(labelText: 'Stock'), keyboardType: TextInputType.number),
            TextField(controller: catController, decoration: const InputDecoration(labelText: 'Categoría')),
            SwitchListTile(title: const Text("Activo"), value: isActive, onChanged: (val) => setState(() => isActive = val)),
            ElevatedButton(
              child: Text(id == null ? 'Crear' : 'Actualizar'),
              onPressed: () {
                _service.saveProduct({
                  'nombre': nombreController.text,
                  'precio': double.tryParse(precioController.text) ?? 0.0,
                  'stock': int.tryParse(stockController.text) ?? 0,
                  'categoria': catController.text,
                  'activo': isActive,
                }, id);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestión Moon Sweet")),
      body: StreamBuilder(
        stream: _service.products.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['nombre']),
                subtitle: Text("Precio: \$${doc['precio']} - Stock: ${doc['stock']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () => _showForm(doc.id, doc.data() as Map<String, dynamic>)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _service.deleteProduct(doc.id)),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC8A2C8),
        onPressed: () => _showForm(null, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
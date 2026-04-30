import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference products = FirebaseFirestore.instance.collection('productos');

  // Crear o Actualizar
  Future<void> saveProduct(Map<String, dynamic> data, String? id) async {
    if (id == null) {
      await products.add(data);
    } else {
      await products.doc(id).update(data);
    }
  }

  // Eliminar
  Future<void> deleteProduct(String id) async {
    await products.doc(id).delete();
  }
}
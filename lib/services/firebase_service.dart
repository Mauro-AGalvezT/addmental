import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {

  Future<User?> getCurrentUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser;
  }

  Future<void> insertData(String collectionName, Map<String, dynamic> data) async {
    final CollectionReference collection = FirebaseFirestore.instance.collection(collectionName);

    try {
      await collection.add(data);
      print('Datos insertados correctamente en la colección "$collectionName" de Firestore');
    } catch (e) {
      print('Error al insertar datos en Firestore: $e');
      throw Exception('Error al insertar datos en Firestore');
    }
  }

  Future<List<Map<String, dynamic>>> getData(String collectionName) async {
    final CollectionReference collection = FirebaseFirestore.instance.collection(collectionName);

    try {
      final snapshot = await collection.get();
      final List<Map<String, dynamic>> dataList = [];

      snapshot.docs.forEach((QueryDocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        dataList.add(data);
      });

      return dataList;
    } catch (e) {
      print('Error al obtener datos de Firestore: $e');
      throw Exception('Error al obtener datos de Firestore');
    }
  }
}
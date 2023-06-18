import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {

  Future<User?> getCurrentUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser;
  }

  Future<void> insertData(String collectionName, Map<String, dynamic> data) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      await db.collection(collectionName).add(data);
      print('Datos insertados correctamente en la colección "$collectionName" de Firestore');
    } catch (e) {
      print('Error al insertar datos en Firestore: $e');
      throw Exception('Error al insertar datos en Firestore');
    }
  }

  Future<List<Map<String, dynamic>>> getData(String collectionName) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    User? currentUser = await getCurrentUser();

    try {
      final DateTime now = DateTime.now();
      final DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

      final DateTime yesterdayStart = DateTime(yesterday.year, yesterday.month, yesterday.day, 0, 0, 0);
      final DateTime yesterdayEnd = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);

      final double startTimestamp = yesterdayStart.millisecondsSinceEpoch.toDouble();
      final double endTimestamp = yesterdayEnd.millisecondsSinceEpoch.toDouble();

      final querySnapshot = await db
          .collection(collectionName)
          .where('email', isEqualTo: currentUser?.email)
          .where('time', isGreaterThanOrEqualTo: startTimestamp)
          .where('time', isLessThanOrEqualTo: endTimestamp)
          .get();
      print('Documentos encontrados: ${querySnapshot.size}');
      final List<Map<String, dynamic>> dataList = [];

      querySnapshot.docs.forEach((QueryDocumentSnapshot doc) {
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
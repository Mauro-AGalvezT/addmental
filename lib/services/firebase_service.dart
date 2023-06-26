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

  Future<double> getLastScoreData(String collectionName) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    try {

      final querySnapshot = await db
          .collection(collectionName)
          .doc(userId)
          .collection('history')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      final doc = querySnapshot.docs.first;
      final data = doc.data();
      return data['score'].toDouble();
    } catch (e) {
      print('Error al obtener ultimo score de $collectionName: $e');
      throw Exception('Error al obtener ultimo score de $collectionName');
    }
  }

  Future<List<Map<String, dynamic>>> getLastDayData(String collectionName) async {
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

  Future<List<Map<String, dynamic>>> getLastSevenDaysPrediction(String collectionName) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    User? currentUser = await getCurrentUser();

    try {
      final DateTime now = DateTime.now();
      final DateTime endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
      final DateTime startDate = endDate.subtract(const Duration(days: 7));

      final int startTimestamp = startDate.millisecondsSinceEpoch;
      final int endTimestamp = endDate.millisecondsSinceEpoch;

      final querySnapshot = await db
          .collection(collectionName)
          .where('email', isEqualTo: currentUser?.email)
          .where('time', isGreaterThanOrEqualTo: startTimestamp)
          .where('time', isLessThanOrEqualTo: endTimestamp)
          .orderBy('time', descending: true)
          .get();
      print('Documentos encontrados: ${querySnapshot.size}');
      final List<Map<String, dynamic>> dataList = [];

      // Agrupar los documentos por día
      final Map<DateTime, List<QueryDocumentSnapshot>> groupedData = {};

      querySnapshot.docs.forEach((QueryDocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        final int timestamp = data['time'];
        final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp.toInt());

        final DateTime date = DateTime(dateTime.year, dateTime.month, dateTime.day);

        if (!groupedData.containsKey(date)) {
          groupedData[date] = [];
        }

        groupedData[date]!.add(doc);
      });

      // Obtener el último registro de cada día
      groupedData.forEach((date, docs) {
        final QueryDocumentSnapshot lastDoc = docs.last;
        final data = lastDoc.data() as Map<String, dynamic>;
        dataList.add(data);
      });

      return dataList;
    } catch (e) {
      print('Error al obtener datos de Firestore: $e');
      throw Exception('Error al obtener datos de Firestore');
    }
  }
}
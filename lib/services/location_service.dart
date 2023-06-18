import 'package:addmental/model/user_location.dart';
import 'package:addmental/services/firebase_service.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';

class LocationService {
  static Future<void> init() async {
    await getLocationInBackground();
    List<UserLocation> userLocation = await getLastDayUserLocations();
    BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15, // Intervalo de tiempo en segundos
        stopOnTerminate: false,
        enableHeadless: true,
        startOnBoot: true,
      ),
          (String taskId) async {
        try {
          await getLocationInBackground();
          BackgroundFetch.finish(taskId);
        } catch (e) {
          print('Error al obtener la ubicación en segundo plano: $e');
          BackgroundFetch.finish(taskId);
        }
      },
    );
  }
  static Future<Map<String, dynamic>> locationDataToMap(LocationData locationData) async{
    FirebaseService firebaseService = FirebaseService();
    User? currentUser = await firebaseService.getCurrentUser();
    return {
      'email': currentUser?.email,
      'latitude': locationData.latitude,
      'longitude': locationData.longitude,
      'accuracy': locationData.accuracy,
      'verticalAccuracy': locationData.verticalAccuracy,
      'altitude': locationData.altitude,
      'speed': locationData.speed,
      'speedAccuracy': locationData.speedAccuracy,
      'heading': locationData.heading,
      'time': locationData.time,
    };
  }

  static Future<void> getLocationInBackground() async {
    Location location = Location();
    FirebaseService firebaseService = FirebaseService();
    location.enableBackgroundMode(enable: true);

    await ensureLocationServiceEnabled(location);
    await ensureLocationPermissionGranted(location);

    LocationData locationData = await location.getLocation();
    DateTime dateTime = DateTime.now();
    print('$dateTime Ubicación en segundo plano (periódica): ${locationData.latitude}, ${locationData.longitude}');
    try {
      await firebaseService.insertData('locations',await locationDataToMap(locationData));
    } catch (e) {
      print('Error al insertar datos en Firestore: $e');
    }
  }

  static Future<void> ensureLocationServiceEnabled(Location location) async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception('Servicio de ubicación desactivado por el usuario');
      }
    }
  }

  static Future<void> ensureLocationPermissionGranted(Location location) async {
    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        throw Exception('Permiso de ubicación denegado');
      }
    }
  }

  static Future<List<UserLocation>> getLastDayUserLocations() async {
    FirebaseService firebaseService = FirebaseService();
    try {
      List<Map<String, dynamic>> dataList = [];
      List<UserLocation> userLocationList = [];

      // Obtener datos de ubicación desde Firebase
      dataList = await firebaseService.getData('locations');

      // Procesar los datos de ubicación
      for (Map<String, dynamic> data in dataList) {
        UserLocation userLocation = UserLocation(
          email: data['email'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          accuracy: data['accuracy'],
          verticalAccuracy: data['verticalAccuracy'],
          altitude: data['altitude'],
          speed: data['speed'],
          speedAccuracy: data['speedAccuracy'],
          heading: data['heading'],
          time: data['time'],
        );
        userLocationList.add(userLocation);
      }
      print('user location list length ${userLocationList.length}');
      return userLocationList;
    } catch (e) {
      print('Error al obtener datos de ubicación: $e');
      throw Exception('Error al obtener datos de ubicación');
    }
  }
}
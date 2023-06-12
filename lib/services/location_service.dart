import 'package:geolocator/geolocator.dart';
import 'package:background_fetch/background_fetch.dart';

class LocationService {
  static Future<void> init() async {
    // Verificar el estado actual del permiso de ubicación
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Si el permiso está denegado, solicitarlo al usuario
      permission = await Geolocator.requestPermission();
      print('Permiso otorgado:');
    }
    print('Permiso no denegado:');
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      print('Permiso validado');
      print('Testear obtener ubi');
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        double speed = position.speed;
        // Utiliza la posición obtenida para realizar las acciones necesarias
        print('Ubicación actual test: ${position.latitude}, ${position.longitude}');
        print('Velocidad actual test: $speed m/s');
      } catch (e) {
        // Maneja cualquier error que pueda ocurrir durante la obtención de la ubicación
        print('Error al obtener la ubicación test: $e');
      }
      BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15, // Intervalo de tiempo en segundos
        stopOnTerminate: false,
        enableHeadless: true,
        startOnBoot: true,
      ), (String taskId) async {
        // Obtener la ubicación actual
        print('Obtener ubi real:');
        try {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          double speed = position.speed;
          // Utiliza la posición obtenida para realizar las acciones necesarias
          print('Ubicación actual test: ${position.latitude}, ${position.longitude}');
          print('Velocidad actual: $speed m/s');
        } catch (e) {
          // Maneja cualquier error que pueda ocurrir durante la obtención de la ubicación
          print('Error al obtener la ubicación real o velocidad: $e');
        }
        // Completar la tarea en segundo plano
        BackgroundFetch.finish(taskId);
      }, (String taskId) {
        // Manejar el tiempo de espera de la tarea en segundo plano aquí
        print('timeout');
        print(taskId);
        // Completar la tarea en segundo plano
        BackgroundFetch.finish(taskId);
      },);
    }
  }
}
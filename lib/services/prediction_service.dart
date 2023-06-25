import 'package:addmental/model/prediction_request.dart';
import 'package:addmental/model/prediction_response.dart';
import 'package:addmental/util/constants.dart';
import 'package:addmental/util/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/user_location.dart';
import 'firebase_service.dart';
import 'location_service.dart';

class PredictionService {
  Future<PredictionResponse> predictDepression() async {
    PredictionRequest request = await processDataForPredictDepression();
    FirebaseService firebaseService = FirebaseService();
    User? currentUser = await firebaseService.getCurrentUser();
    const url = '$PREDICTION_API_BASE_URL/depression';
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = request.toJson();

    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body) as Map<String, dynamic>;
      PredictionResponse predictionResponse = PredictionResponse.fromJson(jsonBody);
      final DateTime now = DateTime.now();
      await firebaseService.insertData('predictions', {
        'variance': predictionResponse.variance,
        'totalDistance': predictionResponse.totalDistance,
        'movementTime': predictionResponse.movementTime,
        'averageSpeed': predictionResponse.averageSpeed,
        'testScore': predictionResponse.testScore,
        'email': currentUser?.email,
        'result': predictionResponse.result == 'Si'? 1 : 0,
        'time': now.millisecondsSinceEpoch.toInt()
      });
      print('Predicción de depresión registrada correctamente');
      return predictionResponse;
    } else {
      throw Exception(
          'Failed to predict depression. Status code: ${response.statusCode}');
    }
  }

  Future<PredictionResponse> predictAnxiety() async {
    PredictionRequest request = await processDataForPredictAnxiety();
    FirebaseService firebaseService = FirebaseService();
    User? currentUser = await firebaseService.getCurrentUser();

    const url = '$PREDICTION_API_BASE_URL/anxiety';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = request.toJson();

    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body) as Map<String, dynamic>;
      PredictionResponse predictionResponse = PredictionResponse.fromJson(jsonBody);
      final DateTime now = DateTime.now();
      await firebaseService.insertData('anxietypredictions', {
        'variance': predictionResponse.variance,
        'totalDistance': predictionResponse.totalDistance,
        'movementTime': predictionResponse.movementTime,
        'averageSpeed': predictionResponse.averageSpeed,
        'testScore': predictionResponse.testScore,
        'email': currentUser?.email,
        'result': predictionResponse.result == 'Si'? 1 : 0,
        'time': now.millisecondsSinceEpoch.toInt()
      });
      print('Predicción de ansiedad registrada correctamente');
      return predictionResponse;
    } else {
      throw Exception(
          'Failed to predict anxiety. Status code: ${response.statusCode}');
    }
  }

  Future<PredictionRequest> processDataForPredictDepression() async {
    FirebaseService firebaseService = FirebaseService();
    List<UserLocation> userLocations = await LocationService.getLastDayUserLocations();
    List<double> latitudes = userLocations.map((location) => location.latitude).toList();
    List<double> longitudes = userLocations.map((location) => location.longitude).toList();
    List<double> speeds = userLocations.map((location) => location.speed).toList();

    double variance = calculateLocationVariance(latitudes, longitudes);
    double totalDistance = calculateTotalDistance(latitudes, longitudes);
    double averageSpeed = calculateAverageSpeed(speeds);
    double movementTime = calculateMovementTime(totalDistance, averageSpeed, variance);
    double testScore = await firebaseService.getLastScoreData(DEPRESSION_TEST_COLLECTION);

    PredictionRequest predictionRequest = PredictionRequest(
        variance: variance.toString(),
        totalDistance: totalDistance.toString(),
        movementTime: movementTime.toString(),
        averageSpeed: averageSpeed.toString(),
        testScore: testScore.toString());

    return predictionRequest;
  }

  Future<PredictionRequest> processDataForPredictAnxiety() async {
    FirebaseService firebaseService = FirebaseService();
    List<UserLocation> userLocations = await LocationService.getLastDayUserLocations();
    List<double> latitudes = userLocations.map((location) => location.latitude).toList();
    List<double> longitudes = userLocations.map((location) => location.longitude).toList();
    List<double> speeds = userLocations.map((location) => location.speed).toList();

    double variance = calculateLocationVariance(latitudes, longitudes);
    double totalDistance = calculateTotalDistance(latitudes, longitudes);
    double averageSpeed = calculateAverageSpeed(speeds);
    double movementTime = calculateMovementTime(totalDistance, averageSpeed, variance);
    double testScore = await firebaseService.getLastScoreData(ANXIETY_TEST_COLLECTION);

    PredictionRequest predictionRequest = PredictionRequest(
        variance: variance.toString(),
        totalDistance: totalDistance.toString(),
        movementTime: movementTime.toString(),
        averageSpeed: averageSpeed.toString(),
        testScore: testScore.toString());

    return predictionRequest;
  }
}

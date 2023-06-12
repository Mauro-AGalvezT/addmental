import 'package:addmental/model/prediction_request.dart';
import 'package:addmental/model/prediction_response.dart';
import 'package:addmental/util/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MentalHealthService {

  Future<PredictionResponse> predictDepression(PredictionRequest request) async {
    const url = '$PREDICTION_API_BASE_URL/depression';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = request.toJson();

    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body) as Map<String, dynamic>;
      return PredictionResponse.fromJson(jsonBody);
    } else {
      throw Exception('Failed to predict depression. Status code: ${response.statusCode}');
    }
  }

  Future<PredictionResponse> predictAnxiety(PredictionRequest request) async {
    const url = '$PREDICTION_API_BASE_URL/anxiety';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = request.toJson();

    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body) as Map<String, dynamic>;
      return PredictionResponse.fromJson(jsonBody);
    } else {
      throw Exception('Failed to predict anxiety. Status code: ${response.statusCode}');
    }
  }
}
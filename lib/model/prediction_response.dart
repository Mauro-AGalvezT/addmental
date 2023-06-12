class PredictionResponse {
  final String result;

  PredictionResponse({required this.result});

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(result: json['result'] as String);
  }
}
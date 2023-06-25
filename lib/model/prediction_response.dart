class PredictionResponse {
  String variance;
  String totalDistance;
  String movementTime;
  String averageSpeed;
  String testScore;
  String result;

  PredictionResponse(
      {required this.variance,
      required this.totalDistance,
      required this.movementTime,
      required this.averageSpeed,
      required this.testScore,
      required this.result});

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
        variance: json['variance'] as String,
        totalDistance: json['total_distance'] as String,
        movementTime: json['movement_time'] as String,
        averageSpeed: json['average_speed'] as String,
        testScore: json['test_score'] as String,
        result: json['result'] as String,
    );
  }
}

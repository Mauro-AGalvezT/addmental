class PredictionRequest {
  String variance;
  String totalDistance;
  String movementTime;
  String averageSpeed;
  String testScore;

  PredictionRequest({
    required this.variance,
    required this.totalDistance,
    required this.movementTime,
    required this.averageSpeed,
    required this.testScore,
  });

  Map<String, String> toJson() {
    return {
      'variance': variance,
      'total_distance': totalDistance,
      'movement_time': movementTime,
      'average_speed': averageSpeed,
      'test_score': testScore,
    };
  }
}
import 'dart:math' as math;

const double RADIUS_OF_EARTH_KM = 6371;

double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
  double latDistance = _toRadians(lat2 - lat1);
  double lonDistance = _toRadians(lon2 - lon1);
  double a = math.pow(math.sin(latDistance / 2), 2) +
      math.cos(_toRadians(lat1)) *
          math.cos(_toRadians(lat2)) *
          math.pow(math.sin(lonDistance / 2), 2);
  double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  double distance = RADIUS_OF_EARTH_KM * c;
  return distance;
}

double _toRadians(double degree) {
  return degree * math.pi / 180;
}

double calculateTotalDistance(List<double> latitudes, List<double> longitudes) {
  if (latitudes.length != longitudes.length) {
    throw Exception('Las listas de latitudes y longitudes deben tener la misma longitud');
  }

  double totalDistance = 0.0;

  for (int i = 0; i < latitudes.length - 1; i++) {
    double lat1 = latitudes[i];
    double lon1 = longitudes[i];
    double lat2 = latitudes[i + 1];
    double lon2 = longitudes[i + 1];

    double distance = haversineDistance(lat1, lon1, lat2, lon2);
    totalDistance += distance;
  }

  return totalDistance;
}

double calculateLocationVariance(List<double> latitudes, List<double> longitudes) {
  if (latitudes.length != longitudes.length) {
    throw Exception('Las listas de latitudes y longitudes deben tener la misma longitud');
  }

  int n = latitudes.length;
  double sumLatitude = 0.0;
  double sumLongitude = 0.0;

  for (int i = 0; i < n; i++) {
    sumLatitude += latitudes[i];
    sumLongitude += longitudes[i];
  }

  double meanLatitude = sumLatitude / n;
  double meanLongitude = sumLongitude / n;

  double sumLatitudeVariance = 0.0;
  double sumLongitudeVariance = 0.0;

  for (int i = 0; i < n; i++) {
    double latitudeDeviation = latitudes[i] - meanLatitude;
    double longitudeDeviation = longitudes[i] - meanLongitude;
    sumLatitudeVariance += math.pow(latitudeDeviation, 2);
    sumLongitudeVariance += math.pow(longitudeDeviation, 2);
  }

  double latitudeVariance = sumLatitudeVariance / n;
  double longitudeVariance = sumLongitudeVariance / n;

  double locationVariance = math.log(latitudeVariance + longitudeVariance);

  return locationVariance;
}

double calculateAverageSpeed(List<double> speeds) {
  if (speeds.isEmpty) {
    throw Exception('La lista de velocidades está vacía');
  }
  double sum = 0.0;
  for (double speed in speeds) {
    sum += speed;
  }
  double averageSpeed = sum / speeds.length;
  return averageSpeed;
}

double calculateMovementTime(double totalDistance, double averageSpeed, double variance){
  return totalDistance*0.1;
}

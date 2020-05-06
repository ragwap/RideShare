import 'package:latlong/latlong.dart';

class LocationLatLng {
  double dLatitude;
  double dLongitude;
  double pLatitude;
  double pLongitude;
  static double fare;
  static String pickup;
  static String destination;

  LocationLatLng({
    this.dLatitude,
    this.dLongitude,
    this.pLatitude,
    this.pLongitude
  });

  double calculateFare(double pickupLat, double pickupLng, double destLat, double destLng) {
    Distance distance = Distance();
    double distanceInM = 0;
    double fare = 0;

    distanceInM += distance.as(LengthUnit.Meter, LatLng(pickupLat, pickupLng), LatLng(destLat, destLng));

    fare += (distanceInM / 1000) * 50;

    return fare;

  }
}
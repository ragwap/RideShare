import 'package:geolocation/geolocation.dart';

class Location {

  Future getPermission() async {
    try{
      final GeolocationResult result = await Geolocation.requestLocationPermission(permission: const LocationPermission(
        android: LocationPermissionAndroid.fine
      ));

      return result;

    }
    catch(e) {
      print(e.toString());
    }
  }

  Future getLocation() async {
    try {
      return getPermission().then((result) async {
        if(result.isSuccessful) {
          final coords = await Geolocation.currentLocation(accuracy: LocationAccuracy.best);
          return coords;
        }
        return null;
      });
    }
    catch(e) {

    }

  }
}
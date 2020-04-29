import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = "AIzaSyD0AFY6FU9-ZWw6ADKaJOgFW1h9nPfpZtk";

class GoogleMapsServices {
  Future <String> getRoute(LatLng l1, LatLng l2) async {
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=AIzaSyD0AFY6FU9-ZWw6ADKaJOgFW1h9nPfpZtk";

    http.Response resp = await http.get(url);

    Map values = jsonDecode(resp.body);
    return values["routes"][0]["overview_polyline"]["points"];
  }

}
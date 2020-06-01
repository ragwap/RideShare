import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = "API_KEY";

class GoogleMapsServices {
  Future <String> getRoute(LatLng l1, LatLng l2) async {
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=<API_KEY>";

    http.Response resp = await http.get(url);

    Map values = jsonDecode(resp.body);
    return values["routes"][0]["overview_polyline"]["points"];
  }

}
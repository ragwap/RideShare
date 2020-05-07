import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as loc;
import 'package:ride_share/commons/loading.dart';
import 'package:ride_share/models/location_latlng.dart';
import 'package:ride_share/screens/fare/fare.dart';
import 'package:ride_share/screens/home/home.dart';
import 'package:ride_share/services/GoogleMapsServices.dart';
import 'package:ride_share/services/auth.dart';

import '../wrapper.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  loc.Location _locationTracker = loc.Location();
  Marker marker;
  Circle circle;
  StreamSubscription _subscription;
  var _counter = 0;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  static const apiKey = "AIzaSyD0AFY6FU9-ZWw6ADKaJOgFW1h9nPfpZtk";

  TextEditingController pickupController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  bool modifiedPickup = false;

  LocationLatLng locationLatLng = LocationLatLng();

  final AuthService _auth = AuthService();
  GoogleMapController _controller;
  static LatLng _defaultPosition;
  LatLng _finalPosition = _defaultPosition;
  final Set<Marker> _marker = {};
  final Set<Polyline> _polyline = {};
  MapType _currentMapType = MapType.terrain;

  double _manipLat;
  double _manipLng;

  bool destinationAdded = false;

  Prediction _predictPickup;
  Prediction _predictDestination;

  void _getUserLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemark = await Geolocator()
          .placemarkFromCoordinates(position.latitude, position.longitude);

      _manipLat = position.latitude;
      _manipLng = position.longitude;

      setState(() {
        _defaultPosition = LatLng(position.latitude, position.longitude);
        pickupController.text = placemark[0].name;
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
  }

  void updateMarkers(loc.LocationData newLocation) {
    LatLng latLng = LatLng(newLocation.latitude, newLocation.longitude);
    this.setState(() {
      _currentMapType = MapType.terrain;
      marker = Marker(
        markerId: MarkerId("home"),
        position: latLng,
        rotation: newLocation.heading,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        // icon: Icon(Icons.location_searching),
      );
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocation.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latLng,
          fillColor: Colors.grey);
    });
  }

  void getCurrentLocation() async {
    try {
      _counter = 0;
      // var location = await _locationTracker.getLocation();

      if (_subscription != null) {
        _subscription.cancel();
      }

      _subscription =
          _locationTracker.onLocationChanged().listen((newLocation) async {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocation.latitude, newLocation.longitude),
                  tilt: 0,
                  zoom: 16.00)));
          updateMarkers(newLocation);
          List<Placemark> placemark = await Geolocator()
              .placemarkFromCoordinates(
                  newLocation.latitude, newLocation.longitude);
          if (_counter == 0) {
            _counter = _counter + 1;
            setState(() {
              pickupController.text = placemark[0].name;
            });
          }
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List decodePoly(String poly) {
    var list = poly.codeUnits;
    var newList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;

    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      newList.add(result1);
    } while (index < len);

    for (var i = 2; i < newList.length; i++) {
      newList[i] += newList[i - 2];
    }

    return newList;
  }

  void _addMarker(LatLng destination, String address) {
    setState(() {
      _marker.add(Marker(
          markerId: MarkerId(_finalPosition.toString()),
          position: destination,
          infoWindow: InfoWindow(title: address, snippet: "Let's go"),
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  void _addPolyLine(String encodedPolyLine) {
    setState(() {
      _polyline.add(Polyline(
          polylineId: PolylineId(_finalPosition.toString()),
          width: 5,
          points: convertToLatLng(decodePoly(encodedPolyLine)),
          color: Colors.black));
    });
  }

  void sendReq(String pickup, String destination) async {
    LocationLatLng.pickup = pickup;
    LocationLatLng.destination = destination;

    List<Placemark> placemark1 =
        await Geolocator().placemarkFromAddress(destination);
    locationLatLng.dLatitude = placemark1[0].position.latitude;
    locationLatLng.dLongitude = placemark1[0].position.longitude;

    List<Placemark> placemark2 =
        await Geolocator().placemarkFromAddress(pickup);
    locationLatLng.pLatitude = placemark2[0].position.latitude;
    locationLatLng.pLongitude = placemark2[0].position.longitude;

    LatLng pick = LatLng(locationLatLng.pLatitude, locationLatLng.pLongitude);
    LatLng dest = LatLng(locationLatLng.dLatitude, locationLatLng.dLongitude);
    _addMarker(dest, destination);

    String route = await _googleMapsServices.getRoute(pick, dest);
    _addPolyLine(route);
    if (_controller != null) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 192.8334901395799,
              target:
                  LatLng(locationLatLng.pLatitude, locationLatLng.pLongitude),
              tilt: 0,
              zoom: 12.00)));
    }
    setState(() {});
  }

  void sendReqDefault(String destination) async {
    LocationLatLng.destination = destination;

    List<Placemark> placemark1 =
        await Geolocator().placemarkFromAddress(destination);
    locationLatLng.dLatitude = placemark1[0].position.latitude;
    locationLatLng.dLongitude = placemark1[0].position.longitude;

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarkPick = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);

    LocationLatLng.pickup = placemarkPick[0].subAdministrativeArea;

    locationLatLng.pLatitude = position.latitude;
    locationLatLng.pLongitude = position.longitude;

    LatLng dest = LatLng(locationLatLng.dLatitude, locationLatLng.dLongitude);
    _addMarker(dest, destination);

    String route = await _googleMapsServices.getRoute(_defaultPosition, dest);
    _addPolyLine(route);
    setState(() {});
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Are you sure you want to exit maps?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () =>
                        Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          Wrapper(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var begin = Offset(0.0, 1.0);
                        var end = Offset.zero;
                        var curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    )),
                  )
                ],
              ));
    }

    return _defaultPosition == null
        ? Loading()
        : WillPopScope(
            onWillPop: _onBackPressed,
            child: SafeArea(
              child: Scaffold(
                  backgroundColor: Colors.black,
                  body: Stack(
                    children: <Widget>[
                      GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition:
                            CameraPosition(target: _defaultPosition, zoom: 12),
                        mapType: _currentMapType,
                        markers: Set.of((marker != null) ? [marker] : []),
                        circles: Set.of((circle != null) ? [circle] : []),
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        compassEnabled: true,
                        trafficEnabled: true,
                        polylines: _polyline,
                      ),
                      Positioned(
                        top: 60.0,
                        right: 15.0,
                        left: 15.0,
                        child: Container(
                          height: 60.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(1.0, 5.0),
                                    blurRadius: 10,
                                    spreadRadius: 3)
                              ]),
                          child: TextFormField(
                            onTap: () async {
                              _predictPickup = await PlacesAutocomplete.show(
                                  context: context,
                                  apiKey: apiKey,
                                  language: "lk",
                                  components: [
                                    Component(Component.country, "lk")
                                  ]);
                              modifiedPickup = true;
                              pickupController.text =
                                  _predictPickup.description;
                            },
                            controller: pickupController,
                            validator: (val) =>
                                val.isEmpty ? 'Enter Pickup' : null,
                            decoration: InputDecoration(
                                icon: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.black,
                                  ),
                                ),
                                labelText: 'Pickup'),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 120.0,
                        right: 15.0,
                        left: 15.0,
                        child: Container(
                          height: 60.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(1.0, 5.0),
                                    blurRadius: 10,
                                    spreadRadius: 3)
                              ]),
                          child: TextFormField(
                            onTap: () async {
                              _predictDestination =
                                  await PlacesAutocomplete.show(
                                      context: context,
                                      apiKey: apiKey,
                                      language: "en",
                                      components: [
                                    Component(Component.country, "lk")
                                  ]);
                              destinationController.text =
                                  _predictDestination.description;
                            },
                            controller: destinationController,
                            validator: (val) =>
                                val.isEmpty ? 'Enter Destination' : null,
                            decoration: InputDecoration(
                                icon: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Icon(
                                    Icons.business,
                                    color: Colors.black,
                                  ),
                                ),
                                labelText: 'Destination'),
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 60,
                          right: 150,
                          left: 150,
                          child: Visibility(
                            visible: destinationAdded,
                            child: FloatingActionButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              heroTag: 'fare',
                              child: Text('Fare'),
                              backgroundColor: Colors.black,
                              onPressed: () {
                                LocationLatLng.fare =
                                    locationLatLng.calculateFare(
                                        locationLatLng.pLatitude,
                                        locationLatLng.pLongitude,
                                        locationLatLng.dLatitude,
                                        locationLatLng.dLongitude);
                                Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      FareView(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    var begin = Offset(0.0, 1.0);
                                    var end = Offset.zero;
                                    var curve = Curves.ease;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ));
                              },
                            ),
                          )),
                      Positioned(
                        bottom: 60,
                        right: 20,
                        child: new FloatingActionButton(
                          heroTag: 'addTrip',
                          child: Icon(Icons.add),
                          backgroundColor: Colors.black,
                          onPressed: () {
                            destinationAdded = true;
                            if (modifiedPickup) {
                              sendReq(pickupController.text,
                                  destinationController.text);
                            } else {
                              sendReqDefault(destinationController.text);
                            }
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 60,
                        left: 20,
                        child: new FloatingActionButton(
                            heroTag: 'myLocation',
                            child: Icon(Icons.location_searching),
                            backgroundColor: Colors.black,
                            onPressed: () {
                              getCurrentLocation();
                            }),
                      ),
                    ],
                  )),
            ),
          );
  }
}

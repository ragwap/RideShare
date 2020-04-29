import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as loc;
import 'package:ride_share/commons/loading.dart';
import 'package:ride_share/services/GoogleMapsServices.dart';
import 'package:ride_share/services/auth.dart';


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

  final AuthService _auth = AuthService();
  GoogleMapController _controller;
  static LatLng _defaultPosition;
  LatLng _finalPosition = _defaultPosition;
  final Set<Marker> _marker = {};
  final Set<Polyline> _polyline = {};
  MapType _currentMapType = MapType.terrain;

  double _manipLat;
  double _manipLng;

  Prediction _predictPickup;
  Prediction _predictDestination;

//  static CameraPosition _initialPosition = CameraPosition(
//
//      target: LatLng(6.927079, 79.861244),
//      zoom: 14.0
//  );

  void _getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List <Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);

    _manipLat = position.latitude;
    _manipLng = position.longitude;

    setState(() {
      _defaultPosition = LatLng(position.latitude, position.longitude);
      print(_defaultPosition.longitude);
      pickupController.text = placemark[0].name;
//      _initialPosition = CameraPosition(
//          target: _defaultPosition,
//          zoom: 14.0
//      );
      print(placemark[0].name);
    });
  }


  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
//      mapController.
    });
  }

//  Future <Uint8List> getMarker() async {
//    ByteData bd = await DefaultAssetBundle.of(context).load("assets/Webp.net-resizeimage.png");
//    return bd.buffer.asUint8List();
//  }

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
//        icon: BitmapDescriptor.fromBytes(imgData)
      );
      circle = Circle(
        circleId: CircleId("car"),
        radius: newLocation.accuracy,
        zIndex: 1,
        strokeColor: Colors.blue,
        center: latLng,
        fillColor: Colors.grey
      );
    });
  }

  void getCurrentLocation() async {
    try{
      _counter = 0;
//      Uint8List imgData = await getMarker();
      var location = await _locationTracker.getLocation();
      
//      updateMarkers(location);

      if(_subscription != null) {
        _subscription.cancel();
      }

      _subscription = _locationTracker.onLocationChanged().listen((newLocation) async {
        if(_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(newLocation.latitude, newLocation.longitude),
            tilt: 0,
            zoom: 16.00
          )));
          updateMarkers(newLocation);
          List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(newLocation.latitude, newLocation.longitude);
//          print(placemark[0].country);
          if(_counter == 0) {
            _counter = _counter + 1;
            setState(() {
              pickupController.text = placemark[0].name;
              print(placemark[0].subAdministrativeArea);
            });
          }

        }
      });

    }
    on PlatformException catch (e) {
      if(e.code == 'PERMISSION DENIED') {
        debugPrint("Permission Denied");
      }
    }

  }

  List <LatLng> convertToLatLng(List points) {
    List <LatLng> result = <LatLng>[];
    for(int i = 0; i < points.length; i++) {
      if(i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List decodePoly(String poly) {
    var list  = poly.codeUnits;
    var newList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;

    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |=(c & 0x1F) << (shift *5);
        index++;
        shift++;
      }while(c >= 32);
      if(result & 1==1) {
        result =~ result;
      }
      var result1 = (result >> 1) * 0.00001;
      newList.add(result1);
    }while(index < len);

    for(var i = 2; i < newList.length; i++) {
      newList[i] += newList[i-2];
    }
    print(newList.toString());

    return newList;
  }

  void _addMarker(LatLng destination, String address) {
    setState(() {
      _marker.add(Marker(
        markerId: MarkerId(_finalPosition.toString()),
        position: destination,
        infoWindow: InfoWindow(
          title: address,
          snippet: "Let's go"
        ),
        icon: BitmapDescriptor.defaultMarker
      ));
    });
  }

  void _addPolyLine(String encodedPolyLine) {
    setState(() {
      _polyline.add(Polyline(
          polylineId: PolylineId(_finalPosition.toString()),
          width: 5,
          points: convertToLatLng(decodePoly(encodedPolyLine)),
          color: Colors.black
      ));


    });
  }

  void sendReq(String pickup, String destination) async {
    List <Placemark> placemark1 = await Geolocator().placemarkFromAddress(destination);
    double dLatitude = placemark1[0].position.latitude;
    double dLongitude = placemark1[0].position.longitude;

    List <Placemark> placemark2 = await Geolocator().placemarkFromAddress(pickup);
    double pLatitude = placemark2[0].position.latitude;
    double pLongitude = placemark2[0].position.longitude;

    LatLng pick = LatLng(pLatitude, pLongitude);
    LatLng dest = LatLng(dLatitude, dLongitude);
    _addMarker(dest, destination);

    String route = await _googleMapsServices.getRoute(pick, dest);
    _addPolyLine(route);
    setState(() {

    });
  }

  void sendReqDefault(String destination) async {
    List <Placemark> placemark1 = await Geolocator().placemarkFromAddress(destination);
    double dLatitude = placemark1[0].position.latitude;
    double dLongitude = placemark1[0].position.longitude;

    LatLng dest = LatLng(dLatitude, dLongitude);
    _addMarker(dest, destination);

    String route = await _googleMapsServices.getRoute(_defaultPosition, dest);
    _addPolyLine(route);
    setState(() {

    });
  }


  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
  }

//  _onCameraMove(CameraPosition position) {
//    _lastMapPosition = position.target;
//  }

  @override
  Widget build(BuildContext context) {
    return _defaultPosition == null ? Loading()
        : SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
            body: Stack(
              children: <Widget>[
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(target: _defaultPosition, zoom: 12),
                  mapType: _currentMapType,
                  markers: Set.of((marker != null) ? [marker] : []),
                  circles: Set.of((circle != null) ? [circle] : []),
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  compassEnabled: true,
//              onCameraMove: _onCameraMove,
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
                        spreadRadius: 3
                      )
                    ]
                  ),
                  child: TextFormField(
                    onTap: () async {
                      _predictPickup = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: apiKey,
                          language: "lk",
                          components: [
                            Component(Component.country, "lk")
                          ]
                      );
                      // if (modifiedPickup) {
                        modifiedPickup = true;
                        pickupController.text = _predictPickup.description;                        
                      // }

                    },
                    controller: pickupController,
                    validator: (val) => val.isEmpty ? 'Enter Latitude coordinate' : null,
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Icon(Icons.location_on, color: Colors.black,),
                      ),
                        labelText: 'Pickup'
                    ),
//                    keyboardType: TextInputType.number,
//                                onChanged: (val) {
//                                  setState(() {
//                                    email = val;
//                                  });
//                                }
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
                              spreadRadius: 3
                          )
                        ]
                    ),
                    child: TextFormField(
                      onTap: () async {
                        _predictDestination = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: apiKey,
                            language: "en",
                            components: [
                              Component(Component.country, "lk")
                            ]
                        );
                        // if (_predictDestination != null) {
                          destinationController.text = _predictDestination.description;
                        // }
                        
                      },
                      controller: destinationController,
                      validator: (val) => val.isEmpty ? 'Enter Destination' : null,
                      decoration: InputDecoration(
                          icon: Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Icon(Icons.business, color: Colors.black,),
                          ),
                          labelText: 'Destination'
                      ),
//                      keyboardType: TextInputType.number,
//                                onChanged: (val) {
//                                  setState(() {
//                                    email = val;
//                                  });
//                                }
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  right: 85,
                  left: 85,
                  child: Container(
                    height: 70.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(1.0, 5.0),
                              blurRadius: 10,
                              spreadRadius: 3
                          )
                        ]
                    ),
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                          icon: Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Icon(Icons.monetization_on, color: Colors.black,),
                          ),
                          labelText: 'Fare'
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  right: 20,
                  child: FloatingActionButton(
                    heroTag: 'addTrip',
                      child: Icon(Icons.add),
                      backgroundColor: Colors.black,
                      onPressed: () {
                        if (modifiedPickup) {
                          sendReq(pickupController.text, destinationController.text);
                        }
                        else {
                          sendReqDefault(destinationController.text);
                        }
                        
                      },
//                    onPressed: sendReq(pickupController.text.toString()),
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
                      }
                  ),
                ),
              ],
            )

      ),
    );
  }
}

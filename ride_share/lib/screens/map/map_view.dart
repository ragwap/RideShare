import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ride_share/services/auth.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  StreamSubscription _subscription;

  final AuthService _auth = AuthService();
  GoogleMapController _controller;
//  static const LatLng _center = const LatLng(45.521563, -122.677433);
//  final Set<Marker> _marker = {};
//  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.terrain;



  _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
//      mapController.
    });
  }

  static final CameraPosition initialPosition = CameraPosition(
      target: LatLng(6.927079, 79.861244),
      zoom: 14.0
  );

//  Future <Uint8List> getMarker() async {
//    ByteData bd = await DefaultAssetBundle.of(context).load("assets/Webp.net-resizeimage.png");
//    return bd.buffer.asUint8List();
//  }

  void updateMarkers(LocationData newLocation) {
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
//      Uint8List imgData = await getMarker();
      var location = await _locationTracker.getLocation();
      
      updateMarkers(location);

      if(_subscription != null) {
        _subscription.cancel();
      }

      _subscription = _locationTracker.onLocationChanged().listen((newLocation) {
        if(_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(newLocation.latitude, newLocation.longitude),
            tilt: 0,
            zoom: 18.00
          )));
          updateMarkers(newLocation);
        }
      });

    }
    on PlatformException catch (e) {
      if(e.code == 'PERMISSION DENIED') {
        debugPrint("Permission Denied");
      }
    }

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
            body: Stack(
              children: <Widget>[
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: initialPosition,
                  mapType: _currentMapType,
                  markers: Set.of((marker != null) ? [marker] : []),
                  circles: Set.of((circle != null) ? [circle] : []),
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  compassEnabled: true,
//              onCameraMove: _onCameraMove,
                trafficEnabled: true,
                ),
//                FloatingActionButton(
//                  child: Icon(Icons.location_searching)
//                ),
//                Positioned(
//                    child: Card(
//                      child: Column(
//                        mainAxisSize: MainAxisSize.min,
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
////                          SizedBox(height: 20.0,),
//                          TextFormField(
//                            validator: (val) => val.isEmpty ? 'Enter Latitude coordinate' : null,
//                            decoration: InputDecoration(
//                                labelText: 'Pickup'
//                            ),
//                            keyboardType: TextInputType.number,
////                                onChanged: (val) {
////                                  setState(() {
////                                    email = val;
////                                  });
////                                }
//                          ),
//                          TextFormField(
//                            validator: (val) => val.isEmpty ? 'Enter Latitude coordinate' : null,
//                            decoration: InputDecoration(
//                              labelText: 'Destination',
//                            ),
//                            keyboardType: TextInputType.number,
////                              onChanged: (val) {
////                                cpass = val;
////                              },
//                          )
//                        ],
//                      ),
//                    )
//                ),
              Positioned(
                top: 60.0,
                right: 15.0,
                left: 15.0,
                child: Container(
                  height: 50.0,
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
                    validator: (val) => val.isEmpty ? 'Enter Latitude coordinate' : null,
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Icon(Icons.location_on, color: Colors.black,),
                      ),
                        labelText: 'Pickup'
                    ),
                    keyboardType: TextInputType.number,
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
                    height: 50.0,
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
                      validator: (val) => val.isEmpty ? 'Enter Destination' : null,
                      decoration: InputDecoration(
                          icon: Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Icon(Icons.business, color: Colors.black,),
                          ),
                          labelText: 'Destination'
                      ),
                      keyboardType: TextInputType.number,
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
                  right: 20,
                  child: FloatingActionButton(
                      child: Icon(Icons.add),
                      backgroundColor: Colors.black,
                  ),
                ),
//                Positioned(
//                  bottom: 60,
//                  left: 20,
//                  child: FloatingActionButton(
//                      child: Icon(Icons.location_searching),
//                      backgroundColor: Colors.black,
//                      onPressed: () {
//                        getCurrentLocation();
//                      }
//                  ),
//                ),
              ],
            )

      ),
    );
  }
}

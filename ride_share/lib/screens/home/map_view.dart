import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_share/services/auth.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  final AuthService _auth = AuthService();
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);
  final Set<Marker> _marker = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;

  _onMapCraeted(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
//        body: ListView(
//          children: <Widget>[
//          Row(
//            children: <Widget>[
//              SizedBox(width: 0.0,),
//              Container(
//                padding: EdgeInsets.only(left: 0),
//                child: FlatButton.icon(
//                  textColor: Colors.white,
//                  icon: Icon(Icons.keyboard_arrow_left),
//                  label: Text(''),
//                  onPressed: () async {
//                  Navigator.pop(context);
//                  },
//                ),
//              ),
//              SizedBox(width: 200.0,),
//              Container(
//                padding: EdgeInsets.only(right: 0),
//                child: FlatButton.icon(
//                  textColor: Colors.white,
//                  icon: Icon(Icons.person),
//                  label: Text('Logout'),
//                  onPressed: () async {
//                    await _auth.signOut();
//                  },
//                ),
//              ),
//            ],
//          ),
//            SizedBox(height: 30.0),
//            Padding(
//              padding: EdgeInsets.only(left: 40.0),
//              child: Row(
//                children: <Widget>[
//                  Text('Map',
//                    style: TextStyle(
//                        fontFamily: 'Montserrat',
//                        color: Colors.white,
//                        fontWeight: FontWeight.bold,
//                        fontSize: 30.0
//                    ),
//                  ),
//                  SizedBox(width: 5.0),
//                  Text('View',
//                    style: TextStyle(
//                        fontFamily: 'Montserrat',
//                        color: Colors.white,
//                        fontSize: 30.0,
//                        fontStyle: FontStyle.italic
//                    ),
//
//                  )
//                ],
//              ),
//            ),
            body: GoogleMap(
              onMapCreated: _onMapCraeted,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0
              ),
              mapType: _currentMapType,
              markers: _marker,
              onCameraMove: _onCameraMove,
            ),
//          ],
//        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_share/screens/map/map_view.dart';
import 'package:ride_share/services/auth.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/beach.png"), fit: BoxFit.cover)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ListView(
              children: <Widget>[
                SizedBox(width: 30.0,),
                Container(
                  padding: EdgeInsets.only(left: 250),
                  child: FlatButton.icon(
                    textColor: Colors.white,
                    icon: Icon(Icons.person),
                    label: Text('Logout'),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                  ),
                ),
                SizedBox(height: 30.0),
                Padding(
                  padding: EdgeInsets.only(left: 40.0),
                  child: Row(
                    children: <Widget>[
                      Text('Ride',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Text('Share',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontSize: 30.0,
                            fontStyle: FontStyle.italic
                        ),

                      )
                    ],
                  ),
                ),
                SizedBox(height: 40.0,),
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0))
                  ),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 30.0,),
//                  SizedBox(width: 30.0,),
//                  Container(
//                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
//                    child: Form(
////                        key: _formKey,
//                        child: Column(
//                          children: <Widget>[
//                            SizedBox(height: 20.0,),
//                            TextFormField(
//                                validator: (val) => val.isEmpty ? 'Enter Latitude coordinate' : null,
//                                decoration: InputDecoration(
//                                    labelText: 'Latitude'
//                                ),
//                                keyboardType: TextInputType.number,
////                                onChanged: (val) {
////                                  setState(() {
////                                    email = val;
////                                  });
////                                }
//                            ),
//                            TextFormField(
//                              validator: (val) => val.isEmpty ? 'Enter Latitude coordinate' : null,
//                              decoration: InputDecoration(
//                                labelText: 'Longitude',
//                              ),
//                              keyboardType: TextInputType.number,
////                              onChanged: (val) {
////                                cpass = val;
////                              },
//                            )
//                          ],
//                        )
//                    ),
//                  ),
                      Center(
                        child:
                        RaisedButton(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          highlightColor: Colors.black,
                          onPressed: () {
                            Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => MapView(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                var begin = Offset(0.0, 1.0);
                                var end = Offset.zero;
                                var curve = Curves.ease;

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ));
                          },
                          child: Text('Map'), textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      )


    );
  }
}

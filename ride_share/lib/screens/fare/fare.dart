import 'package:flutter/material.dart';

class FareView extends StatefulWidget {
  @override
  _FareViewState createState() => _FareViewState();
}

class _FareViewState extends State<FareView> {
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
                SizedBox(height: 30.0),
                Padding(
                  padding: EdgeInsets.only(left: 40.0),
                  child: Row(
                    children: <Widget>[
                      Text('Fare',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0
                        ),
                      ),
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
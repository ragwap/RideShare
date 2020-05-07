import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_share/services/auth.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String cpass = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: ListView(
          children: <Widget>[
          SizedBox(width: 30.0,),
          Container(
            padding: EdgeInsets.only(left: 250),
            child: FlatButton.icon(
              textColor: Colors.white,
              icon: Icon(Icons.person),
              label: Text('Login'),
              onPressed: () async {
                widget.toggleView();
              },
            ),
          ),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.only(left: 40.0),
              child: Row(
                children: <Widget>[
                  Text('Register to Ride Share',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0))
              ),
              child: ListView(
                children: <Widget>[
                  SizedBox(width: 30.0,),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 20.0,),
                            TextFormField(
                                validator: (val) => val.isEmpty ? 'Enter an Email' : null,
                                decoration: InputDecoration(
                                    labelText: 'Email'
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    email = val;
                                  });
                                }
                            ),
                            TextFormField(
                              validator: (val) => val.length < 6 ? 'Passwords should consist of 6+ characters' : null,
                              decoration: InputDecoration(
                                labelText: 'Password',
                              ),
                              obscureText: true,
                              onChanged: (val) {
                                password = val;
                              },
                            ),
                            TextFormField(
                              validator: (val) => val.length < 6 ? 'Passwords should consist of 6+ characters' : null,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                              ),
                              obscureText: true,
                              onChanged: (val) {
                                cpass = val;
                              },
                            )
                          ],
                        )
                    ),
                  ),
                  Center(
                    child:
                    RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        highlightColor: Colors.black,
                        onPressed: () async {
                          if(_formKey.currentState.validate()){
                            dynamic result = await _authService.register(email, password, cpass);

                            if(result == 'mismatch') {
                              Fluttertoast.showToast(msg: 'Passwords do not match', timeInSecForIos: 5,  backgroundColor: Colors.black, textColor: Colors.white);
                            }
                            else if (result == null) {
                              Fluttertoast.showToast(msg: 'Provide a valid email', timeInSecForIos: 5,  backgroundColor: Colors.black, textColor: Colors.white);
                            }
                            else {
                              Fluttertoast.showToast(msg: 'Successfully Registered', timeInSecForIos: 5,  backgroundColor: Colors.black, textColor: Colors.white);
                            }
                          }
                        },
                        child: Text('Register')
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

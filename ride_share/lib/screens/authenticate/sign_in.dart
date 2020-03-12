import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_share/services/auth.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

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
                label: Text('Register'),
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
                  Text('Sign In to Ride Share',
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
                              validator: (val) => val.isEmpty ? 'Enter a Password' : null,
                              decoration: InputDecoration(
                                labelText: 'Password',
                              ),
                              obscureText: true,
                              onChanged: (val) {
                                password = val;
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
//                      print(email);
//                      print(password);
                          dynamic result = await _authService.signIn(email, password);
                          if(_formKey.currentState.validate()) {
                            if (result == null) {
                              Fluttertoast.showToast(msg: 'Please provide valid credentials', timeInSecForIos: 5);
                            }
                            else {
                              Fluttertoast.showToast(
                                  msg: 'Successfully signed in', timeInSecForIos: 5);
                            }
                          }
                        },
                        child: Text('Sign In')
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
//      child: Container(
//        child: Text('authenticate'),
//      ),
    );
  }
}

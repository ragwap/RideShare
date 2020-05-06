import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_share/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _userFromFirebase(FirebaseUser user) {
    return user != null ? User(uid : user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebase);
  }


  Future signIn(String email, String password) async {
    try{
      AuthResult result =  await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
      FirebaseUser user = result.user;
      return _userFromFirebase(user);
    }
    catch (e){
      print(e.toString());
      return null;
    }
  }

  Future register(String email, String password, String cPassword) async {
    try {
      if(password == cPassword) {
        AuthResult result = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
        FirebaseUser user = result.user;
        return _userFromFirebase(user);
      }
      else {
        return 'mismatch';
      }
    }
    catch (e) {
      print(e.toString());
      return null;
    }

  }

  Future signOut() async {
    try{
      return await _auth.signOut();
    }
    catch (e) {
      return null;
    }
  }
}
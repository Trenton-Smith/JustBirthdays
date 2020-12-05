import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_birthdays/models/birthday.dart';
import 'package:just_birthdays/models/superUser.dart';
import 'package:just_birthdays/screens/home/home.dart';
import 'package:just_birthdays/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on User
  SuperUser _userFromFirebaseUser(User user) {
    return user != null ? SuperUser(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<SuperUser> get user {
    return _auth.authStateChanges()
    // .map((User user) => _userFromFirebaseUser(user));
    .map(_userFromFirebaseUser);
  }

  //sign in anon - try and catch in createBirthday
  Future signInAnon() async {
    try {
      UserCredential credential = await _auth.signInAnonymously();
      User user = credential.user;
      Home.anon = true;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = credential.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with gmail


  //register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = credential.user;

      //create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(List<Birthday>());

      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
  // Future registerWithEmailAndPassword(String email, String password) async {
  //   try {
  //     UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
  //     User user = credential.user;
  //
  //     //create a new document for the user with the uid
  //     await DatabaseService(uid: user.uid).updateUserData(Birthday());
  //
  //     return _userFromFirebaseUser(user);
  //   } catch(e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  //sign out
  Future signOut() async {
    Home.anon = false;
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}
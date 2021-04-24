import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signup_test/models/user.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:signup_test/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object base on FirebaseUser
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userformFirebaseUser);
  }

  User _userformFirebaseUser(FirebaseUser user) {
    return user != null
        ? User(
            uid: user.uid,
            displayName: user.displayName,
            photoUrl: user.photoUrl)
        : null;
  }

  //Sign in with email and password
  Future signin(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userformFirebaseUser(user);
    } catch (e) {
      var errorCode = e.code;
      print("errorCode :$errorCode");
      print("Cant Sign In error : ${e.toString()}");
      return errorCode;
    }
  }

//Sign in with Facebook

  Future FBLogin() async {
    try {
      final fb = FacebookLogin();
      final res = await fb.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ]);
      // Check result status
      switch (res.status) {
        case FacebookLoginStatus.success:
          print("success fb success!!!!!!!!!!!!!!!!!!!!");
          final FacebookAccessToken fbToken = res.accessToken;
          final AuthCredential credential =
              FacebookAuthProvider.getCredential(accessToken: fbToken.token);
          try {
            AuthResult result = await _auth.signInWithCredential(credential);
            FirebaseUser user = result.user;
            final profile = await fb.getUserProfile();
            final email = await fb.getUserEmail();
            final imageUrl =
                await fb.getProfileImageUrl(width: 500, height: 500);
            print("image url:$imageUrl");
            await DatabaseService(uid: user.uid).updateUserData(
                profile.firstName, profile.lastName, email, imageUrl);
            return _userformFirebaseUser(user);
          } catch (e) {
            var errorCode = e.code;
            print("errorCode :$errorCode");
            print("Cant Sign In error : ${e.toString()}");
            return errorCode;
          }
          break;
        case FacebookLoginStatus.cancel:
          return "FB cancel";
          break;
        case FacebookLoginStatus.error:
          return "FB error";
          break;
      }
    } catch (e) {}
  }

  //signup with email and password
  Future signup(
      String firstname, String lastname, String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      String imgurl = "";
      //create new document for the user
      await DatabaseService(uid: user.uid)
          .updateUserData(firstname, lastname, email, imgurl);
      return _userformFirebaseUser(user);
    } catch (e) {
      var errorCode = e.code;
      print("errorCode :$errorCode");
      return errorCode;
    }
  }

  //signout
  Future signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print("error : ${e.toString()}");
      return null;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:signup_test/signin.dart';
import 'package:signup_test/signup.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool Signstate=true;

  void toggleSignState(){
    setState(() {
      Signstate=!Signstate;
    });
  }

  @override
  Widget build(BuildContext context) {
   if(Signstate){
     return Signin(toggleView:toggleSignState);
   }else{
     return Signup(toggleView:toggleSignState);
   }
  }
}

import 'package:flutter/material.dart';
import 'package:signup_test/authenticate.dart';
import 'package:signup_test/home.dart';
import 'package:signup_test/models/user.dart';
import 'package:provider/provider.dart';
class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user=Provider.of<User>(context);
    if(user==null){
      return Authenticate();
    }else{
      return Home();
    }
  }
}

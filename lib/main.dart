import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signup_test/models/user.dart';
import 'package:signup_test/services/auth.dart';
import 'package:signup_test/signup.dart';
import 'package:signup_test/wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,

      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        home: Wrapper(),
      ),
    );
  }
}


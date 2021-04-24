import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:signup_test/services/auth.dart';

class Signup extends StatefulWidget {

  final Function toggleView;
  Signup({this.toggleView});
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final AuthService _auth=AuthService();
  final form_key = GlobalKey<FormState>();
  final _firstname_controller = TextEditingController();
  final _lastname_controller = TextEditingController();
  final _email_controller = TextEditingController();
  final _password_controller = TextEditingController();
  bool _obscureText = true;

  String _firstname;
  String _lastname;
  String _email;
  String _password;
  String _error="";

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void clear() {
    setState(() {
      _firstname_controller.clear();
      _lastname_controller.clear();
      _email_controller.clear();
      _password_controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('LogIn'),
            onPressed: ()  {
              widget.toggleView();
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              border: Border.all(color: Colors.blue),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Form(
              key: form_key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    Expanded(
                        child: TextFormField(
                      controller: _firstname_controller,
                      validator: (value1) {
                        RegExp exp1 = RegExp(
                            r"""[0-9\^\`\~\!\@\#\$\%\&\*\(\)\_\-\+\=\{\}\[\]\|\\\:\;\“"’'\<\,\>\.\?\๐\฿\/]""");
                        if (value1 == null || value1.isEmpty) {
                          return 'Empty';
                        } else if (exp1.hasMatch(value1)) {
                          return 'Letters only';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "First Name", icon: Icon(Icons.person)),
                          onSaved: (value)=>_firstname=value,
                    )),
                    Expanded(
                        child: TextFormField(
                      controller: _lastname_controller,
                      validator: (value1) {
                        RegExp exp1 = RegExp(
                            r"""[0-9\^\`\~\!\@\#\$\%\&\*\(\)\_\-\+\=\{\}\[\]\|\\\:\;\“"’'\<\,\>\.\?\๐\฿\/]""");
                        if (value1 == null || value1.isEmpty) {
                          return 'Empty';
                        } else if (exp1.hasMatch(value1)) {
                          return 'Letters only';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Last Name", icon: Icon(Icons.person)),
                          onSaved: (value)=>_lastname=value,
                    ))
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    Expanded(
                        child: TextFormField(
                      controller: _email_controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Empty';
                        } else if (!EmailValidator.validate(value)) {
                          return 'email not valid';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Email", suffixIcon: Icon(Icons.email_outlined)),
                          onSaved: (value)=>_email=value,
                    )),
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: _password_controller,
                        obscureText: _obscureText,

                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: _obscureText
                                  ? Icon(Icons.remove_red_eye)
                                  : Icon(Icons.remove_red_eye_outlined),
                              onPressed: _toggle,
                              color: Colors.black54,
                            ),
                            labelText: "Password"),
                            onSaved: (value)=>_password=value,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextButton(
                        child: Text("Submit"),
                            onPressed: ()async{
                              form_key.currentState.save();
                              if(form_key.currentState.validate()){
                                dynamic result=await _auth.signup(_firstname,_lastname,_email,_password);
                                if(result== 'ERROR_EMAIL_ALREADY_IN_USE'){
                                  setState(() {
                                    _error="email already in use";
                                  });
                                }else if(result == 'ERROR_WEAK_PASSWORD'){
                                  setState(() {
                                    _error="Password must have at least 7 characters";
                                  });
                                }else if(result.runtimeType.toString()!="User"){
                                  setState(() {
                                    _error="Error , Can't LogIn, Check your Internet Connection";
                                  });
                                }
                              }
                            },
                      )),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text(_error,style: TextStyle(color: Colors.red,fontSize: 15),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

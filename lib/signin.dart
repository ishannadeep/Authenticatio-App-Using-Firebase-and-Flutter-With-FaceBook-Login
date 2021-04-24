import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:signup_test/services/auth.dart';

class Signin extends StatefulWidget {
  final Function toggleView;
  Signin({this.toggleView});
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  String _password;
  String _email;
  String _error="";
  final AuthService _auth=AuthService();
  final _Signin_key = GlobalKey<FormState>();
  final _email_controller=TextEditingController();
  final _password_controller=TextEditingController();
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  void clear(){
    setState(() {
      _password_controller.clear();
      _email_controller.clear();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log In"),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Register'),
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
              key: _Signin_key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                              _Signin_key.currentState.save();
                              if(_Signin_key.currentState.validate()){
                                dynamic result=await _auth.signin(_email,_password);
                                print("Result instance type : ${result.runtimeType.toString()}");
                                if(result == 'ERROR_WRONG_PASSWORD'){
                                  print("Password is not correct");
                                  setState(() {
                                    _error="Password is not correct";
                                  });
                                }else if( result == 'ERROR_USER_NOT_FOUND'){
                                  print("User not found, Please Register or Enter correct email");
                                  setState(() {
                                    _error="User not found, Please Register or Enter correct email";
                                  });
                                }else if( result == 'FB cancel'){
                                  print("Canceled");
                                  setState(() {
                                    _error="Canceled";
                                  });
                                }else if( result == 'FB error'){
                                  print("Error");
                                  setState(() {
                                    _error="Error : can't LogIn to Fcaebook";
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
                  SizedBox(),
                  TextButton(
                    child: Text("Login With FaceBook"),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.indigo,
                      textStyle: TextStyle(
                          fontSize: 20,
                      ),
                      elevation: 5,
                      shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                    ),
                    onPressed: ()async{
                        dynamic result=await _auth.FBLogin();
                        print("Result instance type : ${result.runtimeType.toString()}");
                        if(result == 'ERROR_WRONG_PASSWORD'){
                          print("Password is not correct");
                          setState(() {
                            _error="Password is not correct";
                          });
                        }else if( result == 'ERROR_USER_NOT_FOUND'){
                          print("User not found, Please Register or Enter correct email");
                          setState(() {
                            _error="User not found, Please Register or Enter correct email";
                          });
                        }else if(result.runtimeType.toString()!="User"){
                          setState(() {
                            _error="Error , Can't LogIn, Check your Internet Connection";
                          });
                        }
                    },
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:signup_test/services/auth.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  String error = "";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(user.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot1) {
          if (!snapshot1.hasData) {
            return Text("Loading");
          }
          var userDocument = snapshot1.data;
          return Scaffold(
            appBar: AppBar(
              title: Text("Home"),
              elevation: 0.0,
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Log Out'),
                  onPressed: () async {
                    try {
                      await _auth.signout();
                    } catch (e) {
                      setState(() {
                        error =
                            "Can't Log out, Please check your internet connection";
                      });
                    }
                  },
                ),
              ],
            ),
            body: StreamBuilder<User>(
                stream: AuthService().user,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("User Info",style: TextStyle(color: Colors.indigo,fontSize: 20.0),),
                          SizedBox(height: 20,),
                          Text(userDocument['firstname'] ?? "first name",
                              style: TextStyle(fontSize: 35.0)),
                          Text(userDocument['lastname'] ?? "last name",
                              style: TextStyle(fontSize: 35.0)),
                          Text(userDocument['email'] ?? "email",
                              style: TextStyle(fontSize: 20.0)),
                          SizedBox(
                            height: 20.0,
                          ),
                          userDocument['imgurl']==null||snapshot.data.photoUrl==null?Text("Image not found",style: TextStyle(color: Colors.red),):CircleAvatar(
                            backgroundImage: NetworkImage(
                                snapshot.data.photoUrl + '?width=500&height500'),
                            radius: 60.0,
                          ),

                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
        });
  }
}

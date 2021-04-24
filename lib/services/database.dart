import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference userCollection=Firestore.instance.collection('users');

  Future updateUserData(String firstname,String lastname,String email,String imgurl)async{
    return await userCollection.document(uid).setData({
      'firstname':firstname ,
      'lastname':lastname,
      'email':email,
      'imgurl':imgurl
    });
  }

  Stream<QuerySnapshot> get users{
    return userCollection.snapshots();
  }

}
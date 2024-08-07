import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_clasifier/features/auth/data/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthServices{
  static final CollectionReference _reference = FirebaseFirestore.instance.collection('users');
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<bool> createUser(UserModel user) async {
    try {
     var data = await _auth.createUserWithEmailAndPassword(email: user.email, password: user.password);
      user.id = data.user!.uid;
      await _reference.add(user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<UserModel?> signIn(String email, String password) async {
    try {
      var user =await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(user.user != null){
        var data = await _reference.where('email', isEqualTo: email).get();
        return UserModel.fromMap(data.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
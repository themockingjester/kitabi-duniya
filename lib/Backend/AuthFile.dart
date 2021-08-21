import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';

import '../AppConstants.dart';
class AuthFile {

  Future<String> registration(String email,String password) async
  {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return "Successfully Registered!!";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      else{
        return 'Check your email!';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<UserCredential?> signInWithEmailandPassword(String email,String password,BuildContext context) async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        AppConstants().defaultSnackBarForApp(context, "This user does not exist!");
      } else if (e.code == 'wrong-password') {
        AppConstants().defaultSnackBarForApp(context, "Wrong password!");
      }
      else{
        AppConstants().defaultSnackBarForApp(context, "Something went wrong try again!");
      }
      return null;
    }
  }
}
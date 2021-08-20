import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oldshelvesupdated/AppConstants.dart';

class UserDetailsAdder{
  String pathForUserDetails = "users/details/";
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final _database = FirebaseDatabase().reference();
  Future<void> addUserInterestedTags(List<String> tags,BuildContext context) async {
    if(userId!=null){
      await _database.child(pathForUserDetails).child(userId).update({
        'interest':tags,
      }).whenComplete(() {
        AppConstants().defaultSnackBarForApp(context, "Thanks for telling us your interest!");
      }).onError((error, stackTrace) {
        AppConstants().defaultSnackBarForApp(context, 'Something went wrong with database');
      });
    }
    else{
      AppConstants().defaultSnackBarForApp(context, 'Something went wrong best suggestion is restart this app!');
    }
    Timer(const Duration(milliseconds: 1000), () {
      Navigator.pop(context);
    });
  }

  Future<void> addNewUserDetails(String name,String email,String dob,String phoneNumber,BuildContext context) async {
    if(userId!=null){
      String dateOfJoin = DateFormat("yyyy-MM-dd").format(DateTime.now());
      await _database.child(pathForUserDetails).child(userId).set({
        'name': name,
        'email': email,
        'dob': dob,
        'phone number': phoneNumber,
        'date of join': dateOfJoin
      }).whenComplete(() {
        print('done');
      }).onError((error, stackTrace) {
        print(error.toString());
      });
    }
  }
}
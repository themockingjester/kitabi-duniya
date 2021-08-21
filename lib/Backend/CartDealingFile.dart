import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:oldshelvesupdated/AppConstants.dart';

class CartDealingFile {
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase().reference();
  final commonPathForCart = 'users/cart/';

  Future<void> addThisBookToMyCart(
      BuildContext context, String bookAddress) async {
    String uid = _auth.currentUser!.uid;
    if (uid != null) {
      await _database
          .child(commonPathForCart)
          .child(uid)
          .child(bookAddress)
          .set({
        'identification name': bookAddress,
      }).whenComplete(() {
        AppConstants().defaultSnackBarForApp(context, "Added to your cart!");
      }).onError((error, stackTrace) {
        AppConstants().defaultSnackBarForApp(context,
            "We couldn't setup communication with our database! Try after sometime");
      });
    } else {
      AppConstants().defaultSnackBarForApp(context, "You are n't permitted");
    }
  }

  Future<void> removeThisBookFromMyCart(
      BuildContext context, String bookAddress) async {
    String uid = _auth.currentUser!.uid;
    if (_database != null && uid != null) {
      await _database
          .child(commonPathForCart)
          .child(uid)
          .child(bookAddress)
          .remove()
          .whenComplete(() {
        // Done
        AppConstants().defaultSnackBarForApp(context, "Done");
      }).onError((error, stackTrace) {
        // Something bad occoured
        AppConstants()
            .defaultSnackBarForApp(context, "Something bad happend try again!");
      });
    }
  }
}

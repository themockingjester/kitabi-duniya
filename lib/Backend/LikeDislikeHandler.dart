import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:oldshelvesupdated/Backend/GetBookDetails.dart';

import '../AppConstants.dart';
class LikeDislikeHandler{
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase().reference();
  final commonPathForUserDetails = 'users/details/';
  final commonPathForBooks = 'books/';
  Future<void> deleteUserDislike(String bookAddress) async {
    String path = "likesanddislikes";
    String uid = _auth.currentUser!.uid;

    if (_database != null && uid != null) {
      await _database.child(path).child('dislikes').child(bookAddress)
          .child(uid)
          .remove()
          .whenComplete(() {
        // Done
      }).onError((error, stackTrace) {
        // Something bad occoured
      });
    }
  }
  Future<void> deleteUserLike(String bookAddress) async {
    String path = "likesanddislikes";
    String uid = _auth.currentUser!.uid;

    if (_database != null && uid != null) {
      await _database.child(path).child('likes').child(bookAddress)
          .child(uid)
          .remove()
          .whenComplete(() {
        // Done
      }).onError((error, stackTrace) {
        // Something bad occoured
      });
    }
  }

  Future<void> dislikeThisBook(String bookAddress,BuildContext context) async {
    bool? isAlreadyDisliked = await checkUserDislikingForTheBook(bookAddress);
    String path="likesanddislikes";
    String uid=_auth.currentUser!.uid;

    if (_database != null && uid!=null) {
      if (isAlreadyDisliked == null) {
        AppConstants().defaultSnackBarForApp(context, "Something went wrong!");
      }
      else if (isAlreadyDisliked == false) {
        var wheatherUserLikingExist = await checkUserLikingForTheBook(bookAddress);
        if(wheatherUserLikingExist==true){
          int currentTotalLikes = int.parse(await GetBookDetails().getBookTotalLikes(bookAddress));
          currentTotalLikes--;
          if(currentTotalLikes<0){
            currentTotalLikes=0;
          }
          await _database.child(commonPathForBooks).child(bookAddress).update(
              {
                'likes':'$currentTotalLikes',
              });
        }
        await deleteUserLike(bookAddress);
        _database.child(path).child('dislikes').child(bookAddress).set({
          uid:"disliked",
        }).whenComplete(() {
          AppConstants().defaultSnackBarForApp(context, "We will try to improve next time!");
        }).onError((error, stackTrace) {
          AppConstants().defaultSnackBarForApp(context, "We couldn't setup communication with our database! Try after sometime");
        });

        int currentTotalDislikes = int.parse(await GetBookDetails().getBookTotalDisLikes(bookAddress));
        currentTotalDislikes++;
        await _database.child(commonPathForBooks).child(bookAddress).update(
            {
              'dislikes':'$currentTotalDislikes',
            });

      }
    }


  }
  Future<void> likeThisBook(String bookAddress,BuildContext context) async {
    bool? isAlreadyLiked = await checkUserLikingForTheBook(bookAddress);
    String path="likesanddislikes";
    String uid=_auth.currentUser!.uid;

    if (_database != null && uid!=null) {
      if (isAlreadyLiked == null) {
        AppConstants().defaultSnackBarForApp(context, "Something went wrong!");
      }
      else if (isAlreadyLiked == false) {
        var wheatherUserDislikingExist = await checkUserDislikingForTheBook(bookAddress);
        if(wheatherUserDislikingExist==true){
          int currentTotalDislikes = int.parse(await GetBookDetails().getBookTotalDisLikes(bookAddress));
          currentTotalDislikes--;
          if(currentTotalDislikes<0){
            currentTotalDislikes=0;
          }
          await _database.child(commonPathForBooks).child(bookAddress).update(
              {
                'dislikes':'$currentTotalDislikes',
              });
        }
        await deleteUserDislike(bookAddress);
        await _database.child(path).child('likes').child(bookAddress).set({
          uid:"liked",
        }).whenComplete(() {
          AppConstants().defaultSnackBarForApp(context, "Thanks for your like!");
        }).onError((error, stackTrace) {
          AppConstants().defaultSnackBarForApp(context, "We couldn't setup communication with our database! Try after sometime");
        });
        int currentTotalLikes = int.parse(await GetBookDetails().getBookTotalLikes(bookAddress));
        currentTotalLikes++;
        await _database.child(commonPathForBooks).child(bookAddress).update(
            {
              'likes':'$currentTotalLikes',
            });

      }
    }


  }

  Future<bool?> checkUserLikingForTheBook(String bookAddress) async {
    String path="likesanddislikes";
    String uid=_auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid!=null) {
      var data = _database.child(path).child('likes').child(bookAddress);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        if(dataSnapshot.value==null){
          return null;
        }
        Map values = dataSnapshot.value;
        return values.containsKey(uid);
      });
      if (result == null) {
        return false;
      } else {
        return true;
      }
    }
    return null;


  }
  Future<bool?> checkUserDislikingForTheBook(String bookAddress) async {
    String path="likesanddislikes";
    String uid=_auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid!=null) {
      var data = _database.child(path).child('dislikes').child(bookAddress);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        if(dataSnapshot.value==null){
          return null;
        }
        Map values = dataSnapshot.value;
        return values.containsKey(uid);
      });
      if (result == null) {
        return false;
      } else {
        return true;
      }
    }
    return null;


  }
}
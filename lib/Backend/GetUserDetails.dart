import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class GetUserDetails {
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase().reference();
  final commonPathForUserDetails = 'users/details/';

  Future<String> checkUserSuperiority() async {
    String uid = _auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid != null) {
      var data = _database.child(commonPathForUserDetails).child(uid);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        var values = dataSnapshot.value;
        return values['super'];
      });
      if (result == null) {
        return 'not exist';
      } else {
        return 'exist';
      }
    }
    return 'failed';
  }

  Future<String> checkWeHaveUserInterestTags() async {
    String uid = _auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid != null) {
      var data = _database.child('users/details/').child(uid);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        var values = dataSnapshot.value;

        return values['interest'];
      });
      if (result == null) {
        return 'not exist';
      } else {
        return 'exist';
      }
    }
    return 'failed';
  }

  Future<String> getUserName() async {
    String uid = _auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid != null) {
      var data = _database.child(commonPathForUserDetails).child(uid);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        var values = dataSnapshot.value;
        return values['name'];
      });
      if (result == null) {
        return 'not exist';
      } else {
        return result;
      }
    }
    return 'failed';
  }

  Future<List<Object?>?> getUserInterestTags() async {
    String uid = _auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid != null) {
      var data = _database.child(commonPathForUserDetails).child(uid);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        var values = dataSnapshot.value;
        return values['interest'];
      });
      if (result == null) {
        return null;
      } else {
        return result;
      }
    }
    return null;
  }
}

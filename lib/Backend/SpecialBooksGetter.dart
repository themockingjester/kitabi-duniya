import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:oldshelvesupdated/Components/VerticalCard.dart';

class SpecialBooksGetter {
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase().reference();
  final commonPathForTrendingBooks = "trending books";
  final commonPathForTopBooks = "top books";

  Future<void> fetchTrendingBooks(var functionToAddBooksInList) async {
    String uid = _auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid != null) {
      var data = _database.child(commonPathForTrendingBooks);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        if (dataSnapshot.value == null) {
          return null;
        }
        Map values = dataSnapshot.value;

        values.forEach((key, value) {
          functionToAddBooksInList(VerticalCard(key));
        });

        // return values.containsKey(bookAddress);
      });
    }
    return null;
  }

  Future<void> fetchTopBooks(var functionToAddBooksInList) async {
    String uid = _auth.currentUser!.uid;

    if (_database != null && uid != null) {
      var data = _database.child(commonPathForTopBooks);
      await data.once().then((DataSnapshot dataSnapshot) {
        if (dataSnapshot.value == null) {
          return null;
        }
        Map values = dataSnapshot.value;

        values.forEach((key, value) {
          functionToAddBooksInList(VerticalCard(key));
        });
      });
    }
    return null;
  }
}

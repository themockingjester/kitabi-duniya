import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SecurityCodes{
  String directAddingCodePath="security/directaddingcode/";
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase().reference();
  Future<String> getCodeForDirectAdding() async {
    String uid=_auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid!=null) {
      var data = _database.child(directAddingCodePath);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        var values = dataSnapshot.value;
        return values['code'];
      });
      if (result == null) {
        return 'not exist';
      } else {
        return result;
      }
    }
    return 'failed';
  }
}
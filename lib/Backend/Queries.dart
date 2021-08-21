import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:oldshelvesupdated/Backend/SearchEngine.dart';
import '../Components/VerticalCard.dart';
class Queries{
  final functionToAddBooksRelatedToUserInterestRegularly;
  Queries(@required this.functionToAddBooksRelatedToUserInterestRegularly);
  // DataSnapshot DS=await FirebaseDatabase.instance.reference().child('books').orderByChild('our price').equalTo("2").once().then((value) => value);
  // Map<dynamic, dynamic> map = DS.value;
  //
  //
  // List arr = map.values.toList();
  // for(int i = 0;i<arr.length;i++){
  // print(arr[i]['name']);
  // }
  void getBooksHavingParticularTags(List<Object?>? tags) async {
    Map addedBooks=Map();
    if(tags==null){
      return;
    }
    for(int i =0;i<tags.length;i++){
      String currentTag = (tags[i] as String).toLowerCase();
      if(await SearchEngine().wheatherInputIsAKeywordTag(currentTag)==true){
        SearchEngine().fetchRequiredBooks(currentTag, functionToAddBooksRelatedToUserInterestRegularly,'big',addedBooks);
      }
    }



  }

}
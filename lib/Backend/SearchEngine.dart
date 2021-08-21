import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:oldshelvesupdated/Backend/GetBookDetails.dart';
import 'package:oldshelvesupdated/Components/SearchResultCard.dart';
import 'package:oldshelvesupdated/Components/VerticalCard.dart';

import 'EncapsulatedContainerForNewBook.dart';

class SearchEngine{
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase().reference();
  final commonPathForKeywordTags="keyword tags";
  String covertAllToSmallerCase(String input){
    return input.toLowerCase();
  }
  List<String> convertIntoList(String input){
    return input.split(" ");
  }
  Future<bool?> wheatherInputIsAKeywordTag(String input) async {

    String uid=_auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid!=null) {
      var data = _database.child(commonPathForKeywordTags).child(input);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        if(dataSnapshot.value==null){
          return null;
        }
        // Map values = dataSnapshot.value;

        return dataSnapshot.key;
        // return values.containsKey(bookAddress);
      });
      if (result == null) {
        return false;
      } else {
        return true;
      }
    }
    return null;
  }
  bool isWordCapableOfBecomingKeywordTag(String input){
    String uid=_auth.currentUser!.uid;
    var useLessWords = {
      "by":1,"to":1,",":1,";":1,"{":1,"}":1,"[":1,"]":1,"(":1,")":1,"@":1,"*":1,"the":1,"of":1,"with":1,"and":1,

    };
    if(uid!=null){
      if(useLessWords.containsKey(input)){
        return false;
      }
      return true;
    }
    return false;

  }
  Future<void> addNewKeywordTag(EncapsulatedContainerForNewBook bookDetails) async {
    String uid=_auth.currentUser!.uid;

    if (_database != null && uid!=null) {


      String bookName = bookDetails.bookName;
      String authors = bookDetails.authorName;
      String publisherName = bookDetails.bookPublisher;
      String bookStatus = bookDetails.bookStatus;
      String bookEdition = bookDetails.bookEdition;


      List<String> tags = bookDetails.tags;

      String language = bookDetails.language;
      String uid=_auth.currentUser!.uid;
      String bookIdentificationName = '$bookName@$authors@$publisherName@$bookStatus@$bookEdition';


      if(uid!=null)
        {
          List<String> list = [bookName,authors,publisherName,bookStatus,bookEdition,language];
          for(int i = 0;i<list.length;i++)
            {
              String smallString = await SearchEngine().covertAllToSmallerCase(list[i]);
              List<String> splittedWords = await SearchEngine().convertIntoList(smallString);
              for(int j = 0;j<splittedWords.length;j++)
                {
                  var checkingExistence = await wheatherInputIsAKeywordTag(splittedWords[j]);
                  if(checkingExistence==false){
                    if(isWordCapableOfBecomingKeywordTag(splittedWords[j])){
                      await _database.child(commonPathForKeywordTags).child(splittedWords[j]).set({
                        bookIdentificationName:"true"
                      });
                    }
                  }
                  else if(checkingExistence==true){
                      await _database.child(commonPathForKeywordTags).child(splittedWords[j]).update({
                      bookIdentificationName:"true"
                      });
                  }

                }

            }

          // Now adding tags as a keyword tag

          for(int j = 0;j<tags.length;j++)
          {
            var useLessWords = {
              "by":1,"to":1,",":1,";":1,"{":1,"}":1,"[":1,"]":1,"(":1,")":1,"@":1,"*":1,"the":1,"of":1,"with":1,"and":1,

            };
            String tagInSmall = tags[j].toLowerCase();
            List<String> splittedPartsOfTags = tagInSmall.split(" ");
            for(int k=0;k<splittedPartsOfTags.length;k++){
              if(useLessWords.containsKey(splittedPartsOfTags[k])){
                continue;
              }
              var checkingExistence = await wheatherInputIsAKeywordTag(splittedPartsOfTags[k]);
              if(checkingExistence==false){
                if(isWordCapableOfBecomingKeywordTag(splittedPartsOfTags[k])){
                  await _database.child(commonPathForKeywordTags).child(splittedPartsOfTags[k]).set({
                    bookIdentificationName:"true"
                  });
                }
              }
              else if(checkingExistence==true){
                await _database.child(commonPathForKeywordTags).child(splittedPartsOfTags[k]).update({
                  bookIdentificationName:"true"
                });
              }
            }


          }

        }

    }
  }
  Future<void> fetchRequiredBooks(String input,var functionToAddBooksInList,String cardType,Map addedBooks) async {

    String uid=_auth.currentUser!.uid;

    if (_database != null && uid!=null) {
      var data = _database.child(commonPathForKeywordTags).child(input);
      await data.once().then((DataSnapshot dataSnapshot) {
        if(dataSnapshot.value==null){
          return null;
        }
        Map values = dataSnapshot.value;

        if(cardType=="big"){
          values.forEach((key, value) async {
            if(!addedBooks.containsKey(key)){
              addedBooks[key]=true;

              await functionToAddBooksInList(VerticalCard(key));
            }

          });

        }
        else{
          values.forEach((key, value) async {
            if(!addedBooks.containsKey(key)){
              addedBooks[key]=true;
              String imagePath = await GetBookDetails().getBookCoverPathAddress(key);
              await functionToAddBooksInList(SearchResultCard(key,imagePath));
            }

          });
        }
        // return values.containsKey(bookAddress);
      });

    }
    return null;
  }
}
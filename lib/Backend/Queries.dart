import 'package:flutter/cupertino.dart';
import 'package:oldshelvesupdated/Backend/SearchEngine.dart';

class Queries {
  final functionToAddBooksRelatedToUserInterestRegularly;

  Queries(@required this.functionToAddBooksRelatedToUserInterestRegularly);
  void getBooksHavingParticularTags(List<Object?>? tags) async {
    Map addedBooks = Map();
    if (tags == null) {
      return;
    }
    for (int i = 0; i < tags.length; i++) {
      String currentTag = (tags[i] as String).toLowerCase();
      if (await SearchEngine().wheatherInputIsAKeywordTag(currentTag) == true) {
        SearchEngine().fetchRequiredBooks(
            currentTag,
            functionToAddBooksRelatedToUserInterestRegularly,
            'big',
            addedBooks);
      }
    }
  }
}

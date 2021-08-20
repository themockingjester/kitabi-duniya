import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:oldshelvesupdated/Components/VerticalCard.dart';
class GetBookDetails{
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase().reference();
  final commonPathForBooks = 'books/';

  Future<String> bookRatingCalculator(String bookAddress) async {
    String totalLikesInString = await GetBookDetails().getBookTotalLikes(bookAddress);
    if(totalLikesInString=='failed'||totalLikesInString=='not exist'){
      return 'NA';
    }
    int totalLikes = int.parse(totalLikesInString);
    String totalDislikesInString = await GetBookDetails().getBookTotalDisLikes(bookAddress);
    if(totalDislikesInString=='failed'||totalDislikesInString=='not exist'){
      return 'NA';
    }
    int totalDislikes = int.parse(totalDislikesInString);
    double result= ((totalLikes)/(totalLikes+totalDislikes)*10);
    return '${result.toInt()}';

  }

  Future<String> checkIfBookExist(String bookAddress) async {
    String uid=_auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid!=null) {
      var data = _database.child(commonPathForBooks).child(bookAddress);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        var values = dataSnapshot.value;
        if(values==null){
          return null;
        }
        else{
          return values['name'];
        }

      });
      if (result == null) {
        return 'not exist';
      } else {
        return 'exist';
      }
    }
    return 'failed';
  }

  Future<String> getBookName(String bookAddress) async {
    String uid=_auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid!=null) {
      var data = _database.child(commonPathForBooks).child(bookAddress);

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

  Future<String> getBookAvailablePieces(String bookAddress) async {
    String uid=_auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid!=null) {
      var data = _database.child(commonPathForBooks).child(bookAddress);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        var values = dataSnapshot.value;
        return values['available pieces'];
      });
      if (result == null) {
        return 'not exist';
      } else {
        return result;
      }
    }
    return 'failed';
  }

  Future<String> getBookTotalLikes(String bookAddress) async {
    String uid=_auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid!=null) {
      var data = _database.child(commonPathForBooks).child(bookAddress);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        var values = dataSnapshot.value;
        return values['likes'];
      });
      if (result == null) {
        return 'not exist';
      } else {
        return result;
      }
    }
    return 'failed';
  }

  Future<String> getBookTotalDisLikes(String bookAddress) async {
    String uid=_auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid!=null) {
      var data = _database.child(commonPathForBooks).child(bookAddress);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        var values = dataSnapshot.value;
        return values['dislikes'];
      });
      if (result == null) {
        return 'not exist';
      } else {
        return result;
      }
    }
    return 'failed';
  }

  Future<String> getBookPublisher(String bookAddress) async {
    String uid=_auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid!=null) {
      var data = _database.child(commonPathForBooks).child(bookAddress);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        var values = dataSnapshot.value;
        return values['publisher'];
      });
      if (result == null) {
        return 'not exist';
      } else {
        return result;
      }
    }
    return 'failed';
  }

  Future<String> getBookAuthors(String bookAddress) async {
    String uid=_auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid!=null) {
      var data = _database.child(commonPathForBooks).child(bookAddress);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        var values = dataSnapshot.value;
        return values['authors'];
      });
      if (result == null) {
        return 'not exist';
      } else {
        return result;
      }
    }
    return 'failed';
  }

  Future<String> getBookStatus(String bookAddress) async {
    String uid=_auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid!=null) {
      var data = _database.child(commonPathForBooks).child(bookAddress);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        var values = dataSnapshot.value;
        return values['status'];
      });
      if (result == null) {
        return 'not exist';
      } else {
        return result;
      }
    }
    return 'failed';
  }
  Future<String> getBookLanguage(String bookAddress) async {
    String uid=_auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid!=null) {
      var data = _database.child(commonPathForBooks).child(bookAddress);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        var values = dataSnapshot.value;
        return values['language'];
      });
      if (result == null) {
        return 'not exist';
      } else {
        return result;
      }
    }
    return 'failed';
  }
  Future<String> getBookOverView(String bookAddress) async {
    String uid=_auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid!=null) {
      var data = _database.child(commonPathForBooks).child(bookAddress);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        var values = dataSnapshot.value;
        return values['over view'];
      });
      if (result == null) {
        return 'not exist';
      } else {
        return result;
      }
    }
    return 'failed';
  }
  Future<String> getBookEdition(String bookAddress) async {
    String uid=_auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid!=null) {
      var data = _database.child(commonPathForBooks).child(bookAddress);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        var values = dataSnapshot.value;
        return values['edition'];
      });
      if (result == null) {
        return 'not exist';
      } else {
        return result;
      }
    }
    return 'failed';
  }

  Future<String> getBookMarketPrice(String bookAddress) async {
    String uid=_auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid!=null) {
      var data = _database.child(commonPathForBooks).child(bookAddress);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        var values = dataSnapshot.value;
        return values['market price'];
      });
      if (result == null) {
        return 'not exist';
      } else {
        return result;
      }
    }
    return 'failed';
  }

  Future<String> getBookPriceByUS(String bookAddress) async {
    String uid=_auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid!=null) {
      var data = _database.child(commonPathForBooks).child(bookAddress);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        var values = dataSnapshot.value;
        return values['our price'];
      });
      if (result == null) {
        return 'not exist';
      } else {
        return result;
      }
    }
    return 'failed';
  }

  Future<String> getBookCoverPathAddress(String bookAddress) async {
    String uid=_auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid!=null) {
      var data = _database.child(commonPathForBooks).child(bookAddress);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        var values = dataSnapshot.value;
        return values['cover path'];
      });
      if (result == null) {
        return 'not exist';
      } else {
        return result;
      }
    }
    return 'failed';
  }


  Future<dynamic> getBookTags(String bookAddress) async {
    String uid=_auth.currentUser!.uid;
    dynamic result;
    if (_database != null && uid!=null) {
      var data = _database.child(commonPathForBooks).child(bookAddress);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        var values = dataSnapshot.value;
        return values['tags'];
      });
      if (result == null) {
        return 'not exist';
      } else {
        return result;
      }
    }
    return 'failed';
  }

  Future<Widget> getImage(BuildContext context,String imagepath) async {


    late CachedNetworkImage image;
    await FireStorageService.loadImage(context,imagepath).then((value){
      // widget.imageurl=value.toString();

      image = CachedNetworkImage(

        imageUrl: value.toString(),
        maxHeightDiskCache: 300,
        maxWidthDiskCache: 300,
      );
    });
    return image;
  }


}

class FireStorageService extends ChangeNotifier {
  FireStorageService();
  static Future<dynamic> loadImage(BuildContext context,String imagepath) async {

    return await FirebaseStorage.instance.ref().child(imagepath).getDownloadURL();
  }
}
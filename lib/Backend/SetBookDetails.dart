import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:oldshelvesupdated/AppConstants.dart';
import 'package:oldshelvesupdated/Backend/EncapsulatedContainerForNewBook.dart';
import 'package:oldshelvesupdated/Backend/GetBookDetails.dart';
import 'package:oldshelvesupdated/Backend/GetUserDetails.dart';
import 'package:oldshelvesupdated/Backend/SearchEngine.dart';

import 'Storage.dart';

class SetBookDetails {
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase().reference();
  final commonPathForBooks = 'books/';
  final commonPathForIncomingBooks = 'incoming books/';
  final commonPathForOutgoingBooks = 'outgoing books/';

  late String result;

  Future<String> addBookWithVerification(
      BuildContext context, EncapsulatedContainerForNewBook bookDetails) async {
    String uid = _auth.currentUser!.uid;
    String bookName = bookDetails.bookName;
    String authors = bookDetails.authorName;
    String publisherName = bookDetails.bookPublisher;
    String bookStatus = bookDetails.bookStatus;
    String bookEdition = bookDetails.bookEdition;
    String quantity = bookDetails.bookQuantity;
    String marketPrice = bookDetails.marketPrice;
    String desiredPrice = bookDetails.desiredPrice;
    String coverPath = bookDetails.coverImagePath;
    String extension = bookDetails.imageExtension;
    List<String> tags = bookDetails.tags;
    String language = bookDetails.language;
    String bookOverView = bookDetails.overView;
    String bookIdentificationName =
        '$bookName@$authors@$publisherName@$bookStatus@$bookEdition';

    coverPath =
        'books/incoming/${bookIdentificationName}/${coverPath.hashCode}$extension';
    if (uid != null) {
      await _database
          .child(commonPathForIncomingBooks)
          .child(uid)
          .child(bookIdentificationName)
          .set({
        'name': bookName,
        'authors': authors,
        'available pieces': '$quantity',
        'publisher': publisherName,
        'status': bookStatus,
        'edition': bookEdition,
        'market price': marketPrice,
        'desired price': desiredPrice,
        'cover path': coverPath,
        'tags': tags,
        'over view': bookOverView,
        'language': language,
      }).whenComplete(() {
        AppConstants().defaultSnackBarForApp(
            context, "We have received your submission!");
        result = 'done';
      }).onError((error, stackTrace) {
        AppConstants().defaultSnackBarForApp(context,
            "We couldn't setup communication with our database! Try after sometime");
        result = 'failed';
      });
      return result;
    } else {
      AppConstants()
          .defaultSnackBarForApp(context, "you don't have permission!");
      return 'failed';
    }
  }

  Future<String> buyThisBook(
      BuildContext context, EncapsulatedContainerForNewBook bookDetails) async {
    String uid = _auth.currentUser!.uid;
    String bookName = bookDetails.bookName;
    String authors = bookDetails.authorName;
    String publisherName = bookDetails.bookPublisher;
    String bookStatus = bookDetails.bookStatus;
    String bookEdition = bookDetails.bookEdition;
    String quantity = bookDetails.bookQuantity;
    String price = bookDetails.desiredPrice;
    String language = bookDetails.language;

    String bookIdentificationName =
        '$bookName@$authors@$publisherName@$bookStatus@$bookEdition';

    if (uid != null) {
      await _database
          .child(commonPathForOutgoingBooks)
          .child(uid)
          .child(bookIdentificationName)
          .set({
        'name': bookName,
        'authors': authors,
        'quantity': '$quantity',
        'publisher': publisherName,
        'status': bookStatus,
        'edition': bookEdition,
        'price': price,
        'language': language,
      }).whenComplete(() {
        AppConstants()
            .defaultSnackBarForApp(context, "We have received your order!");
        result = 'done';
      }).onError((error, stackTrace) {
        AppConstants().defaultSnackBarForApp(context,
            "We couldn't setup communication with our database! Try after sometime");
        result = 'failed';
      });
      return result;
    } else {
      AppConstants()
          .defaultSnackBarForApp(context, "you don't have permission!");
      return 'failed';
    }
  }

  Future<void> setAvailablePieces(
      BuildContext context, String bookAddress, String toBeSold) async {
    String uid = _auth.currentUser!.uid;
    String currentPieces =
        await GetBookDetails().getBookAvailablePieces(bookAddress);
    int leftOnes = int.parse(currentPieces) - int.parse(toBeSold);
    if (uid != null) {
      await _database
          .child(commonPathForBooks)
          .child(bookAddress)
          .update({'available pieces': '$leftOnes'}).whenComplete(() {
        // AppConstants().defaultSnackBarForApp(context, "We have received your order!");
        // result = 'done';
      }).onError((error, stackTrace) {
        // AppConstants().defaultSnackBarForApp(context, "We couldn't setup communication with our database! Try after sometime");
        // result = 'failed';
      });
      // return result;
    }
  }

  Future<void> addBookWithOutVerification(
      BuildContext context, EncapsulatedContainerForNewBook bookDetails) async {
    String bookName = bookDetails.bookName;
    String authors = bookDetails.authorName;
    String publisherName = bookDetails.bookPublisher;
    String bookStatus = bookDetails.bookStatus;
    String bookEdition = bookDetails.bookEdition;
    String quantity = bookDetails.bookQuantity;
    String marketPrice = bookDetails.marketPrice;
    String ourPrice = bookDetails.desiredPrice;
    String coverPath = bookDetails.coverImagePath;
    String extension = bookDetails.imageExtension;
    List<String> tags = bookDetails.tags;
    String bookOverView = bookDetails.overView;
    String language = bookDetails.language;
    String uid = _auth.currentUser!.uid;
    String bookIdentificationName =
        '$bookName@$authors@$publisherName@$bookStatus@$bookEdition';

    coverPath =
        'books/main/${bookIdentificationName}/${coverPath.hashCode}$extension';

    if (await GetUserDetails().checkUserSuperiority() == 'exist' &&
        uid != null &&
        _database != null) {
      String bookExistence =
          await GetBookDetails().checkIfBookExist(bookIdentificationName);
      int bookQuantity = int.parse(quantity);
      if (bookExistence == 'not exist') {
        await _database
            .child(commonPathForBooks)
            .child(bookIdentificationName)
            .set({
          'name': bookName,
          'authors': authors,
          'available pieces': '$bookQuantity',
          'likes': '0',
          'dislikes': '0',
          'publisher': publisherName,
          'status': bookStatus,
          'edition': bookEdition,
          'market price': marketPrice,
          'our price': ourPrice,
          'cover path': coverPath,
          'tags': tags,
          'over view': bookOverView,
          'language': language,
        }).whenComplete(() async {
          await SearchEngine().addNewKeywordTag(bookDetails);
          AppConstants().defaultSnackBarForApp(
              context, "We have received your submission!");
        }).onError((error, stackTrace) {
          AppConstants().defaultSnackBarForApp(context,
              "We couldn't setup communication with our database! Try after sometime");
        });
      } else if (bookExistence == 'exist') {
        bookQuantity = int.parse(await GetBookDetails()
                .getBookAvailablePieces(bookIdentificationName)) +
            bookQuantity;
        await _database
            .child(commonPathForBooks)
            .child(bookIdentificationName)
            .update({
          'available pieces': '$bookQuantity',
          'market price': marketPrice,
          'our price': ourPrice,
        }).whenComplete(() {
          AppConstants().defaultSnackBarForApp(context, "Successfully added!");
        }).onError((error, stackTrace) {
          AppConstants().defaultSnackBarForApp(context, error.toString());
        });
        return;
      } else {
        AppConstants().defaultSnackBarForApp(context, "Something went wrong!");
        return;
      }
    } else {
      AppConstants()
          .defaultSnackBarForApp(context, "You don't have the permission!!");
    }
  }

  Future<void> addNewBook(BuildContext context, bool DirectTrigger,
      EncapsulatedContainerForNewBook bookDetails) async {
    String bookName = bookDetails.bookName;
    String authors = bookDetails.authorName;
    String publisherName = bookDetails.bookPublisher;
    String bookStatus = bookDetails.bookStatus;
    String bookEdition = bookDetails.bookEdition;
    String imagePath = bookDetails.coverImagePath;
    String extension = bookDetails.imageExtension;

    if (DirectTrigger) {
      if (await GetUserDetails().checkUserSuperiority() == 'exist') {
        String bookIdentificationName =
            '$bookName@$authors@$publisherName@$bookStatus@$bookEdition';
        String res = await Storage()
            .uploadImageDirectly(bookIdentificationName, imagePath, extension);
        if (res == 'done') {
          // image has been uploaded!
          String? coverPath = Storage().coverPathForDirectUpload(
              bookIdentificationName, imagePath, extension);
          if (coverPath != null) {
            await addBookWithOutVerification(context, bookDetails);
          } else {
            AppConstants().defaultSnackBarForApp(
                context, 'Something went wrong,Try again!');
          }
        } else {
          AppConstants().defaultSnackBarForApp(
              context, 'Something went wrong,Try again!');
        }
      } else {
        AppConstants()
            .defaultSnackBarForApp(context, 'Something went wrong,Try again!');
        return;
      }
    } else {
      String bookIdentificationName =
          '$bookName@$authors@$publisherName@$bookStatus@$bookEdition';
      String res = await Storage()
          .uploadIncomingImage(bookIdentificationName, imagePath, extension);
      if (res == 'done') {
        String? coverPath = Storage().coverPathForIncomingImageUpload(
            bookIdentificationName, imagePath, extension);
        if (coverPath != null) {
          String res = await Storage().uploadIncomingImage(
              bookIdentificationName, imagePath, extension);
          if (res == 'done') {
            await addBookWithVerification(context, bookDetails);
          } else {
            AppConstants().defaultSnackBarForApp(context, res);
          }
        } else {
          AppConstants().defaultSnackBarForApp(
              context, 'Something went wrong,Try again!');
        }
      } else {
        AppConstants()
            .defaultSnackBarForApp(context, 'Something went wrong,Try again!');
      }
    }
  }
}

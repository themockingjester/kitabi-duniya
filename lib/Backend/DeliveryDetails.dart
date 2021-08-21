import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:oldshelvesupdated/AppConstants.dart';
import 'package:oldshelvesupdated/Backend/EncapsulatedContainerForDelieveryDetails.dart';
import 'package:oldshelvesupdated/Backend/EncapsulatedContainerForNewBook.dart';

class DeliveryDetails {
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase().reference();
  final commonPathForSavedDeliveryDetails = "users/saved delivery address/";
  final commonPathForDeliveryForSellersPending = "pending deliveries/seller/";
  final commonPathForDeliveryForBuyerPending = "pending deliveries/buyer/";

  Future<void> setNewSavedDeliveryDetails(BuildContext context,
      EncapsulatedContainerForDelieveryDetails details) async {
    String uid = _auth.currentUser!.uid;
    String address = details.address;
    String landmark = details.landmark;
    String pincode = details.pincode;
    String city = details.city;
    String phoneNumber = details.phoneNumber;
    String alternativePhoneNumber = details.alternativePhoneNumber;
    String district = details.district;
    String state = details.state;
    if (uid != null && _auth != null && _database != null) {
      await _database.child(commonPathForSavedDeliveryDetails).child(uid).set({
        'address': address,
        'landmark': landmark,
        'pincode': pincode,
        'city': city,
        'phone number': phoneNumber,
        'alternative phone number': alternativePhoneNumber,
        'district': district,
        'state': state,
      }).whenComplete(() {
        //AppConstants().defaultSnackBarForApp(context, "We have received your submission!");
      }).onError((error, stackTrace) {
        AppConstants().defaultSnackBarForApp(
            context, "failed to save your address for next time use!");
      });
    } else {
      AppConstants().defaultSnackBarForApp(context,
          "something went wrong while saving your address for next time use!");
    }
  }

  Future<EncapsulatedContainerForDelieveryDetails?> getSavedDeliveryDetails(
      BuildContext context) async {
    String uid = _auth.currentUser!.uid;

    if (uid != null) {
      if (_auth != null && _database != null) {
        var data =
            _database.child(commonPathForSavedDeliveryDetails).child(uid);
        var result = await data.once().then((DataSnapshot dataSnapshot) {
          var values = dataSnapshot.value;
          if (values == null) {
            return null;
          }
          EncapsulatedContainerForDelieveryDetails savedDeliveryDetails =
              EncapsulatedContainerForDelieveryDetails(
                  values['address'],
                  values['landmark'],
                  values['pincode'],
                  values['city'],
                  values['phone number'],
                  values['alternative phone number'],
                  values['district'],
                  values['state']);
          return savedDeliveryDetails;
        });
        if (result == null) {
          return null;
        }
        return result;
      } else {
        AppConstants().defaultSnackBarForApp(
            context, 'Something is wrong please go back to previous page!');
        return null;
      }
    } else {
      AppConstants()
          .defaultSnackBarForApp(context, 'you donot have permissions');
      return null;
    }
  }

  Future<void> setSellerDeliveryDetailsForPending(
      BuildContext context,
      EncapsulatedContainerForDelieveryDetails details,
      EncapsulatedContainerForNewBook bookDetails) async {
    String uid = _auth.currentUser!.uid;

    String bookName = bookDetails.bookName;
    String authorName = bookDetails.authorName;
    String publisherName = bookDetails.bookPublisher;
    String bookStatus = bookDetails.bookStatus;
    String bookEdition = bookDetails.bookEdition;

    String address = details.address;
    String landmark = details.landmark;
    String pincode = details.pincode;
    String city = details.city;
    String phoneNumber = details.phoneNumber;
    String alternativePhoneNumber = details.alternativePhoneNumber;
    String district = details.district;
    String state = details.state;

    String bookIdentificationName =
        '$bookName@$authorName@$publisherName@$bookStatus@$bookEdition';
    if (uid != null && _auth != null && _database != null) {
      await _database
          .child(commonPathForDeliveryForSellersPending)
          .child(uid)
          .child(bookIdentificationName)
          .set({
        'address': address,
        'landmark': landmark,
        'pincode': pincode,
        'city': city,
        'phone number': phoneNumber,
        'alternative phone number': alternativePhoneNumber,
        'district': district,
        'state': state,
      }).whenComplete(() {
        AppConstants()
            .defaultSnackBarForApp(context, "Thanks For Contributing!");
      }).onError((error, stackTrace) {
        AppConstants().defaultSnackBarForApp(
            context, "failed to save your address for next time use!");
      });
    } else {
      AppConstants().defaultSnackBarForApp(context,
          "something went wrong while saving your address for next time use!");
    }
  }

  Future<void> setBuyerDeliveryDetailsForPending(
      BuildContext context,
      EncapsulatedContainerForDelieveryDetails details,
      EncapsulatedContainerForNewBook bookDetails) async {
    String uid = _auth.currentUser!.uid;

    String bookName = bookDetails.bookName;
    String authorName = bookDetails.authorName;
    String publisherName = bookDetails.bookPublisher;
    String bookStatus = bookDetails.bookStatus;
    String bookEdition = bookDetails.bookEdition;

    String address = details.address;
    String landmark = details.landmark;
    String pincode = details.pincode;
    String city = details.city;
    String phoneNumber = details.phoneNumber;
    String alternativePhoneNumber = details.alternativePhoneNumber;
    String district = details.district;
    String state = details.state;

    String bookIdentificationName =
        '$bookName@$authorName@$publisherName@$bookStatus@$bookEdition';
    if (uid != null && _auth != null && _database != null) {
      await _database
          .child(commonPathForDeliveryForBuyerPending)
          .child(uid)
          .child(bookIdentificationName)
          .set({
        'address': address,
        'landmark': landmark,
        'pincode': pincode,
        'city': city,
        'phone number': phoneNumber,
        'alternative phone number': alternativePhoneNumber,
        'district': district,
        'state': state,
      }).whenComplete(() {
        AppConstants().defaultSnackBarForApp(context, "Thanks For Purchasing!");
      }).onError((error, stackTrace) {
        AppConstants().defaultSnackBarForApp(
            context, "failed to save your address for next time use!");
      });
    } else {
      AppConstants().defaultSnackBarForApp(context,
          "something went wrong while saving your address for next time use!");
    }
  }
}

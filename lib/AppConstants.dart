import 'dart:ui';

import 'package:flutter/material.dart';

class AppConstants {
  Color appBackgroundColor = Colors.white;

  String emailValidateRegexString = r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$";
  String emailRegexErrorTextString = "please enter a valid email!";

  String personNameValidateRegexString = r"^[a-z|A-Z]+[ ]*[a-z|A-Z]*$";
  String personNameRegexErrorTextString = "please enter a valid name!";

  String passwordValidateRegexString =
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!#%*?&]{6,20}$";
  String passwordRegexErrorTextString =
      "password must have at least one digit,one capital and small letter,one special symbol and must be of size between 6 to 20!";

  String addressValidateRegexString = r"^[a-z\s,\(\)\-A-z0-9]+$";
  String addressRegexErrorTextString =
      "only letters,digits and symbols like (,),-, are accepted";

  String landmarkValidateRegexString = r"^[a-z\s,\(\)\-A-z0-9]+$";
  String landmarkRegexErrorTextString =
      "only letters,digits and symbols like (,),-, are accepted";

  String pincodeValidateRegexString = r"(?=.*^[^0]+)(?=.*^[0-9]{6,8}$)";
  String pincodeRegexErrorTextString =
      "only numbers are accepted also donot put 0 first and digits must be 10!";

  String phoneNumberValidateRegexString = r"(?=.*^[^0]+)(?=.*^[0-9]{10}$)";
  String phoneNumberRegexErrorTextString =
      "only digits are allowed upto size 10 and nummber should not begin with 0!";

  String authorNameValidateRegexString = r"^[A-Z,\sa-z]+$";
  String authorNameRegexErrorTextString = "only letters and , are accepted";

  String marketPriceValidateRegexString = r"(?=.*^[^0]+)(?=.*^[0-9]{1,4}$)";
  String marketPriceRegexErrorTextString =
      "only price under 9999 is accepted also donot put 0 first!";

  String desiredPriceValidateRegexString = r"(?=.*^[^0]+)(?=.*^[0-9]{1,4}$)";
  String desiredPriceRegexErrorTextString =
      "only price under 9999 is accepted also donot put 0 first!";

  String publisherNameValidateRegexString = r"^[a-z\sA-z]+$";
  String publisherNameRegexErrorTextString =
      "only letters and space are accepted";

  String bookNameValidateRegexString =
      r"(?=.*^[^#]+)(?=.*^[a-z\sA-Z0-9+-@]{5,}$)";
  String bookNameRegexErrorTextString =
      "letters,digits and some symbols like +-@ are allowed";

  ButtonStyle commonElevatedButtonStyle = ElevatedButton.styleFrom(
      elevation: 10,
      primary: Colors.deepOrange, // background
      onPrimary: Colors.white, // foreground
      minimumSize: Size(double.infinity, 50));
  Color appAppBarColor = Colors.orange;

  List<String> acceptableBookConditions = ["Refurbished", "New"];

  List<String> AvailableLanguages = ["Eng", "Hin", "Hin/Eng"];
  List<String> QuantitiesForUploading = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
  ];
  List<String> AvailableTagsList = [
    'Programming',
    'Maths',
    'Science',
    'Physics',
    'Chemistry',
    'History',
    'Geography',
    'Civics',
    'Political',
    'Computer',
    'ukg',
    'lkg',
    'class9',
    'class12',
    'arts',
    'commerce',
    'ias',
    'pcs',
    'ssc',
    'cgl',
    'class8',
    'class7',
    'class6',
    'class5',
    'class4',
    'class3',
    'class2',
    'class1',
    'nursery',
    'class11',
    'class10',
    'nda',
    'communication',
    'datastructure and algorithm'
  ];
  List<String> AvailableEditions = [
    "Zero",
    "First",
    "Second",
    "Third",
    "Fourth",
    "Fifth",
    "Sixth",
    "Seventh",
    "Eight",
    "Nineth",
    "Tenth",
    "Eleventh",
    "Twelvth",
    "Thirteenth",
    "Fourteenth",
    "Fifteenth",
    "Eighteenth",
    "Nineteenth",
    "Twentyth"
  ];
  List<String> States = ["Uttar Pradesh"];
  List<String> Districts = ["Mathura"];
  List<String> Cities = ["Mathura", "Agra", "Vrindavan"];
  TextStyle standardHeadingStyle = TextStyle(
      fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 20);

  Text availabilityShow(double size, Color color, String data) {
    return Text(
      data,
      textAlign: TextAlign.center,
      style:
          TextStyle(color: color, fontSize: size, fontWeight: FontWeight.bold),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      defaultSnackBarForApp(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.black,
      shape: ContinuousRectangleBorder(),
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

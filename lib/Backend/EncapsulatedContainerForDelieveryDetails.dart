import 'package:flutter/cupertino.dart';

class EncapsulatedContainerForDelieveryDetails{
  EncapsulatedContainerForDelieveryDetails(@required this.address,@required this.landmark,@required this.pincode,@required this.city,@required this.phoneNumber,@required this.alternativePhoneNumber,@required this.district,@required this.state);
  final String address;
  final String landmark;
  final String pincode;
  final String city;
  final String phoneNumber;
  final String alternativePhoneNumber;
  final String district;
  final String state;
}
import 'package:flutter/material.dart';

import '../AppConstants.dart';
class HeadingsForHomePage extends StatelessWidget {
  HeadingsForHomePage(@required this.value);
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("asset/image/paint.png"),
              fit: BoxFit.fill),
        ),
        child: Text(
          value,

          style: AppConstants().standardHeadingStyle,
        ),
      ),
    );
  }
}

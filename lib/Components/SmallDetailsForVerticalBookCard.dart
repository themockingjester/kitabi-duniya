import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:oldshelvesupdated/Backend/GetBookDetails.dart';
import 'package:oldshelvesupdated/Backend/ShowSpecificBookDetailAsynchronously.dart';
class SmallDetaillsForVerticalBookCard extends StatelessWidget {
  SmallDetaillsForVerticalBookCard(@required this.heading,@required this.colorforheading,@required this.colorforvalue,@required this.bookAddress,@required this.functionToCall,@required this.suffix);
  final Color colorforheading;
  final Color colorforvalue;
  final String bookAddress;
  final functionToCall;
  final String heading;
  final String suffix;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9),
      width: double.infinity,
      child: Row(
        children: [
          Text(
            '$heading ',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: colorforheading,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(
            child: ShowSpecificBookDetailAsynchronously(this.bookAddress,this.functionToCall,this.colorforvalue,16,FontWeight.normal,"",this.suffix,TextDecoration.none,context,"",TextOverflow.ellipsis),
          ),

        ],
      ),
    );
  }
}

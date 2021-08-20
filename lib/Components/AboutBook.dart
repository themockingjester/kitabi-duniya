/*
This CLass contains the information regarding bookname and author name,book status,book edition ,book publisher
 */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oldshelvesupdated/AppConstants.dart';
import 'package:oldshelvesupdated/Backend/GetBookDetails.dart';
import 'package:oldshelvesupdated/Backend/ShowSpecificBookDetailAsynchronously.dart';
class AboutBook extends StatefulWidget {
  String bookAddress;
  AboutBook(@required this.bookAddress);
  @override
  _AboutBookState createState() => _AboutBookState();
}

class _AboutBookState extends State<AboutBook> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: EdgeInsets.symmetric(vertical: 10,horizontal:10),
      margin: EdgeInsets.symmetric(vertical: 20,horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.orange,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      alignment: Alignment.centerLeft,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Book name',
                style: AppConstants().standardHeadingStyle,
              ),
              ShowSpecificBookDetailAsynchronously(widget.bookAddress,GetBookDetails().getBookName,Colors.black87,16,FontWeight.normal,"","",TextDecoration.none,context,null),

              SizedBox(height: 10,),
              Text(
                'Author name',
                style: AppConstants().standardHeadingStyle,
              ),
              ShowSpecificBookDetailAsynchronously(widget.bookAddress,GetBookDetails().getBookAuthors,Colors.black87,16,FontWeight.normal,"","",TextDecoration.none,context,null),
              SizedBox(height: 10,),
              Text(
                'Edition',
                style: AppConstants().standardHeadingStyle,
              ),
              ShowSpecificBookDetailAsynchronously(widget.bookAddress,GetBookDetails().getBookEdition,Colors.black87,16,FontWeight.normal,"","",TextDecoration.none,context,null),
              SizedBox(height: 10,),
              Text(
                'Status',
                style: AppConstants().standardHeadingStyle,
              ),
              ShowSpecificBookDetailAsynchronously(widget.bookAddress,GetBookDetails().getBookStatus,Colors.black87,16,FontWeight.normal,"","",TextDecoration.none,context,null),
              SizedBox(height: 10,),
              Text(
                'Publisher name',
                style: AppConstants().standardHeadingStyle,
              ),
              ShowSpecificBookDetailAsynchronously(widget.bookAddress,GetBookDetails().getBookPublisher,Colors.black87,16,FontWeight.normal,"","",TextDecoration.none,context,null),
            ],
          ),
        ]
      ),
    );
  }
}

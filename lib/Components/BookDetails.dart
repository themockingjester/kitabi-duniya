/*
This class contains information about bookoverview
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oldshelvesupdated/AppConstants.dart';
class BookDetails extends StatefulWidget {
  BookDetails(@required this.bookOverView);
  final bookOverView;
  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 10,horizontal:10),
      margin: EdgeInsets.symmetric(vertical: 20,horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.orange,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Overview",
                style: AppConstants().standardHeadingStyle,
              ),
              widget.bookOverView
            ],
          ),
        ],
      ),
    );
  }
}

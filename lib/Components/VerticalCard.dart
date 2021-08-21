import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oldshelvesupdated/Backend/ShowBookImageAsynchronously.dart';
import 'package:oldshelvesupdated/Backend/ShowSpecificBookDetailAsynchronously.dart';

import '../Backend/GetBookDetails.dart';
import '../DetailsAfterClickingOnBookCard.dart';
import 'SmallDetailsForVerticalBookCard.dart';

class VerticalCard extends StatefulWidget {
  String bookAddress;
  String imagepath = "";

  VerticalCard(@required this.bookAddress);

  @override
  _VerticalCardState createState() => _VerticalCardState();
}

class _VerticalCardState extends State<VerticalCard> {
  late Container imageContainer;

  Future<void> valuesAssigner() async {
    String temp =
        await GetBookDetails().getBookCoverPathAddress(widget.bookAddress);
    setState(() {
      widget.imagepath = temp;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    valuesAssigner();
  }

  // String extractImagenameFromPath(String input) {
  //   input = input.split('').reversed.join();
  //   String result = "";
  //   for (int i = 0; i < input.length; i++) {
  //     if (input[i] != '/') {
  //       result += input[i];
  //     } else {
  //       break;
  //     }
  //   }
  //   result = result.split('').reversed.join();

  //   return result;
  //
  // }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        //padding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
        width: 200,
        height: 400,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),

        //decoration: carddesign,
        child: Column(children: [
          Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
              ),
              child: ShowBookImageAsynchronously(widget.imagepath, context)),
          Container(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9),
                  width: double.infinity,
                  child: ShowSpecificBookDetailAsynchronously(
                      widget.bookAddress,
                      GetBookDetails().getBookName,
                      Colors.black87,
                      17,
                      FontWeight.normal,
                      "",
                      "",
                      TextDecoration.none,
                      context,
                      "",
                      TextOverflow.ellipsis),
                ),
                SmallDetaillsForVerticalBookCard(
                    "By- ",
                    Colors.pink.shade900,
                    Colors.black87,
                    widget.bookAddress,
                    GetBookDetails().getBookAuthors,
                    ""),
                SmallDetaillsForVerticalBookCard(
                    "Price- ",
                    Colors.pink.shade900,
                    Colors.green,
                    widget.bookAddress,
                    GetBookDetails().getBookPriceByUS,
                    '\u{20B9}'),
              ],
            ),
          )
        ]),
      ),
      onTap: () {
        String bookAddress = widget.bookAddress;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DetailsAfterClickingOnBookCard(bookAddress)),
        );
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShowSpecificBookDetailAsynchronously extends StatefulWidget {
  final functionToCall;
  var textDecoration;
  TextOverflow overFlow;
  String bookAddress;
  BuildContext context;
  String prefixForText;
  String suffixForText;
  Color textColor;
  FontWeight textWeight;
  double textFontSize;
  String? textFamily;

  ShowSpecificBookDetailAsynchronously(
      @required this.bookAddress,
      @required this.functionToCall,
      @required this.textColor,
      @required this.textFontSize,
      @required this.textWeight,
      @required this.prefixForText,
      @required this.suffixForText,
      @required this.textDecoration,
      @required this.context,
      @required this.textFamily,
      @required this.overFlow);

  @override
  _ShowSpecificBookDetailAsynchronouslyState createState() =>
      _ShowSpecificBookDetailAsynchronouslyState();
}

class _ShowSpecificBookDetailAsynchronouslyState
    extends State<ShowSpecificBookDetailAsynchronously> {
  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: widget.functionToCall(widget.bookAddress),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == 'not exist' ||
              snapshot.data == 'failed' ||
              snapshot.data == null) {
            return Text(
              'NA',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.red,
                  fontSize: widget.textFontSize,
                  fontWeight: widget.textWeight),
            );
          }
          return Text(
            widget.prefixForText +
                (snapshot.data as String) +
                widget.suffixForText,
            overflow: widget.overFlow,
            style: TextStyle(
              color: widget.textColor,
              fontSize: widget.textFontSize,
              fontWeight: widget.textWeight,
              decoration: widget.textDecoration,
              fontFamily: widget.textFamily,
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.none) {
          final snackBar = SnackBar(content: Text('networkk is none!'));
          ScaffoldMessenger.of(widget.context).showSnackBar(snackBar);
          return Container(
            child: Icon(
              Icons.error,
              size: 100,
              color: Colors.black,
            ),
          );
        } else {
          return SizedBox(
            width: 30.0,
            height: 10.0,
            child: Shimmer.fromColors(
                baseColor: Colors.orange,
                highlightColor: Colors.deepOrange,
                child: Card(
                  child: SizedBox(),
                )),
          );
        }
      },
    );
  }
}

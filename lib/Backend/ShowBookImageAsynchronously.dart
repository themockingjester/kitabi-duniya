import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

import 'GetBookDetails.dart';

class ShowBookImageAsynchronously extends StatefulWidget {
  String imagepath;
  BuildContext context;

  ShowBookImageAsynchronously(@required this.imagepath, @required this.context);

  @override
  _ShowBookImageAsynchronouslyState createState() =>
      _ShowBookImageAsynchronouslyState();
}

class _ShowBookImageAsynchronouslyState
    extends State<ShowBookImageAsynchronously> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetBookDetails().getImage(context, widget.imagepath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Container(
            //alignment: Alignment.bottomCenter,
            width: 200,
            height: 200,

            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.0),
              child: FittedBox(
                child: snapshot.data as Widget,
                fit: BoxFit.fill,
              ),
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
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
            ),
            child: SizedBox(
              width: 200.0,
              height: 200.0,
              child: Shimmer.fromColors(
                  baseColor: Colors.orange,
                  highlightColor: Colors.deepOrange,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    child: SizedBox(),
                  )),
            ),
          );
        }
      },
    );
  }
}

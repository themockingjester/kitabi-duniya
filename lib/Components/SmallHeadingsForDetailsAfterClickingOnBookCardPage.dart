import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:oldshelvesupdated/Backend/ShowSpecificBookDetailAsynchronously.dart';
class SmallHeadingsForDetailsAfterClickingOnBookCard extends StatefulWidget {
  SmallHeadingsForDetailsAfterClickingOnBookCard(@required this.heading,@required this.value);
  final String heading;
  ShowSpecificBookDetailAsynchronously value;

  @override
  _SmallHeadingsForDetailsAfterClickingOnBookCardState createState() => _SmallHeadingsForDetailsAfterClickingOnBookCardState();
}

class _SmallHeadingsForDetailsAfterClickingOnBookCardState extends State<SmallHeadingsForDetailsAfterClickingOnBookCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            widget.heading,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12
            ),
        ),
        widget.value
      ],
    );
  }
}

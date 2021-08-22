import 'package:flutter/material.dart';

class VerticalBarForDetailsAfterClickingOnBookCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 20,
      child: Container(
        color: Colors.white,
        width: 3,
      ),
    );
  }
}

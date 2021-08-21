import 'package:flutter/material.dart';
class SmallDetailsForCardAtCardPage extends StatelessWidget {
  SmallDetailsForCardAtCardPage({required this.heading,required this.headingColor, required this.value, required this.valueColor});
  String heading;
  String value;
  Color headingColor;
  Color valueColor;
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Row(
        children: [
          Text(
            heading,

            style: TextStyle(
                fontFamily: 'MateSc',
                fontSize: 15,
                color: headingColor,
                fontWeight: FontWeight.bold
            ),

          ),
          Flexible(
            child: Text(
              value,

              style: TextStyle(
                  fontFamily: 'MateSc',
                  fontSize: 15,
                  color: valueColor,
                  fontWeight: FontWeight.bold
              ),

              overflow: TextOverflow.ellipsis,

            ),
          )
        ],

      ),
    );
  }
}

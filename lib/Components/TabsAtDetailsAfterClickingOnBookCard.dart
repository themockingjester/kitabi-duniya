import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
class TabsAtDetailsAfterClickingOnBookCard extends StatefulWidget {
  final functionFromParent;
  TabsAtDetailsAfterClickingOnBookCard(@required this.functionFromParent);
  @override
  _TabsAtDetailsAfterClickingOnBookCardState createState() => _TabsAtDetailsAfterClickingOnBookCardState();
}

class _TabsAtDetailsAfterClickingOnBookCardState extends State<TabsAtDetailsAfterClickingOnBookCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),

      child: FlutterToggleTab(
        // width in percent, to set full width just set to 100
        width: 60,

        borderRadius: 30,
        height: 50,

        initialIndex:0,
        selectedBackgroundColors: [Colors.deepOrange],
        selectedTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700),
        unSelectedTextStyle: TextStyle(
            color: Colors.black87,

            fontSize: 14,
            fontWeight: FontWeight.w500),

        labels: ["About","Details"],
        marginSelected: EdgeInsets.symmetric(horizontal: 10),
        selectedLabelIndex: (index) {
          widget.functionFromParent('$index');

        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class ChipsCreator extends StatefulWidget {
  String label;
  Color color;
  bool isselected = false;

  ChipsCreator(this.label, this.color);

  static List<String> tags = [];

  List<String> getTagList() {
    return tags;
  }

  @override
  _ChipsCreatorState createState() => _ChipsCreatorState();
}

class _ChipsCreatorState extends State<ChipsCreator> {
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      labelPadding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 0.5),
      tooltip: widget.label,
      backgroundColor: Colors.tealAccent[200],
      avatar: CircleAvatar(
        backgroundColor: widget.color,
        child: Text(
          widget.label[0].toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      label: Text(
        widget.label,
        overflow: TextOverflow.ellipsis,
      ),
      selected: widget.isselected,
      selectedColor: Colors.yellow.shade200,
      onSelected: (bool selected) {
        if (selected) {
          ChipsCreator.tags.add(widget.label);

          setState(() {
            widget.isselected = true;
          });
        } else {
          setState(() {
            widget.isselected = false;
          });

          ChipsCreator.tags.remove(widget.label);
        }
      },
    );
  }
}

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  DropDown(
      @required this.items, @required this.selectedItem, @required this.label);

  String label;
  String selectedItem;
  List<String> items;

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
        dropdownSearchDecoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.orange),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrange),
            borderRadius: const BorderRadius.all(
              const Radius.circular(15.0),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: const BorderRadius.all(
              const Radius.circular(15.0),
            ),
          ),
        ),
        mode: Mode.MENU,
        showSelectedItem: true,
        items: widget.items,
        label: widget.label,
        popupItemDisabled: (String s) => s.startsWith('I'),
        onChanged: (String? val) {
          if (val != null) {
            setState(() {
              widget.selectedItem = val;
            });
          }
        },
        enabled: true,
        showAsSuffixIcons: true,
        showSearchBox: true,
        selectedItem: widget.selectedItem);
  }
}

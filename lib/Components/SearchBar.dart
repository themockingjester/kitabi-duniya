import 'package:flutter/material.dart';

import '../SearchResultPage.dart';

class SearchBar extends StatelessWidget {
  String data = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: TextFormField(
        cursorColor: Colors.grey.shade500,
        cursorHeight: 25,
        textAlign: TextAlign.center,
        onFieldSubmitted: (String val) {
          this.data = val;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchResultPage(this.data)),
          );
        },
        onChanged: (String value) {
          this.data = value;
        },
        decoration: new InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade700),
              borderRadius: const BorderRadius.all(
                const Radius.circular(15.0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500),
              borderRadius: const BorderRadius.all(
                const Radius.circular(15.0),
              ),
            ),
            prefixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchResultPage(this.data)),
                );
              },
            ),
            filled: true,
            hintStyle: new TextStyle(color: Colors.grey[800]),
            hintText: "Search",
            fillColor: Colors.grey.shade200),
      ),
    );
  }
}

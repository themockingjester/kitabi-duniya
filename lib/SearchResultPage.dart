import 'package:flutter/material.dart';
import 'package:oldshelvesupdated/AppConstants.dart';
import 'package:oldshelvesupdated/Backend/SearchEngine.dart';

class SearchResultPage extends StatefulWidget {
  List<Widget> books = [];
  String inputString;

  SearchResultPage(@required this.inputString);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  List<Widget> tempListForAddingResultantBooks = [];

  Future<void> resultedBooksAdderFunction(item) async {
    tempListForAddingResultantBooks.add(item);

    setState(() {
      // listOfBooksRelatedToUserInterest.clear();

      widget.books = List.from(tempListForAddingResultantBooks);
    });
  }

  Future<void> fetchTheData() async {
    Map addedBooks = Map();
    String removedSpecialCharacters = widget.inputString
        .replaceAll(".", "")
        .replaceAll("#", "")
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll("\$", "");
    String smallcaseString =
        await SearchEngine().covertAllToSmallerCase(removedSpecialCharacters);

    List<String> list = await SearchEngine().convertIntoList(smallcaseString);
    for (int i = 0; i < list.length; i++) {
      if (await SearchEngine().wheatherInputIsAKeywordTag(list[i] as String) ==
          true) {
        await SearchEngine().fetchRequiredBooks(
            list[i] as String, resultedBooksAdderFunction, 'small', addedBooks);
      }
    }
    await Future.delayed(const Duration(seconds: 2), () {});
    resultedBooksAdderFunction(
        Image(image: AssetImage("asset/image/flag.png")));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTheData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
      ),
      backgroundColor: AppConstants().appBackgroundColor,
      body: widget.books.length == 0
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: widget.books,
            ),
    );
  }
}

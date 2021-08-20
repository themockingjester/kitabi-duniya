import 'package:flutter/material.dart';
import 'package:oldshelvesupdated/Backend/GetBookDetails.dart';
import 'package:oldshelvesupdated/Backend/ShowBookImageAsynchronously.dart';
import 'package:oldshelvesupdated/Backend/ShowSpecificBookDetailAsynchronously.dart';
import '../DetailsAfterClickingOnBookCard.dart';
import 'SmallDetailsForCardAtSearchResultPage.dart';
class SearchResultCard extends StatefulWidget {
  String bookAddress;
  String imagePath;
  String bookName="";
  SearchResultCard(@required this.bookAddress,@required this.imagePath);
  @override
  _SearchResultCardState createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard> {
  Future<void> valueAssigner() async {

    String fetchedName = await GetBookDetails().getBookName(widget.bookAddress);
    setState(() {
      widget.bookName = fetchedName;
    });
    // String tempImageAddress = await GetBookDetails().getBookCoverPathAddress(widget.bookAddress);
    // setState(() {
    //   widget.imagePath = tempImageAddress;
    //
    // });


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
      height: 160,
      child: Card(

        shape: BeveledRectangleBorder(
          side: BorderSide(
            color: Colors.deepOrange,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 15,

        child: TextButton(

          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(

                  child: Container(
                    child: ShowBookImageAsynchronously(widget.imagePath, context),

                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShowSpecificBookDetailAsynchronously(widget.bookAddress, GetBookDetails().getBookName, Colors.grey.shade500, 15, FontWeight.bold, "", "", TextDecoration.none, context, "MateSc"),
                        ShowSpecificBookDetailAsynchronously(widget.bookAddress, GetBookDetails().getBookAuthors, Colors.grey.shade500, 15, FontWeight.bold, "by- ", "", TextDecoration.none, context, "MateSc"),
                        ShowSpecificBookDetailAsynchronously(widget.bookAddress, GetBookDetails().getBookPublisher, Colors.grey.shade500, 15, FontWeight.bold, "publisher- ", "", TextDecoration.none, context, "MateSc"),
                        ShowSpecificBookDetailAsynchronously(widget.bookAddress, GetBookDetails().getBookEdition, Colors.grey.shade500, 15, FontWeight.bold, "edition- ", "", TextDecoration.none, context, "MateSc"),
                        ShowSpecificBookDetailAsynchronously(widget.bookAddress, GetBookDetails().getBookStatus, Colors.grey.shade500, 15, FontWeight.bold, "status- ", "", TextDecoration.none, context, "MateSc"),
                        Row(
                          children: [
                            Text(
                              'price- ',

                              style: TextStyle(
                                  fontFamily: 'MateSc',
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.bold
                              ),

                              overflow: TextOverflow.ellipsis,

                            ),

                            Row(
                              children: [
                                ShowSpecificBookDetailAsynchronously(widget.bookAddress,GetBookDetails().getBookPriceByUS,Colors.green,12,FontWeight.bold,"","",TextDecoration.none,context,'MateSc'),
                                Text('\u{20B9}',style: TextStyle(color: Colors.green),)
                              ],
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailsAfterClickingOnBookCard(widget.bookAddress)),
            );
          },
        ),
      ),
    );
  }
}

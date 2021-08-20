import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oldshelvesupdated/AppConstants.dart';
import 'package:oldshelvesupdated/Backend/CartDealingFile.dart';
import 'package:oldshelvesupdated/Backend/GetBookDetails.dart';
import 'package:oldshelvesupdated/Backend/ShowBookImageAsynchronously.dart';
import 'package:oldshelvesupdated/Backend/ShowSpecificBookDetailAsynchronously.dart';
import 'package:oldshelvesupdated/Components/SmallDetailsForCardAtCartPage.dart';
import '../DetailsAfterClickingOnBookCard.dart';
import 'QuantityIncreaseAndDecreaseWidget.dart';
class CardForCartPage extends StatefulWidget {
  final listRefreshingFunction;
  bool isAvailable=false;
  Widget image = CircularProgressIndicator();
  Text availability = AppConstants().availabilityShow(11, Colors.red, 'OutOfStock');
  String bookAddress;
  CardForCartPage(@required this.bookAddress,@required this.listRefreshingFunction);
  QuantityIncreaseAndDecreaseWidget QuantityChanger = QuantityIncreaseAndDecreaseWidget();
  int itemPrice=0;
  @override
  _CardForCartPageState createState() => _CardForCartPageState();
}

class _CardForCartPageState extends State<CardForCartPage> {
  Future<void> valuesInitializer() async {
    int temp = int.parse(await GetBookDetails().getBookPriceByUS(widget.bookAddress));
    String availablePiecesString = await GetBookDetails().getBookAvailablePieces(widget.bookAddress);
    ShowBookImageAsynchronously tempImg = ShowBookImageAsynchronously(await GetBookDetails().getBookCoverPathAddress(widget.bookAddress), context);
    setState(() {
      widget.image = tempImg;

    });
    if(availablePiecesString!="not exist"||availablePiecesString!='failed')
      {
        int piecesInInteger = int.parse(availablePiecesString);
        if(piecesInInteger>0){
          setState(() {
            widget.isAvailable=true;
            widget.availability = AppConstants().availabilityShow(12, Colors.green, "InStock");
          });
        }
        else{
          setState(() {
            widget.isAvailable=false;
            widget.availability = AppConstants().availabilityShow(12, Colors.red, "OutOfStock");
          });
        }
      }
    setState((){

      widget.itemPrice = temp;

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    valuesInitializer();
  }
  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
      height: 240,
      child: Card(

        shape: BeveledRectangleBorder(
          side: BorderSide(
            color: Colors.deepOrange,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 15,

        child: TextButton(

          child: Row(
            children: [
              Expanded(

                child: Container(

                  child:widget.image,


                ),
              ),
              Expanded(
                flex: 2,
                child: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailsAfterClickingOnBookCard(widget.bookAddress)),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShowSpecificBookDetailAsynchronously(widget.bookAddress,GetBookDetails().getBookName,Colors.grey.shade500,15,FontWeight.bold,"","",TextDecoration.none,context,'MateSc'),
                        ShowSpecificBookDetailAsynchronously(widget.bookAddress,GetBookDetails().getBookAuthors,Colors.grey.shade500,15,FontWeight.bold,"by- ","",TextDecoration.none,context,'MateSc'),
                        ShowSpecificBookDetailAsynchronously(widget.bookAddress,GetBookDetails().getBookPublisher,Colors.grey.shade500,15,FontWeight.bold,"publisher- ","",TextDecoration.none,context,'MateSc'),
                        Row(
                          children: [
                            Text(
                                'price- ',

                                style: TextStyle(
                                    fontFamily: 'MateSc',
                                    fontSize: 15,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.bold
                                ),

                                overflow: TextOverflow.ellipsis,

                              ),

                            Row(
                              children: [
                                ShowSpecificBookDetailAsynchronously(widget.bookAddress,GetBookDetails().getBookPriceByUS,Colors.green,15,FontWeight.bold,"","",TextDecoration.none,context,'MateSc'),
                                Text('\u{20B9}',style: TextStyle(color: Colors.green),)
                              ],
                            ),

                          ],
                        ),
                        widget.availability,
                        widget.QuantityChanger,
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 40),
                          child: ElevatedButton(

                              child: Text(
                                "Remove",
                                style: TextStyle(
                                    color: Colors.white
                                ),

                              ),

                              onPressed: ()async {

                                await CartDealingFile().removeThisBookFromMyCart(context, widget.bookAddress);
                                widget.listRefreshingFunction(widget);
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  primary: Colors.deepOrange, // background
                                  onPrimary: Colors.white, // foreground
                                  minimumSize: Size(double.infinity,30)
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          onPressed: (){},
        ),
      ),
    );
  }
}

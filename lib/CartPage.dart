import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oldshelvesupdated/AppConstants.dart';
import 'package:oldshelvesupdated/Backend/EncapsulatedContainerForNewBook.dart';

import 'Backend/GetBookDetails.dart';
import 'Components/CardForCartPage.dart';
import 'DelieveryPage.dart';

class CartPage extends StatefulWidget {
  int totalMoney = 0;
  List<EncapsulatedContainerForNewBook> books = [];
  List<CardForCartPage> cardList = [];

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase().reference();
  final commonPathForCart = 'users/cart/';

  void refreshListOfItems(CardForCartPage card) {
    widget.cardList.remove(card);
    List<CardForCartPage> temp = List.from(widget.cardList);
    setState(() {
      widget.cardList = temp;
    });
  }

  Future<void> packAllItemsInTheirContainer() async {
    if (widget.cardList.length > 0) {
      for (int i = 0; i < widget.cardList.length; i++) {
        String bookAddress = widget.cardList[i].bookAddress;
        String bookName = await GetBookDetails().getBookName(bookAddress);
        String authors = await GetBookDetails().getBookAuthors(bookAddress);
        String publisher = await GetBookDetails().getBookPublisher(bookAddress);
        String bookStatus = await GetBookDetails().getBookStatus(bookAddress);
        String marketPrice =
            await GetBookDetails().getBookMarketPrice(bookAddress);
        String edition = await GetBookDetails().getBookEdition(bookAddress);
        String priceByUs = await GetBookDetails().getBookPriceByUS(bookAddress);
        String imagePath =
            await GetBookDetails().getBookCoverPathAddress(bookAddress);
        List<Object?> tags = await GetBookDetails().getBookTags(bookAddress);
        String language = await GetBookDetails().getBookLanguage(bookAddress);
        List<String> tagsInListOfStringForm = [];
        if (tags != null) {
          for (int i = 0; i < tags.length; i++) {
            String? thisTag = tags[i] as String?;
            if (thisTag != null) {
              tagsInListOfStringForm.add(thisTag);
            }
          }
        }

        EncapsulatedContainerForNewBook bookDetails =
            EncapsulatedContainerForNewBook(
                bookName,
                authors,
                publisher,
                bookStatus,
                edition,
                marketPrice,
                priceByUs,
                '${widget.cardList[i].QuantityChanger.quantity}',
                imagePath,
                'NA',
                tagsInListOfStringForm,
                language,
                'NA');

        widget.books.add(bookDetails);
      }
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DeliveryPage(widget.books, "buy")),
      ).then((value) {
        setState(() {});
      });
    } else {
      AppConstants().defaultSnackBarForApp(
          context, "Opps! you don't have any item in your cart");
    }
  }

  Future<void> fetchBooksFromMyCart() async {
    String uid = _auth.currentUser!.uid;
    var result;
    if (_database != null && uid != null) {
      var data = await _database.child(commonPathForCart).child(uid);
      result = await data.once().then((DataSnapshot dataSnapshot) {
        if (dataSnapshot.value == null) {
          return;
        }
        Map values = dataSnapshot.value;

        values.forEach((key, value) {
          List<CardForCartPage> temp = List.from(widget.cardList);

          temp.add(
            CardForCartPage(key, refreshListOfItems),
          );
          setState(() {
            widget.cardList = temp;
          });
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBooksFromMyCart();
  }

  void ShowTotalMoney() {
    widget.totalMoney = 0;
    for (int i = 0; i < widget.cardList.length; i++) {
      CardForCartPage item = widget.cardList[i];

      setState(() {
        if (item.isAvailable) {
          widget.totalMoney += item.QuantityChanger.quantity * item.itemPrice;
        }
      });
    }
  }

  void _incrementDown(PointerEvent details) {
    ShowTotalMoney();
  }

  void _incrementUp(PointerEvent details) {
    ShowTotalMoney();
  }

  @override
  Widget build(BuildContext context) {
    ShowTotalMoney();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
        ),
        body: Listener(
          onPointerDown: _incrementDown,
          onPointerUp: _incrementUp,
          child: Container(
            child: Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 50,
                              ),
                              Container(
                                child: Text(
                                  'Total',
                                  style: TextStyle(
                                      fontSize: 50, fontFamily: "Pacifico"),
                                ),
                              ),
                              Container(
                                child: Text(
                                  '${widget.totalMoney}\u{20B9}',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: 'MateSc',
                                      color: Colors.green),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height /
                                    MediaQuery.of(context).size.height /
                                    50,
                              ),
                              ElevatedButton(
                                style: AppConstants().commonElevatedButtonStyle,
                                child: Text(
                                  'Purchase',
                                  style: TextStyle(fontSize: 15),
                                ),
                                onPressed: () {
                                  packAllItemsInTheirContainer();
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://media.giphy.com/media/QxdbjzetcgDImLeeSO/giphy.gif',
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(),
                              height: 50,
                              width: 50,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        )
                      ],
                    )),
                Container(
                  height: MediaQuery.of(context).size.height / 2.3,
                  child: ListView(
                    children: widget.cardList,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

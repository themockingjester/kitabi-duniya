import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:oldshelvesupdated/Backend/CartDealingFile.dart';
import 'package:oldshelvesupdated/Backend/ShowBookImageAsynchronously.dart';
import 'package:oldshelvesupdated/Backend/ShowSpecificBookDetailAsynchronously.dart';
import 'package:oldshelvesupdated/Components/BookDetails.dart';

import 'AppConstants.dart';
import 'Backend/EncapsulatedContainerForNewBook.dart';
import 'Backend/GetBookDetails.dart';
import 'Backend/LikeDislikeHandler.dart';
import 'Components/AboutBook.dart';
import 'Components/DropDown.dart';
import 'Components/PriceTemplateForDetailsAfterClickingOnBookCardPage.dart';
import 'Components/SmallHeadingsForDetailsAfterClickingOnBookCardPage.dart';
import 'Components/TabsAtDetailsAfterClickingOnBookCard.dart';
import 'Components/VerticalBarForDetailsAfterClickingOnBookCard.dart';
import 'DelieveryPage.dart';

class DetailsAfterClickingOnBookCard extends StatefulWidget {
  int currentTabIndex = 0;
  String imagePath = "";
  bool isPurchaseDisabled = true;
  Text availabilityWidget =
      AppConstants().availabilityShow(25, Colors.red, 'OutOfStock');
  DropDown quantity =
      DropDown(AppConstants().QuantitiesForUploading, "1", "Quantity");
  String bookAddress;
  Widget currentTabData = Container();

  DetailsAfterClickingOnBookCard(@required this.bookAddress);

  @override
  _DetailsAfterClickingOnBookCardState createState() =>
      _DetailsAfterClickingOnBookCardState();
}

class _DetailsAfterClickingOnBookCardState
    extends State<DetailsAfterClickingOnBookCard> {
  Future<bool> doWeHaveRequiredQuantityOfBooks() async {
    int availablePieces = int.parse(
        await GetBookDetails().getBookAvailablePieces(widget.bookAddress));
    String bookName = await GetBookDetails().getBookName(widget.bookAddress);
    if (int.parse(widget.quantity.selectedItem) <= availablePieces) {
      return true;
    }
    AppConstants().defaultSnackBarForApp(context,
        "We have only ${availablePieces} available copies for the book ${bookName} , for further purchasing try to decrease quantity!");
    return false;
  }

  Future<void> checkAvailability() async {
    String availablePieces =
        await GetBookDetails().getBookAvailablePieces(widget.bookAddress);
    if (availablePieces != 'failed' || availablePieces != 'not exist') {
      int piecesAvailable = int.parse(availablePieces);

      if (piecesAvailable != 0) {
        setState(() {
          widget.availabilityWidget =
              AppConstants().availabilityShow(25, Colors.green, 'InStock');
          widget.isPurchaseDisabled = false;
        });
      } else {
        setState(() {
          widget.availabilityWidget =
              AppConstants().availabilityShow(25, Colors.red, 'OutOfStock');
          widget.isPurchaseDisabled = true;
        });
      }
    }
  }

  Future<void> setImagePath() async {
    String temp =
        await GetBookDetails().getBookCoverPathAddress(widget.bookAddress);
    setState(() {
      widget.imagePath = temp;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setImagePath();
    widget.currentTabData = AboutBook(widget.bookAddress);
    checkAvailability();
  }

  Future<void> tabsDataSwitcherFunction(String data) async {
    setState(() {
      widget.currentTabIndex = int.parse(data);
      if (widget.currentTabIndex == 1) {
        widget.currentTabData = BookDetails(
            ShowSpecificBookDetailAsynchronously(
                widget.bookAddress,
                GetBookDetails().getBookOverView,
                Colors.black87,
                20,
                FontWeight.normal,
                "",
                "",
                TextDecoration.none,
                context,
                null,
                TextOverflow.visible));
      } else {
        widget.currentTabData = AboutBook(widget.bookAddress);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              iconSize: 30,
              onPressed: () async {
                await CartDealingFile()
                    .addThisBookToMyCart(context, widget.bookAddress);
              },
            ),
          ),
        ],
        elevation: 0,
      ),
      backgroundColor: AppConstants().appBackgroundColor,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.4,
            color: Colors.orangeAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 37,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: ShowBookImageAsynchronously(
                          widget.imagePath, context)),
                ),
                Expanded(
                  flex: 5,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ShowSpecificBookDetailAsynchronously(
                        widget.bookAddress,
                        GetBookDetails().getBookName,
                        Colors.white,
                        25,
                        FontWeight.bold,
                        "",
                        "",
                        TextDecoration.none,
                        context,
                        null,
                        TextOverflow.ellipsis),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 5,
                  child: ShowSpecificBookDetailAsynchronously(
                      widget.bookAddress,
                      GetBookDetails().getBookAuthors,
                      Colors.white,
                      15,
                      FontWeight.normal,
                      'By-',
                      "",
                      TextDecoration.none,
                      context,
                      null,
                      TextOverflow.ellipsis),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SmallHeadingsForDetailsAfterClickingOnBookCard(
                          "Rating",
                          ShowSpecificBookDetailAsynchronously(
                              widget.bookAddress,
                              GetBookDetails().bookRatingCalculator,
                              Colors.white,
                              15,
                              FontWeight.bold,
                              "",
                              "/10",
                              TextDecoration.none,
                              context,
                              null,
                              TextOverflow.ellipsis)),
                      VerticalBarForDetailsAfterClickingOnBookCard(),
                      SmallHeadingsForDetailsAfterClickingOnBookCard(
                          "Language",
                          ShowSpecificBookDetailAsynchronously(
                              widget.bookAddress,
                              GetBookDetails().getBookLanguage,
                              Colors.white,
                              15,
                              FontWeight.bold,
                              "",
                              "",
                              TextDecoration.none,
                              context,
                              null,
                              TextOverflow.ellipsis)),
                      VerticalBarForDetailsAfterClickingOnBookCard(),
                      SmallHeadingsForDetailsAfterClickingOnBookCard(
                          "Edition",
                          ShowSpecificBookDetailAsynchronously(
                              widget.bookAddress,
                              GetBookDetails().getBookEdition,
                              Colors.white,
                              15,
                              FontWeight.bold,
                              "",
                              "",
                              TextDecoration.none,
                              context,
                              null,
                              TextOverflow.ellipsis)),
                      VerticalBarForDetailsAfterClickingOnBookCard(),
                      SmallHeadingsForDetailsAfterClickingOnBookCard(
                          "Status",
                          ShowSpecificBookDetailAsynchronously(
                              widget.bookAddress,
                              GetBookDetails().getBookStatus,
                              Colors.white,
                              15,
                              FontWeight.bold,
                              "",
                              "",
                              TextDecoration.none,
                              context,
                              null,
                              TextOverflow.ellipsis)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TabsAtDetailsAfterClickingOnBookCard(
                          tabsDataSwitcherFunction),
                      flex: 5,
                    ),
                    Expanded(
                      flex: 3,
                      child: PriceTemplateForDetailsAfterClickingOnBookCardPage(
                          ShowSpecificBookDetailAsynchronously(
                              widget.bookAddress,
                              GetBookDetails().getBookMarketPrice,
                              Colors.red,
                              15,
                              FontWeight.bold,
                              "",
                              "",
                              TextDecoration.lineThrough,
                              context,
                              null,
                              TextOverflow.ellipsis),
                          ShowSpecificBookDetailAsynchronously(
                              widget.bookAddress,
                              GetBookDetails().getBookPriceByUS,
                              Colors.green,
                              25,
                              FontWeight.bold,
                              "",
                              "",
                              TextDecoration.none,
                              context,
                              null,
                              TextOverflow.ellipsis)),
                    )
                  ],
                ),
                widget.currentTabData,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 0),
                            child: widget.quantity),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: widget.availabilityWidget,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.thumb_down,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          LikeDislikeHandler()
                              .dislikeThisBook(widget.bookAddress, context);
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepOrange,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                        ),
                        child: Text(
                          'Purchase',
                          style: TextStyle(fontSize: 25),
                        ),
                        onPressed: widget.isPurchaseDisabled
                            ? null
                            : () async {
                                if (await doWeHaveRequiredQuantityOfBooks() ==
                                    false) {
                                  return;
                                }

                                String bookName = await GetBookDetails()
                                    .getBookName(widget.bookAddress);
                                String authors = await GetBookDetails()
                                    .getBookAuthors(widget.bookAddress);
                                String publisher = await GetBookDetails()
                                    .getBookPublisher(widget.bookAddress);
                                String bookStatus = await GetBookDetails()
                                    .getBookStatus(widget.bookAddress);
                                String marketPrice = await GetBookDetails()
                                    .getBookMarketPrice(widget.bookAddress);
                                String edition = await GetBookDetails()
                                    .getBookEdition(widget.bookAddress);
                                String priceByUs = await GetBookDetails()
                                    .getBookPriceByUS(widget.bookAddress);
                                String imagePath = await GetBookDetails()
                                    .getBookCoverPathAddress(
                                        widget.bookAddress);
                                List<Object?> tags = await GetBookDetails()
                                    .getBookTags(widget.bookAddress);
                                String language = await GetBookDetails()
                                    .getBookLanguage(widget.bookAddress);
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
                                        widget.quantity.selectedItem,
                                        imagePath,
                                        'NA',
                                        tagsInListOfStringForm,
                                        language,
                                        "NA");
                                List<EncapsulatedContainerForNewBook> books =
                                    [];
                                books.add(bookDetails);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DeliveryPage(books, "buy")),
                                );
                              },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.thumb_up,
                          color: Colors.orange,
                        ),
                        onPressed: () async {
                          await LikeDislikeHandler()
                              .likeThisBook(widget.bookAddress, context);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

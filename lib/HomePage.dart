
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:oldshelvesupdated/Backend/Queries.dart';
import 'package:oldshelvesupdated/Backend/SearchEngine.dart';
import 'package:oldshelvesupdated/Backend/SpecialBooksGetter.dart';
import 'package:shimmer/shimmer.dart';
import 'Components/VerticalCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:oldshelvesupdated/Components/HeadingsForHomePage.dart';
import 'package:oldshelvesupdated/Components/MenuButton.dart';
import 'Components/SearchBar.dart';
import 'AppConstants.dart';

import 'Backend/SecurityCodes.dart';
import 'package:oldshelvesupdated/AskingUserInterestPage.dart';
import 'package:oldshelvesupdated/Backend/GetUserDetails.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  final searchBar = SearchBar();
  static bool DirectTrigger = false;
  final _database = FirebaseDatabase().reference();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Widget> listOfBooksRelatedToUserInterest = [];
  List<Widget> listOfTrendingBooks = [];
  List<Widget> listOfTopBooks = [];

  void userInterestRelatedBooksAdderFunction(card){

    setState(() {

      this.listOfBooksRelatedToUserInterest.add(card);
    });
  }
  void trendingBooksAdderFunction(card){

    setState(() {

      this.listOfTrendingBooks.add(card);
    });
  }
  void topBooksAdderFunction(card){

    setState(() {

      this.listOfTopBooks.add(card);
    });
  }
  Future<void> userrInterestChecker() async {
    String currentStatus = await GetUserDetails().checkWeHaveUserInterestTags();
    if (currentStatus == 'not exist') {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AskingUserInterestPage()),
      );
      Navigator.pop(context);
      AppConstants().defaultSnackBarForApp(context,"now signn in again");

    }
  }
  Future<void> getTrendingBooks() async{
    SpecialBooksGetter().fetchTrendingBooks(trendingBooksAdderFunction);
  }
  Future<void> getBooksRelatedToUserInterest() async{
    List<Object?>? tags = await GetUserDetails().getUserInterestTags().then((value) => value);
    Queries(userInterestRelatedBooksAdderFunction).getBooksHavingParticularTags(tags);

  }

  @override
  void initState() {
    super.initState();
    this.listOfBooksRelatedToUserInterest.clear();


    userrInterestChecker();

    getBooksRelatedToUserInterest();


    SpecialBooksGetter().fetchTrendingBooks(trendingBooksAdderFunction);
    SpecialBooksGetter().fetchTopBooks(topBooksAdderFunction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppConstants().appBackgroundColor,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.orange,
              image: DecorationImage(
                  image: AssetImage("asset/image/leaf2.png"), fit: BoxFit.fill),
            ),
            height: 250,
            child: Column(
              children: [
                widget.searchBar,
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingsForHomePage('You may like'),
                Container(

                    height: MediaQuery.of(context).size.height/2,
                    alignment: Alignment.center,

                    child:ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Row(
                          children: this.listOfBooksRelatedToUserInterest,
                        )
                      ]
                    )

                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.0),
                    child: Image(
                      image: AssetImage("asset/image/bannerimage.jpg"),
                    ),
                  ),
                ),
                HeadingsForHomePage('Trending Books'),
                Container(
                    height: MediaQuery.of(context).size.height/2,
                    alignment: Alignment.center,

                    child:ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Row(
                            children: this.listOfTrendingBooks,
                          )
                        ]
                    )

                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.0),
                    child: Image(
                      image: AssetImage("asset/image/bannerimage3.jpg"),
                    ),
                  ),
                ),
                HeadingsForHomePage('Top Books'),
                Container(
                    height: MediaQuery.of(context).size.height/2,
                    alignment: Alignment.center,

                    child:ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Row(
                            children: this.listOfTopBooks,
                          )
                        ]
                    )

                ),



              ],
            ),
          ),
          GestureDetector(
            onLongPress: () async {
              String data = "";

              AlertDialog dialogForSuperiority = AlertDialog(
                title: Text('Security Code'),
                // To display the title it is optional
                content: TextField(
                  onChanged: (value) {
                    data = value;
                  },
                ),
                // Message which will be pop up on the screen
                // Action widget which will provide the user to acknowledge the choice
                actions: [
                  TextButton(
                    // FlatButton widget is used to make a text to work like a button

                    onPressed: () {
                      Navigator.pop(context);
                    }, // function used to perform after pressing the button
                    child: Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (data != "" && data != null) {
                        if (data ==
                            await SecurityCodes().getCodeForDirectAdding()) {
                          HomePage.DirectTrigger = true;
                          AppConstants()
                              .defaultSnackBarForApp(context, "Awsome!!");
                        } else {
                          AppConstants()
                              .defaultSnackBarForApp(context, "wrong code");
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: Text('ACCEPT'),
                  ),
                ],
              );
              if (await GetUserDetails().checkUserSuperiority() == 'exist') {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return dialogForSuperiority;
                    });
              }
            },
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("asset/image/shelf1.png"),
                    fit: BoxFit.contain),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: MenuButton(),
    );
  }
}

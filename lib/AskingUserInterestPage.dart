import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oldshelvesupdated/AppConstants.dart';
import 'package:oldshelvesupdated/Backend/UserDetailsAdder.dart';
import 'package:oldshelvesupdated/HomePage.dart';
import 'Components/ChipsCreator.dart';
class AskingUserInterestPage extends StatefulWidget {
  final List<String> availableTagList = AppConstants().AvailableTagsList;
  List<ChipsCreator> availableChips = [];
  Container chipsContainer = Container();
  @override
  _AskingUserInterestPageState createState() => _AskingUserInterestPageState();
}

class _AskingUserInterestPageState extends State<AskingUserInterestPage> {
  @override
  void getChips() async{

      for (int i = 0; i < widget.availableTagList.length; i++) {
        widget.availableChips.add(ChipsCreator(widget.availableTagList[i], Colors.indigoAccent));
      }

      setState(() {
        widget.chipsContainer=Container(
          height: 400,
          child: ListView(
            children: [
            Center(
              child: Container(

                  child:Wrap(
                    verticalDirection: VerticalDirection.down,
                    spacing: 5.0,
                    runSpacing: 10.0,
                    children: widget.availableChips,
                  ),
                ),
            )
            ],
          ),
        );
      });


  }
  void initState() {

    super.initState();
    getChips();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants().appAppBarColor,
      ),
      backgroundColor: AppConstants().appBackgroundColor,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Column(
            children: [
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 20.0),
                child: Text(
                  "Pick your interest!",
                  softWrap: true,
                  style: TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 40,
                      color: Colors.green
                  ),
                ),
              ),
              widget.chipsContainer,
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: ElevatedButton(
                  child: Text(
                    'Done',
                    style: TextStyle(
                        fontSize: 15
                    ),
                  ),
                  onPressed: () async {
                    if(ChipsCreator.tags.length<3){
                      AppConstants().defaultSnackBarForApp(context, "Please select at least 3 tags!");
                    }
                    else{
                      await UserDetailsAdder().addUserInterestedTags(ChipsCreator.tags, context);


                    }
                  },
                  style: AppConstants().commonElevatedButtonStyle,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

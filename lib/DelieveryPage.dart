import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oldshelvesupdated/AppConstants.dart';
import 'package:oldshelvesupdated/Backend/DeliveryDetails.dart';
import 'package:oldshelvesupdated/Backend/EncapsulatedContainerForDelieveryDetails.dart';
import 'package:oldshelvesupdated/Backend/EncapsulatedContainerForNewBook.dart';
import 'package:oldshelvesupdated/Backend/SetBookDetails.dart';
import 'Backend/GetBookDetails.dart';
import 'Components/DropDown.dart';
import 'Components/OutLineTextFieldForNormalEntry.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class DeliveryPage extends StatefulWidget {

  DeliveryPage(@required this.books,@required this.type);

  String type;
  bool checkBoxValue = false;
  bool wait = false;
  DropDown city =
      DropDown(AppConstants().Cities, AppConstants().Cities[0], "City");
  DropDown district = DropDown(
      AppConstants().Districts, AppConstants().Districts[0], "District");
  DropDown state =
      DropDown(AppConstants().States, AppConstants().States[0], "State");
  OutLineTextFieldForNormalEntry landmark = OutLineTextFieldForNormalEntry(
      "LandMark",
      AppConstants().landmarkValidateRegexString,
      AppConstants().landmarkRegexErrorTextString,
      "");
  OutLineTextFieldForNormalEntry phoneNumber = OutLineTextFieldForNormalEntry(
      'Phone Number',
      AppConstants().phoneNumberValidateRegexString,
      AppConstants().phoneNumberRegexErrorTextString,
      "");
  OutLineTextFieldForNormalEntry address = OutLineTextFieldForNormalEntry(
      "Address",
      AppConstants().addressValidateRegexString,
      AppConstants().addressRegexErrorTextString,
      "");
  OutLineTextFieldForNormalEntry pincode = OutLineTextFieldForNormalEntry(
      "Pin Code",
      AppConstants().pincodeValidateRegexString,
      AppConstants().pincodeRegexErrorTextString,
      "");
  OutLineTextFieldForNormalEntry alternativePhoneNumber =
      OutLineTextFieldForNormalEntry(
          'Alternative Phone Number',
          AppConstants().phoneNumberValidateRegexString,
          AppConstants().phoneNumberRegexErrorTextString,
          "");
  List<EncapsulatedContainerForNewBook> books;

  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  Future<bool> doWeHaveRequiredQuantityOfBooks(String bookAddress,EncapsulatedContainerForNewBook book) async {
    int availablePieces = int.parse(await GetBookDetails().getBookAvailablePieces(bookAddress));
    String bookName = await GetBookDetails().getBookName(bookAddress);
    if(int.parse(book.bookQuantity)<=availablePieces){
      return true;
    }
    AppConstants().defaultSnackBarForApp(context, "We have only ${availablePieces} available copies for the book ${bookName} , for further purchasing try to decrease quantity!");
    return false;
  }
  Future<void> validateDetailsAndFurtherProcessing() async {
    if (widget.books != null) {
      if (RegExp(AppConstants().addressValidateRegexString)
          .hasMatch(widget.address.data)) {
        if (RegExp(AppConstants().landmarkValidateRegexString)
            .hasMatch(widget.landmark.data)) {
          if (RegExp(AppConstants().pincodeValidateRegexString)
              .hasMatch(widget.pincode.data)) {
            if (RegExp(AppConstants().phoneNumberValidateRegexString)
                .hasMatch(widget.phoneNumber.data)) {
              if (RegExp(AppConstants().phoneNumberValidateRegexString)
                  .hasMatch(widget.alternativePhoneNumber.data)) {

                if(widget.type!='sell'){            //that is buy
                  for (int j = 0; j < widget.books.length; j++) {
                    String bookName = widget.books[j].bookName;
                    String publisher = widget.books[j].bookPublisher;
                    String edition = widget.books[j].bookEdition;
                    String authors = widget.books[j].authorName;
                    String status = widget.books[j].bookStatus;
                    String bookAddress = '$bookName@$authors@$publisher@$status@$edition';
                    if(await doWeHaveRequiredQuantityOfBooks(bookAddress, widget.books[j])==false)
                    {
                      return;
                    }
                  }
                }

                EncapsulatedContainerForDelieveryDetails delivery =
                    EncapsulatedContainerForDelieveryDetails(
                        widget.address.data,
                        widget.landmark.data,
                        widget.pincode.data,
                        widget.city.selectedItem,
                        widget.phoneNumber.data,
                        widget.alternativePhoneNumber.data,
                        widget.district.selectedItem,
                        widget.state.selectedItem);

                for (int j = 0; j < widget.books.length; j++) {
                  if(widget.type=="sell"){
                  String result = await SetBookDetails()
                      .addBookWithVerification(context, widget.books[j]);
                  if (result == 'done') {
                    await DeliveryDetails().setSellerDeliveryDetailsForPending(
                        context, delivery, widget.books[j]);
                    if (widget.checkBoxValue == true) {
                      await DeliveryDetails()
                          .setNewSavedDeliveryDetails(context, delivery);
                    }
                  }
                }
                  else{
                    String result = await SetBookDetails()
                        .buyThisBook(context, widget.books[j]);
                    if (result == 'done') {
                      String bookName = widget.books[j].bookName;
                      String publisher = widget.books[j].bookPublisher;
                      String edition = widget.books[j].bookEdition;
                      String authors = widget.books[j].authorName;
                      String status = widget.books[j].bookStatus;
                      String bookAddress = '$bookName@$authors@$publisher@$status@$edition';
                      await SetBookDetails().setAvailablePieces(context, bookAddress, widget.books[j].bookQuantity);
                      await DeliveryDetails().setBuyerDeliveryDetailsForPending(
                          context, delivery, widget.books[j]);
                      if (widget.checkBoxValue == true) {
                        await DeliveryDetails()
                            .setNewSavedDeliveryDetails(context, delivery);
                      }
                    }
                  }
                }
                Navigator.pop(context);
              } else {
                AppConstants().defaultSnackBarForApp(
                    context, AppConstants().phoneNumberRegexErrorTextString);
              }
            } else {
              AppConstants().defaultSnackBarForApp(
                  context, AppConstants().phoneNumberRegexErrorTextString);
            }
          } else {
            AppConstants().defaultSnackBarForApp(
                context, AppConstants().pincodeRegexErrorTextString);
          }
        } else {
          AppConstants().defaultSnackBarForApp(context, "check landmark");
        }
      } else {
        AppConstants().defaultSnackBarForApp(context, "check address!");
      }
    } else {
      AppConstants().defaultSnackBarForApp(
          context, "Something went wrong go back to previous screen!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
      ),
      backgroundColor: AppConstants().appBackgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: widget.wait,
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30, horizontal: 20.0),
                  child: Text(
                    "Delievery details",
                    style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 40,
                        color: Colors.green),
                  ),
                ),
                CachedNetworkImage(
                  imageUrl:
                      'https://media.giphy.com/media/Pj19z6yzCpa1oQEvhe/giphy.gif',
                  //'https://media.giphy.com/media/BjdrLKsItWuj751q8x/giphy.gif',
                  placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(),
                    height: 50,
                    width: 50,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 80),
                  child: ElevatedButton(
                    child: Text(
                      "Take previous details",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      setState(() {
                        widget.wait = true;
                      });
                      EncapsulatedContainerForDelieveryDetails?
                          savedDeliveryDetails = await DeliveryDetails()
                              .getSavedDeliveryDetails(context);

                      if (savedDeliveryDetails != null) {
                        setState(() {
                          widget.address = OutLineTextFieldForNormalEntry(
                              "Address",
                              AppConstants().addressValidateRegexString,
                              AppConstants().addressRegexErrorTextString,
                              savedDeliveryDetails.address);
                          widget.landmark = OutLineTextFieldForNormalEntry(
                              "LandMark",
                              AppConstants().landmarkValidateRegexString,
                              AppConstants().landmarkRegexErrorTextString,
                              savedDeliveryDetails.landmark);
                          widget.pincode = OutLineTextFieldForNormalEntry(
                              "Pin Code",
                              AppConstants().pincodeValidateRegexString,
                              AppConstants().pincodeRegexErrorTextString,
                              savedDeliveryDetails.pincode);
                          widget.city = DropDown(AppConstants().Cities,
                              savedDeliveryDetails.city, "City");
                          widget.phoneNumber = OutLineTextFieldForNormalEntry(
                              'Phone Number',
                              AppConstants().phoneNumberValidateRegexString,
                              AppConstants().phoneNumberRegexErrorTextString,
                              savedDeliveryDetails.phoneNumber);
                          widget.alternativePhoneNumber =
                              OutLineTextFieldForNormalEntry(
                                  'Alternative Phone Number',
                                  AppConstants().phoneNumberValidateRegexString,
                                  AppConstants()
                                      .phoneNumberRegexErrorTextString,
                                  savedDeliveryDetails.alternativePhoneNumber);
                          widget.district = DropDown(AppConstants().Districts,
                              savedDeliveryDetails.district, "District");
                          widget.state = DropDown(AppConstants().States,
                              savedDeliveryDetails.state, "State");
                        });
                      } else {
                        AppConstants().defaultSnackBarForApp(
                            context, 'sorry you donot have saved address!');
                      }
                      setState(() {
                        widget.wait = false;
                      });
                    },
                    style: AppConstants().commonElevatedButtonStyle,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 80),
                  child: Text(
                    "or",
                    style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 38,
                        fontFamily: 'BungeeShade'),
                  ),
                ),
                widget.address,
                widget.landmark,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(child: widget.pincode),
                      Expanded(
                        child: Theme(
                            data: ThemeData(primarySwatch: Colors.deepOrange),
                            child: widget.city),
                      ),
                    ],
                  ),
                ),
                widget.phoneNumber,
                widget.alternativePhoneNumber,
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                            child: Theme(
                          data: ThemeData(
                            primarySwatch: Colors.orange,
                          ),
                          child: widget.district,
                        ))
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                            child: Theme(
                          data: ThemeData(
                            primarySwatch: Colors.orange,
                          ),
                          child: widget.state,
                        ))
                      ],
                    )),
                Theme(
                  data: ThemeData(
                    primarySwatch: Colors.orange,
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          //activeColor: Colors.white,

                          value: widget.checkBoxValue,
                          onChanged: (bool? value) {
                            setState(() {
                              widget.checkBoxValue = value!;
                            });
                          },
                        ),
                        Text(
                          'Remember this address',
                          style: TextStyle(color: Colors.orange),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 80),
                  child: ElevatedButton(
                    child: Text(
                      "Done",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      setState(() {
                        widget.wait = true;
                      });
                      validateDetailsAndFurtherProcessing();
                      setState(() {
                        widget.wait = false;
                      });
                    },
                    style: AppConstants().commonElevatedButtonStyle,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

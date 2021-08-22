import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:oldshelvesupdated/AppConstants.dart';
import 'package:oldshelvesupdated/Backend/EncapsulatedContainerForNewBook.dart';
import 'package:oldshelvesupdated/Backend/SetBookDetails.dart';
import 'package:oldshelvesupdated/Components/OutLineTextFieldForBookOverView.dart';
import 'package:oldshelvesupdated/HomePage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Backend/GetUserDetails.dart';
import 'Components/ChipsCreator.dart';
import 'Components/DropDown.dart';
import 'Components/OutLineTextFieldForNormalEntry.dart';
import 'DelieveryPage.dart';
import 'ImageProcessing.dart';

class FileUploadPage extends StatefulWidget {
  bool DirectTrigger = HomePage.DirectTrigger;
  bool wait = false;
  OutLineTextFieldForNormalEntry bookName = OutLineTextFieldForNormalEntry(
      'Book name',
      AppConstants().bookNameValidateRegexString,
      AppConstants().bookNameRegexErrorTextString,
      "");
  OutLineTextFieldForNormalEntry authors = OutLineTextFieldForNormalEntry(
      'Author name',
      AppConstants().authorNameValidateRegexString,
      AppConstants().authorNameRegexErrorTextString,
      "");
  OutLineTextFieldForNormalEntry publisher = OutLineTextFieldForNormalEntry(
      'Book publisher name',
      AppConstants().publisherNameValidateRegexString,
      AppConstants().publisherNameRegexErrorTextString,
      "");
  OutLineTextFieldForNormalEntry marketPrice = OutLineTextFieldForNormalEntry(
      "Book market price",
      AppConstants().marketPriceValidateRegexString,
      AppConstants().marketPriceRegexErrorTextString,
      "");
  OutLineTextFieldForNormalEntry desiredPrice = OutLineTextFieldForNormalEntry(
      "Your desired price",
      AppConstants().desiredPriceValidateRegexString,
      AppConstants().desiredPriceRegexErrorTextString,
      "");

  OutLineTextFieldForBookOverView bookOverview =
      OutLineTextFieldForBookOverView("Enter Some details about this book");

  DropDown language = DropDown(AppConstants().AvailableLanguages,
      AppConstants().AvailableLanguages[0], "Language");

  DropDown quantity = DropDown(AppConstants().QuantitiesForUploading,
      AppConstants().QuantitiesForUploading[0], "Quantity");
  DropDown bookStatus = DropDown(AppConstants().acceptableBookConditions,
      AppConstants().acceptableBookConditions[0], "Book Status");
  DropDown bookEdition = DropDown(AppConstants().AvailableEditions,
      AppConstants().AvailableEditions[1], "Book Edition");

  Container imageContainer = Container();
  final List<String> availableTagList = AppConstants().AvailableTagsList;
  List<ChipsCreator> availableChips = [];
  String extension = "";
  String imagePath = "";
  Container chipsContainer = Container();

  @override
  _FileUploadPageState createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  Future<void> validateDetailsAndFurtherProcessing() async {
    if (RegExp(AppConstants().bookNameValidateRegexString)
        .hasMatch(widget.bookName.data)) {
      if (RegExp(AppConstants().authorNameValidateRegexString)
          .hasMatch(widget.authors.data)) {
        if (RegExp(AppConstants().publisherNameValidateRegexString)
            .hasMatch(widget.publisher.data)) {
          if (RegExp(AppConstants().marketPriceValidateRegexString)
              .hasMatch(widget.marketPrice.data)) {
            if (RegExp(AppConstants().desiredPriceValidateRegexString)
                .hasMatch(widget.desiredPrice.data)) {
              if (ChipsCreator.tags.length > 1) {
                if (widget.imagePath != "") {
                  if (widget.bookOverview.data.length > 10) {
                    EncapsulatedContainerForNewBook bookDetails =
                        EncapsulatedContainerForNewBook(
                            widget.bookName.data,
                            widget.authors.data,
                            widget.publisher.data,
                            widget.bookStatus.selectedItem,
                            widget.bookEdition.selectedItem,
                            widget.marketPrice.data,
                            widget.desiredPrice.data,
                            widget.quantity.selectedItem,
                            widget.imagePath,
                            widget.extension,
                            ChipsCreator.tags,
                            widget.language.selectedItem,
                            widget.bookOverview.data);
                    if (await GetUserDetails().checkUserSuperiority() ==
                            'exist' &&
                        widget.DirectTrigger == true) {
                      setState(() {
                        widget.wait = true;
                      });
                      await SetBookDetails().addNewBook(
                          context, widget.DirectTrigger, bookDetails);
                      setState(() {
                        widget.wait = false;
                      });
                    } else {
                      List<EncapsulatedContainerForNewBook> books = [];
                      books.add(bookDetails);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeliveryPage(books, "sell")),
                      );
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } else {
                    AppConstants().defaultSnackBarForApp(
                        context, "Enter some more book overview");
                  }
                } else {
                  AppConstants().defaultSnackBarForApp(
                      context, "please select a image first!");
                }
              } else {
                AppConstants().defaultSnackBarForApp(
                    context, 'please select at least 1 tag');
              }
            } else {
              AppConstants().defaultSnackBarForApp(
                  context, 'please enter a valid desired price!');
            }
          } else {
            AppConstants().defaultSnackBarForApp(
                context, 'please enter a valid market price!');
          }
        } else {
          AppConstants().defaultSnackBarForApp(
              context, 'please enter a valid publisher name!');
        }
      } else {
        AppConstants().defaultSnackBarForApp(
            context, 'please enter a valid author name!');
      }
    } else {
      AppConstants()
          .defaultSnackBarForApp(context, 'please enter a valid book name!');
    }
  }

  Future<void> addImageToFileUploadScreen(String path) async {
    if (path != null) {
      widget.imagePath = path;
      Uint8List data = (File(path).readAsBytesSync());
      setState(() {
        imageCache!.clear();

        widget.imageContainer = Container(
          child: Image(
            image: MemoryImage(data, scale: 0.5),
          ),
        );
      });
    }
  }

  Future<void> furtherProcessingOnImage(
      String path, PickedFile? pickedImage, ImageProcessing imgObject) async {
    if (pickedImage != null) {
      bool isImageHaveSupportedExtension =
          imgObject.isChoosenImageIsJpgPngOrJpeg(pickedImage);
      if (isImageHaveSupportedExtension) {
        if (imgObject.checkImageIsUnderMaximumAlottedSize(pickedImage)) {
          File? croppedImage =
              await imgObject.imageCrop(pickedImage).then((value) {
            return value;
          });
          if (croppedImage != null) {
            widget.extension = imgObject.getImageExtension(croppedImage);
            path = path + 'thisimg${widget.extension}';
            File? compressedImage =
                await imgObject.imageCompress(croppedImage, path).then((value) {
              return value;
            });
            if (compressedImage != null) {
              addImageToFileUploadScreen(path);
            } else {
              AppConstants().defaultSnackBarForApp(
                  context, "Something is wrong with Compressor!");
            }
          } else {
            AppConstants()
                .defaultSnackBarForApp(context, "Image isn't cropped!");
          }
        } else {
          AppConstants().defaultSnackBarForApp(context,
              "Whoopsyy! size is too large you can select at maximum 5mb image");
        }
      } else {
        AppConstants().defaultSnackBarForApp(
            context, "You can only select png,jpg,jpeg files!");
      }
    } else {
      AppConstants().defaultSnackBarForApp(context, "Please Select an Image!");
    }
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.availableTagList.length; i++) {
      widget.availableChips
          .add(ChipsCreator(widget.availableTagList[i], Colors.indigoAccent));
    }
    setState(() {
      widget.chipsContainer = Container(
        height: 170,
        child: ListView(
          children: [
            Center(
              child: Container(
                child: Wrap(
                  verticalDirection: VerticalDirection.down,
                  spacing: 5.0,
                  runSpacing: 10.0,
                  children: widget.availableChips,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.orange.shade200,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text(
          'Sell Item',
          style: TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        ),
        elevation: 0,
      ),
      backgroundColor: AppConstants().appBackgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: widget.wait,
        child: ListView(
          children: [
            widget.bookName,
            widget.authors,
            widget.publisher,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Theme(
                data: ThemeData(
                  primarySwatch: Colors.orange,
                ),
                child: Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 0),
                            child: widget.bookStatus),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: widget.bookEdition),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            widget.marketPrice,
            widget.desiredPrice,
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: widget.language,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: widget.quantity,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.image,
                color: Colors.grey.shade300,
              ),
              iconSize: 50,
              onPressed: () async {
                if (await Permission.camera.request().isGranted &&
                    await Permission.storage.request().isGranted) {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Pick Image'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              GestureDetector(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Icon(
                                        Icons.camera,
                                        size: 50,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text('Camera'),
                                    )
                                  ],
                                ),
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  Directory? dir =
                                      await getExternalStorageDirectory();
                                  String path = dir!.path;
                                  ImageProcessing imgObject = ImageProcessing();
                                  PickedFile? pickedImage = await imgObject
                                      .imagePickFromCamera()
                                      .then((value) {
                                    return value;
                                  });
                                  furtherProcessingOnImage(
                                      path, pickedImage, imgObject);
                                },
                              ),
                              GestureDetector(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Icon(
                                          Icons.storage,
                                          size: 50,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text('Storage'),
                                      )
                                    ],
                                  ),
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    Directory? dir =
                                        await getExternalStorageDirectory();
                                    String path = dir!.path;
                                    ImageProcessing imgObject =
                                        ImageProcessing();
                                    PickedFile? pickedImage = await imgObject
                                        .imagePickFromGallery()
                                        .then((value) {
                                      return value;
                                    });
                                    furtherProcessingOnImage(
                                        path, pickedImage, imgObject);
                                  }),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else if (await Permission.camera.isPermanentlyDenied ||
                    await Permission.storage.isPermanentlyDenied) {
                } else if (await Permission.camera.isRestricted ||
                    await Permission.storage.isRestricted) {
                } else {}
              },
            ),
            widget.imageContainer,
            widget.bookOverview,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Text(
                    'Select tags for this book',
                  ),
                  widget.chipsContainer
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: ElevatedButton(
                child: Text(
                  'Done',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                style: AppConstants().commonElevatedButtonStyle,
                onPressed: () async {
                  validateDetailsAndFurtherProcessing();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

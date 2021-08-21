import 'package:flutter/cupertino.dart';

class EncapsulatedContainerForNewBook{
  EncapsulatedContainerForNewBook(@required this.bookName,@required this.authorName,@required this.bookPublisher,@required this.bookStatus,@required this.bookEdition,@required this.marketPrice,@required this.desiredPrice,@required this.bookQuantity,@required this.coverImagePath,@required this.imageExtension,@required this.tags,@required this.language,@required this.overView);
  final String bookName;
  final String authorName;
  final String bookPublisher;
  final String bookStatus;
  final String bookEdition;
  final String marketPrice;
  final String desiredPrice;
  final String bookQuantity;
  final String coverImagePath;
  final String imageExtension;
  final List<String> tags;
  final String language;
  final String overView;

}
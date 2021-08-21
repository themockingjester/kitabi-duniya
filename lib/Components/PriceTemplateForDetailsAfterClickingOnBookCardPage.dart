import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oldshelvesupdated/Backend/ShowSpecificBookDetailAsynchronously.dart';
class PriceTemplateForDetailsAfterClickingOnBookCardPage extends StatelessWidget {
  ShowSpecificBookDetailAsynchronously bookMarketPrice;
  ShowSpecificBookDetailAsynchronously ourPriceForBook;
  PriceTemplateForDetailsAfterClickingOnBookCardPage(@required this.bookMarketPrice,@required this.ourPriceForBook);
  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Price ',
            style: TextStyle(
                fontSize: 35,
                color: Colors.orange

            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              this.bookMarketPrice,
              this.ourPriceForBook,
              Text(
                '\u{20B9}',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.green

                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

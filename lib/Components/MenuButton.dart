import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:oldshelvesupdated/Backend/Queries.dart';
import 'package:oldshelvesupdated/CartPage.dart';
import 'package:oldshelvesupdated/HomePage.dart';
import 'package:oldshelvesupdated/SearchResultPage.dart';
import '../FileUploadPage.dart';
class MenuButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FabCircularMenu(
      ringDiameter: 200.5,
      animationCurve: Curves.elasticInOut,

      alignment: Alignment.bottomLeft,
      ringColor: Colors.orange,
      fabColor: Colors.purple.shade300,
      children: <Widget>[
        IconButton(icon: Icon(Icons.home), onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );

        },
          tooltip: "Home",

        ),

        IconButton(icon: Icon(Icons.local_atm), onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FileUploadPage()),
          );
        },
          tooltip: "Sell Book",),


        IconButton(icon: Icon(Icons.shopping_cart_outlined), onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartPage()),
          );
        },
          tooltip: "Cart",),

      ],

    );
  }
}

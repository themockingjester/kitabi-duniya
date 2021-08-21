import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class QuantityIncreaseAndDecreaseWidget extends StatefulWidget {

  int quantity=1;
  @override
  _QuantityIncreaseAndDecreaseWidgetState createState() => _QuantityIncreaseAndDecreaseWidgetState();
}

class _QuantityIncreaseAndDecreaseWidgetState extends State<QuantityIncreaseAndDecreaseWidget> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data : ThemeData(
        primarySwatch: Colors.deepOrange,

      ),
      child: Container(
        //width: 150,
        height:40,


        child: Row(

          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(

              child: Icon(
                Icons.remove,
              ),

              onPressed: (){
                if(widget.quantity!=1){
                  setState(() {
                    widget.quantity-=1;
                  });
                }
              },
            ),
            Container(
              height: 40,
              child: Column(

                children: [
                  Text(
                    '${widget.quantity}',
                    style: TextStyle(

                        color: Colors.deepOrange
                    ),
                  ),

                  Text(
                    'Quantity',
                    style: TextStyle(
                        fontSize: 6,
                      color: Colors.deepOrange
                    ),
                  )
                ],
              ),
            ),
            TextButton(
              child: Icon(
                Icons.add,
              ),
              onPressed: (){
                setState(() {
                  widget.quantity+=1;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

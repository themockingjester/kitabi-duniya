import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
class OutLineTextFieldForNormalEntry extends StatefulWidget {

  OutLineTextFieldForNormalEntry(@required this.hintText,@required this.validatorRegexString,@required this.errorTextForValidator,@required this.data);
  String data;
  String validatorRegexString;
  String errorTextForValidator;



  final String hintText;
  @override
  _OutLineTextFieldForNormalEntryState createState() => _OutLineTextFieldForNormalEntryState();
}

class _OutLineTextFieldForNormalEntryState extends State<OutLineTextFieldForNormalEntry> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
      child: Theme(
        data:ThemeData(
            primarySwatch: Colors.orange
        ),
        child: TextFormField(

          cursorColor: Colors.deepOrange,
          cursorHeight: 25,
          key: Key(widget.data.toString()), // <- Magic!
          initialValue: widget.data,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: MultiValidator([
            RequiredValidator(errorText: 'this field is required'),
            PatternValidator(widget.validatorRegexString, errorText: widget.errorTextForValidator)
          ]),
          textAlign: TextAlign.center,
          onChanged: (String value){

              widget.data = value;

          },

          decoration: new InputDecoration(

            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrange),
              borderRadius: const BorderRadius.all(
                const Radius.circular(15.0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
              borderRadius: const BorderRadius.all(
                const Radius.circular(15.0),
              ),

            ),


            filled: true,
            fillColor: Colors.grey.shade100,

            hintStyle: new TextStyle(color: Colors.grey.shade500),
            labelText: widget.hintText,

          ),
        ),
      ),
    );
  }
}

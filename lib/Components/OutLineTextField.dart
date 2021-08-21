import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
class OutLineTextField extends StatefulWidget {
  OutLineTextField(@required this.icon,@required this.hintText,@required this.validatorRegexString,@required this.errorTextForValidator,@required this.shouldHide);
  String hintText;
  String validatorRegexString;
  String errorTextForValidator;
  String data="";
  bool shouldHide;
  IconData icon;
  @override
  _OutLineTextFieldState createState() => _OutLineTextFieldState();
}

class _OutLineTextFieldState extends State<OutLineTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
      child: Theme(
        data:ThemeData(
          primarySwatch: Colors.deepPurple
        ),
        child: TextFormField(
          obscureText: widget.shouldHide,
          cursorColor: Colors.deepPurple,
          cursorHeight: 25,
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
              borderSide: BorderSide(color: Colors.deepPurple),
              borderRadius: const BorderRadius.all(
                const Radius.circular(15.0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple),
              borderRadius: const BorderRadius.all(
                const Radius.circular(15.0),
              ),

            ),

              prefixIcon: Icon(

                widget.icon,

                ),
              filled: true,
              fillColor: Colors.grey.shade100,

              hintStyle: new TextStyle(color: Colors.grey.shade500),
              hintText: widget.hintText,
              ),
        ),
      ),
    );
  }
}

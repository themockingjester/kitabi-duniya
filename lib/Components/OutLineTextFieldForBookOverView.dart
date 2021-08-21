import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class OutLineTextFieldForBookOverView extends StatefulWidget {
  String data = "";
  String hintText;

  OutLineTextFieldForBookOverView(@required this.hintText);

  @override
  _OutLineTextFieldForBookOverViewState createState() =>
      _OutLineTextFieldForBookOverViewState();
}

class _OutLineTextFieldForBookOverViewState
    extends State<OutLineTextFieldForBookOverView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Theme(
        data: ThemeData(primarySwatch: Colors.orange),
        child: TextFormField(
          maxLines: null,
          cursorColor: Colors.deepOrange,
          cursorHeight: 25,
          key: Key(widget.data.toString()),
          // <- Magic!
          initialValue: widget.data,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: MultiValidator([
            RequiredValidator(errorText: 'this field is required'),
            //PatternValidator(widget.validatorRegexString, errorText: widget.errorTextForValidator)
          ]),
          textAlign: TextAlign.start,
          onChanged: (String value) {
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

import 'package:flutter/material.dart';
import 'package:oldshelvesupdated/Backend/AuthFile.dart';
import 'package:oldshelvesupdated/LoginPage.dart';
import 'Components/OutLineTextField.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'AppConstants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'Backend/UserDetailsAdder.dart';
import 'HomePage.dart';
class SignUpPage extends StatefulWidget {
  bool wait=false;
  OutLineTextField email = OutLineTextField(Icons.email, "Email",AppConstants().emailValidateRegexString,AppConstants().emailRegexErrorTextString,false);
  OutLineTextField name = OutLineTextField(Icons.person, "Full Name",AppConstants().personNameValidateRegexString,AppConstants().personNameRegexErrorTextString,false);
  String dob="";
  OutLineTextField password = OutLineTextField(Icons.vpn_key, "Password",AppConstants().passwordValidateRegexString,AppConstants().passwordRegexErrorTextString,true);
  OutLineTextField retypePassword = OutLineTextField(Icons.vpn_key_outlined, "Retype Password",AppConstants().passwordValidateRegexString,AppConstants().passwordRegexErrorTextString,true);
  OutLineTextField phone = OutLineTextField(Icons.phone, "Your Phone Number",AppConstants().phoneNumberValidateRegexString,AppConstants().phoneNumberRegexErrorTextString,false);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Future<void> verifyDetailsForCurrentScreen() async {

    if(RegExp(AppConstants().emailValidateRegexString).hasMatch(widget.email.data)){
      if(widget.password.data==widget.retypePassword.data && RegExp(AppConstants().passwordValidateRegexString).hasMatch(widget.password.data)){
        if(RegExp(AppConstants().phoneNumberValidateRegexString).hasMatch(widget.phone.data)){
          if(widget.dob!=""){
            if(RegExp(AppConstants().personNameValidateRegexString).hasMatch(widget.name.data)){
              String result = await AuthFile().registration(widget.email.data, widget.password.data);
              if(result=="Successfully Registered!!"){
                UserDetailsAdder().addNewUserDetails(widget.name.data, widget.email.data, widget.dob, widget.phone.data, context);
              }
              AppConstants().defaultSnackBarForApp(context, result);
            }
            else{
              AppConstants().defaultSnackBarForApp(context, AppConstants().personNameRegexErrorTextString);
            }
          }
          else{
            AppConstants().defaultSnackBarForApp(context, "Enter a valid DateOfBirth!");
          }
        }
        else{
          AppConstants().defaultSnackBarForApp(context, AppConstants().phoneNumberRegexErrorTextString);
        }
      }
      else{
        AppConstants().defaultSnackBarForApp(context, "Either passwords are not matching or you haven't followed the password rules!");
      }
    }
    else{
      AppConstants().defaultSnackBarForApp(context, AppConstants().emailRegexErrorTextString);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      child: Scaffold(
        backgroundColor: AppConstants().appBackgroundColor,
        body: ModalProgressHUD(
          inAsyncCall: widget.wait,
          child: Container(
            //constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("asset/image/loginbackground.png"),
                  fit: BoxFit.fill),
            ),
            child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 60,horizontal: 20),
                        child: Text(
                          'SignUp',
                          style: TextStyle(
                              fontFamily: "Playball",
                              color: Colors.green,
                              fontSize: 60
                          ),
                        ),
                      ),
                      widget.name,
                      widget.email,
                      widget.password,
                      widget.retypePassword,
                      widget.phone,
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                        child: DateTimePicker(
                          type: DateTimePickerType.date,
                          dateMask: 'd MMM, yyyy',
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          icon: Icon(Icons.event),
                          dateLabelText: 'Your Date oF Birth',
                          timeLabelText: "Hour",

                          onChanged: (val) => widget.dob=val,
                          validator: (val) {

                          },
                          onSaved: (val) => {},
                        ),
                      ),
                        Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          child: Text('Back'),
                                        ),
                                        ElevatedButton(
                                          onPressed: (){
                                            setState(() {
                                              widget.wait=true;
                                            });
                                            verifyDetailsForCurrentScreen();
                                            setState(() {
                                              widget.wait=false;
                                            });
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => LoginPage()),
                                            );

                                          },
                                          child: Text('Go'),
                                        ),
                                      ],
                                    ),
                                  ),
                    ],
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:oldshelvesupdated/Backend/Queries.dart';
import 'package:oldshelvesupdated/Components/OutLineTextFieldForNormalEntry.dart';
import 'package:oldshelvesupdated/HomePage.dart';
import 'AskingUserInterestPage.dart';
import 'Backend/AuthFile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Components/OutLineTextField.dart';
import 'SignUpPage.dart';
import 'AppConstants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class LoginPage extends StatefulWidget {
  bool wait=false;
  OutLineTextField emailOrPhone = OutLineTextField(Icons.email,'Email',AppConstants().emailValidateRegexString,AppConstants().emailRegexErrorTextString);
  OutLineTextField password = OutLineTextField(Icons.vpn_key, 'Password',AppConstants().passwordValidateRegexString,AppConstants().passwordRegexErrorTextString);
  UserCredential? userCredential = null;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<void> verifyDetailsForCurrentPage() async {
    if(widget.emailOrPhone.data!=""){
      if(widget.password.data!=""){
        // widget.emailOrPhone.data
        //widget.password.data
        widget.userCredential = await AuthFile().signInWithEmailandPassword(widget.emailOrPhone.data, widget.password.data, context);
        if(widget.userCredential!=null){
          setState(() {
            widget.wait=false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      }
      else{
        AppConstants().defaultSnackBarForApp(context, "Enter a password first!");
      }
    }
    else{
      AppConstants().defaultSnackBarForApp(context, "Enter an email first!");
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
                        'Login',
                        style: TextStyle(
                            fontFamily: "Playball",
                          color: Colors.green,
                          fontSize: 60
                        ),
                      ),
                    ),

                    widget.emailOrPhone,
                    widget.password,
                        TextButton(
                          onPressed: (){
                            final _auth = FirebaseAuth.instance;

                            OutLineTextFieldForNormalEntry email = OutLineTextFieldForNormalEntry("Email","","","");
                            AlertDialog dialogForResetting = AlertDialog(
                              title: const Text('Reset Password'),
                              content: new Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  email,
                                ],
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    _auth.sendPasswordResetEmail(email: email.data);
                                    AppConstants().defaultSnackBarForApp(context, "Resetting link has been sent!");
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Done'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return dialogForResetting;
                                });

                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),


                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                widget.wait=true;
                              });

                              await verifyDetailsForCurrentPage();
                              setState(() {
                                widget.wait=false;
                              });

                            },
                            child: Text('Go'),
                          ),
                          ElevatedButton(
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignUpPage()),
                              );
                            },
                            child: Text('SignUp'),
                          ),

                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 30),
                    //   child: IconButton(
                    //     icon: Icon(
                    //       Icons.facebook,
                    //     ),
                    //     onPressed: (){
                    //
                    //     },
                    //     color: Colors.blueAccent,
                    //   ),
                    // ),


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

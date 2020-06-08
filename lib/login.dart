import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'register.dart';
import 'requests.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginView createState() => _LoginView();
} 


class _LoginView extends State<LoginView>{
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  bool _showPassword = false;

  DateTime currentBackPressTime;
  int beforeExit = 0;

  Widget build(BuildContext context){
    final emailField = FormBuilderTextField(
      attribute: "email",
      maxLines: 1,
      decoration: InputDecoration(
        labelText: "Email",
      ),
      validators: [
        FormBuilderValidators.required(errorText: "Email Required"),
        FormBuilderValidators.email(errorText: "Invalid Email"),
      ],
    );
    final passwordField = FormBuilderTextField(
      maxLines: 1,
      obscureText: !_showPassword,
      attribute: "password",
      decoration: InputDecoration(
        labelText: "Password",
        suffixIcon: IconButton(
          icon: Icon(
            Icons.remove_red_eye,
            color: _showPassword ? Colors.blue : Colors.grey,
          ),
          onPressed: () {
            setState(() => _showPassword = !_showPassword);
          },
        )
      ),
      validators: [
        FormBuilderValidators.required(errorText: "Password Required"),
        FormBuilderValidators.max(12),
        FormBuilderValidators.min(3),
      ],
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(formKey.currentState.saveAndValidate())
          {
            Query().loginUser(context, formKey.currentState.value);
          }
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final signupButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Colors.red,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context)  =>  RegisterView()),
          );
        },
        child: Text("Sign Up",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    Future<bool> _onWillPop() async {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: "Press again to exit");
        return Future.value(false);
      }
      return Future.value(true);
    }
    return Stack(
      children: <Widget>[
//        Image.asset(
//          "assets/app/app.gif",
//          height: MediaQuery.of(context).size.height,
//          width: MediaQuery.of(context).size.width,
//          fit: BoxFit.cover,
//        ),
        WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: Center(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(36.0, 80.0, 36.0, 36.0),
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 200.0,
                      child: Image.asset(
                        "assets/app/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    FormBuilder(
                        key: formKey,
                        autovalidate: true,
                        child: Column(
                            children: <Widget>[
                              emailField,
                              passwordField,
                            ]
                        )
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    loginButon,
                    SizedBox(
                      height: 15.0,
                    ),
                    signupButton,
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        )
      ]
    );
  }
}
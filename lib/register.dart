import 'package:duty_calls/reg_credents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class RegisterView extends StatelessWidget {
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final TextEditingController passController = new TextEditingController();
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  Widget build(BuildContext context){
    final firstname = FormBuilderTextField(
      attribute: "firstname",
      maxLines: 1,
      decoration: InputDecoration(labelText: "Firstname"),
      validators: [
        FormBuilderValidators.required(errorText: "Firstname Required"),
        FormBuilderValidators.min(2),
      ],
    );
    final middlename = FormBuilderTextField(
      attribute: "middlename",
      maxLines: 1,
      decoration: InputDecoration(labelText: "Middlename"),
      validators: [
        FormBuilderValidators.required(errorText: "Middlename Required"),
        FormBuilderValidators.min(2),
      ],
    );
    final lastname = FormBuilderTextField(
      attribute: "lastname",
      maxLines: 1,
      decoration: InputDecoration(labelText: "Lastname"),
      validators: [
        FormBuilderValidators.required(errorText: "Lastname Required"),
        FormBuilderValidators.min(2),
      ],
    );
    final emailField = FormBuilderTextField(
      attribute: "email",
      maxLines: 1,
      decoration: InputDecoration(labelText: "Email"),
      validators: [
        FormBuilderValidators.required(errorText: "Email Required"),
        FormBuilderValidators.email(errorText: "Invalid Email"),
      ],
    );
    final passwordField = FormBuilderTextField(
      controller: passController,
      maxLines: 1,
      obscureText: true,
      attribute: "password",
      decoration: InputDecoration(labelText: "Password"),
      validators: [
        FormBuilderValidators.required(errorText: "Password Required"),
        FormBuilderValidators.max(12),
        FormBuilderValidators.min(3),
      ],
    );
    final confirmPassField = FormBuilderTextField(
      attribute: "confpass",
      maxLines: 1,
      obscureText: true,
      decoration: InputDecoration(labelText: "Confirm Password"),
      validators: [
        FormBuilderValidators.pattern(passController.text, errorText: "Password does not match")
      ],
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("Already Registered?",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final signupButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(formKey.currentState.saveAndValidate()){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context)  =>  RegCredentsView(user: formKey.currentState.value)),
            );
          }
        },
        child: Text("Next >>",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
    return Stack(
        children: <Widget>[
        Image.asset(
          "assets/app/app.gif",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
          WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 155.0,
                        child: Image.asset(
                          "assets/app/logo.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 35.0),
                      FormBuilder(
                        key: formKey,
                        autovalidate: false,
                        child: Column(
                          children: <Widget>[
                              firstname,
                              middlename,
                              lastname,
                              emailField,
                              passwordField,
                              confirmPassField,
                            ]
                        )
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      signupButton,
                      SizedBox(
                        height: 15.0,
                      ),
                      loginButon,
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
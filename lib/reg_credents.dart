import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'requests.dart';

class RegCredentsView extends StatelessWidget{
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final Map user;
  RegCredentsView({this.user});

  Widget build(BuildContext context){
    final birthDate = FormBuilderDateTimePicker(
      attribute: "bdate",
      maxLines: 1,
      inputType: InputType.date,
      format: DateFormat("yyyy-MM-dd"),
      decoration:
      InputDecoration(labelText: "Birthdate"),
      validators: [
        FormBuilderValidators.required(errorText: "Birthdate Required"),
      ],
    );
    final signupButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.red,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if(formKey.currentState.saveAndValidate()){
            user.addAll(formKey.currentState.value);
          final Map list = {
              "user_email": user['email'].toString(),
              "user_password": user['password'].toString(),
              'profile_fname': user['firstname'].toString(),
              'profile_mname': user['middlename'].toString(),
              'profile_lname': user['lastname'].toString(),
              'profile_gender': user['gender'].toString(),
              'profile_civil_status': user['civStats'].toString(),
              'profile_bdate': user['bdate'].toString()
            };
            Query().registerUser(context, list);
          }
        },
        child: Text("Register",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final terms = FormBuilderCheckbox(
      attribute: 'accept_terms',
      label: Text("I have read and agree to the terms and conditions"),
      validators: [
        FormBuilderValidators.requiredTrue(errorText: "You must accept terms and conditions")
      ],
    );

    final civilStatus = FormBuilderDropdown(
      attribute: 'civStats',
      decoration: InputDecoration(labelText: "Civil Status"),
      initialValue: 'Single',
      hint: Text("Select Civil Status"),
      items: ['Single', 'Married', 'Separated', 'Widowed', 'Divorced'].map((civStats) => DropdownMenuItem(
        value: civStats,
        child: Text("$civStats")
      )).toList()
    );



    final gender = FormBuilderDropdown(
      attribute: 'gender',
      decoration: InputDecoration(labelText: "Gender"),
      initialValue: 'Male',
      hint: Text("Select Gender"),
      items: ['Male', 'Female'].map((gender) => DropdownMenuItem(
        value: gender,
        child: Text("$gender")
      )).toList()
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
                              initialValue: {
                                'accept_terms': false,
                              },
                              autovalidate: false,
                              child: Column(
                                  children: <Widget>[
                                    birthDate,
                                    civilStatus,
                                    gender,
                                    terms
                                  ]
                              )
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          signupButton,
                          SizedBox(
                            height: 5.0,
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
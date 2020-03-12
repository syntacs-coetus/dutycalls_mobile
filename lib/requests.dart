import 'dart:async';
import 'dart:convert';
import 'login.dart';

import 'main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

final baseURL = 'http://192.168.43.139:8000/api';


class ListedJobs{
  final int id;
  final String jobTitle;
  final String jobDesc;

  ListedJobs({this.id, this.jobTitle, this.jobDesc});

  factory ListedJobs.fromJson(Map<String, dynamic> json){
    return ListedJobs(
      id: json['id'],
      jobTitle: json['job_title'],
      jobDesc: json['job_description']
    );
  }
}

class JobCategory {
  final int id;
  final String catTitle;

  JobCategory({this.id, this.catTitle});

  factory JobCategory.fromJson(Map<String, dynamic> json) {
    return JobCategory(
      id:         json['id'],
      catTitle:  json['cat_title'],
    );
  }
}

class UserDetails{
  final int id;
  final String email;
  final String firstname;
  final String middlename;
  final String lastname;
  final String birthdate;
  final int type;
  final String civilstatus;
  final String avatar;

  final dateformat = new DateFormat('F-dd-yyyy');

  UserDetails({
    this.id,
    this.email,
    this.firstname,
    this.middlename,
    this.lastname,
    this.birthdate,
    this.type,
    this.civilstatus,
    this.avatar
  });

  factory UserDetails.fromJson(Map<String, dynamic> json){
    return UserDetails(
      id: json['user_id'],
      email: json['user_email'],
      firstname: json['profile_fname'],
      middlename: json['profile_mname'],
      lastname: json['profile_lname'],
      birthdate: json['profile_bdate'],
      type: json['user_type'],
      civilstatus: json['profile_civil_status'],
      avatar: json['profile_avatar']
    );
  }
}

class Providers {
  final String firstname;
  final String middlename;
  final String lastname;
  final int providerid;

  Providers({this.providerid, this.firstname, this.middlename, this.lastname});

  factory Providers.fromJson(Map<String, dynamic> json) {
    return Providers(
      providerid: json['provider_id'],
      firstname: json['profile_fname'],
      middlename: json['profile_mname'],
      lastname: json['profile_lname']
    );
  }
}

class Query{

  logoutUser(BuildContext context){
    Navigator.pushReplacement(context, 
    new MaterialPageRoute(
      builder: (BuildContext context) => new LoginView()
    ));
  }

  List<Providers> parseProvidersList(String responsebody){
    final parsed = json.decode(responsebody).cast<Map<String, dynamic>>();
    return parsed.map<Providers>((json) => Providers.fromJson(json)).toList();
  }


  Future<List<Providers>> fetchProvidersList(int id) async {
    final response = await http.get('$baseURL/jobtype/providers/$id', headers:{"Accept": "application/json"});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return parseProvidersList(response.body);
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load Job List');
    }
  }


  loginUser(BuildContext context, Map user) async {
    final response = await http.post('$baseURL/accounts/user/login', body: user, headers:{"Accept": "application/json"});
    if(response.statusCode == 200){
      Map data = jsonDecode(response.body);
      if(data['success'] == false){
        switch(data['type']){
          case 1:{
            return showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  content: SingleChildScrollView(
                    child: new Text("Incorrect Login Credentials, try again."),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      }, 
                      child: new Text("Continue"),
                    ),
                  ],
                );
              }
            );
          }
          case 2:{
            return showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  content: SingleChildScrollView(
                    child: new Text("Your Email Address is not yet confirmed."),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      }, 
                      child: new Text("Continue"),
                    ),
                  ],
                );
              }
            );
          }
          case 3:{
            return showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  content: SingleChildScrollView(
                    child: new Text("Your account is still being reviewed, please for 2 to 3 working days for admins to verify your account."),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      }, 
                      child: new Text("Continue"),
                    ),
                  ],
                );
              }
            );
          }
        }
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context)  =>  MyHomePage(id: data['id'], type: data['user_type'])),
        );
      }
    }
  }

  registerUser(BuildContext context, Map user) async {
    final response = await http.post('$baseURL/accounts/user/store', body: user, headers:{"Accept": "application/json"});

    if(response.statusCode == 200){
      Map data = jsonDecode(response.body);
      if(data['success'] == true){
        return showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              content: SingleChildScrollView(
                child: new Text("You have successfully registered. You may have to confirm your email first before logging in."),
              ),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, 
                    new MaterialPageRoute(
                      builder: (BuildContext context) => new LoginView()
                    ));
                  }, 
                  child: new Text("Continue"),
                ),
              ],
            );
          }
        );
      }else{
        return showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              content: SingleChildScrollView(
                child: new Text("Something wrong has happened and you cannot be registered at the moment."),
              ),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)  =>  LoginView()),
                    );
                  }, 
                  child: new Text("Continue"),
                ),
              ],
            );
          }
        );
      }
    }else{
      return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: SingleChildScrollView(
                child: Text("You might not be connected to the server, please try to connect to an internet connection"),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {}, 
                child: new Text("Continue"),
              ),
            ],
          );
        }
      );
    }
  }

  List<ListedJobs> parseJobList(String responsebody){
    final parsed = json.decode(responsebody).cast<Map<String, dynamic>>();
    return parsed.map<ListedJobs>((json) => ListedJobs.fromJson(json)).toList();
  }


  Future<List<ListedJobs>> fetchJobList(int id) async {
    final response = await http.get('$baseURL/jobtype/$id', headers:{"Accept": "application/json"});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return parseJobList(response.body);
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load Job List');
    }
  }

  Future<UserDetails> fetchUser(int id) async{
    final response = await http.get('$baseURL/accounts/user/$id', headers:{"Accept": "application/json"});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return UserDetails.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load User Details');
    }
  }

  List<JobCategory> parseJobCategory(String responsebody){
    final parsed = json.decode(responsebody).cast<Map<String, dynamic>>();
    return parsed.map<JobCategory>((json) => JobCategory.fromJson(json)).toList();
  }


  Future<List<JobCategory>> fetchJobCategory() async {
    final response = await http.get('$baseURL/jobcategory', headers:{"Accept": "application/json"});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return parseJobCategory(response.body);
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load Job Category');
    }
  }
}
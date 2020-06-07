import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'requests.dart';

class UserSettings extends StatefulWidget {
  final int userID;
  final int userType;

  UserSettings({this.userID, this.userType});

  _UserSettings createState() => _UserSettings(userID: this.userID, userType: this.userType);
}

class _UserSettings extends State<UserSettings> {
  final int userID;
  final int userType;
  _UserSettings({this.userID, this.userType});
  String newDate;
  Map<int, bool> checked = new Map<int, bool>();

  GetFirstDate(){
    var date = DateTime.now();
    return new DateTime(date.year - 50, date.month, date.day);
  }

  GetLastDate(){
    var date = DateTime.now();
    return new DateTime(date.year - 18, date.month, date.day);
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("User Settings"),
      ),
      body: FutureBuilder<UserDetails>(
        future: Query().fetchUser(this.userID),
        builder: (context, snapshot){
          if(snapshot.hasData){
            final data = snapshot.data;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  TextFormField(
                    maxLines: null,
                    textCapitalization: TextCapitalization.words,
                    initialValue: data.email,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: "Email"
                    ),
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (value) {
                      Fluttertoast.showToast(msg: "Account Updated");
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    initialValue: data.firstname,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: "Firstname"
                    ),
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (value) {
                      Fluttertoast.showToast(msg: "Account Updated");
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    initialValue: data.middlename,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: "Middlename"
                    ),
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (value) {
                      Fluttertoast.showToast(msg: "Account Updated");
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    initialValue: data.lastname,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: "Lastname"
                    ),
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (value) {
                      Fluttertoast.showToast(msg: "Account Updated");
                    },
                  ),
                  (userType == 2) ? 
                  Center(
                    child: OutlineButton(
                      child: Text("Edit Jobs"),
                      onPressed: () {
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: FutureBuilder<List<ProviderJobs>>(
                                future: Query().fetchAllJobs(),
                                builder: (context, snapshot){
                                  if(snapshot.hasData)
                                  {
                                    var data = snapshot.data;
                                    return ListView.builder(
                                      itemCount: data.length,
                                      itemBuilder: (BuildContext context, int index) {
                                      return FutureBuilder<JobsByProvider>(
                                        future: Query().fetchProviderJob(userID, data[index].id),
                                        builder: (context, snapshot){
                                          return Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            child: DefaultTextStyle(
                                              softWrap: false,
                                              overflow: TextOverflow.ellipsis,
                                              style: ThemeData().textTheme.subtitle1,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Checkbox(
                                                    value: snapshot.hasData,
                                                    onChanged: (value){
                                                      Query().updateProviderJob(context, userID, data[index].id);
                                                    },
                                                  ),
                                                  Text(data[index].title)
                                                ],
                                              )
                                            )
                                          );
                                        }
                                      );
                                     },
                                    );
                                  }
                                  return Center( child: CircularProgressIndicator() );
                                }
                              )
                            );
                          }
                        );
                      }
                    )
                  )
                  :
                  SizedBox(height: 0.0)
                ],
              )
            );
          }
          return Center(
            child: Column(
              children: <Widget>[
                Text("Please wait..."),
                CircularProgressIndicator()
              ],
            )
          );
        }
      )
    );
  }
}
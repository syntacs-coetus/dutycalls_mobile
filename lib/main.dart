import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import 'login.dart';
import 'dashboard.dart';
import 'requests.dart';
import 'user_profile.dart';
import 'map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: LoginView()
        // home: MyHomePage(id: 11, type: 1)
        );
  }
}

class MyHomePage extends StatefulWidget {
  final int id;
  final int type;
  MyHomePage({this.id, this.type});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() =>
      _MyHomePageState(id: this.id, type: this.type);
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  DateTime currentBackPressTime;
  int beforeExit = 0;
  final int id;
  final int type;
  bool _showPassword = false;
  final TextEditingController _reason = TextEditingController();

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  _MyHomePageState({this.id, this.type});

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildProviderRequest(BuildContext context, data, uid) {
    String status = "Pending";
    if (data.status != 2) {
      status = data.status == 1
          ? data.done == 0 ? "Accepted" : "Finished"
          : "Declined";
    }

    final ThemeData theme = Theme.of(context);
    return SafeArea(
        top: false,
        bottom: false,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                SizedBox(
                    height: 292.5,
                    child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                            onTap: () {},
                            splashColor: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.12),
                            highlightColor: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                    height: 115,
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned.fill(
                                          child: Ink.image(
                                            image: AssetImage(
                                              'assets/app/default_cover.jpg',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 16,
                                            left: 16,
                                            right: 16,
                                            child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  data.job,
                                                  style: theme
                                                      .textTheme.headline6
                                                      .copyWith(
                                                          color: Colors.white),
                                                ))),
                                      ],
                                    )),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 16, 16, 0),
                                    child: DefaultTextStyle(
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.subtitle1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Text(
                                                data.fName + " " + data.lName,
                                                style: theme.textTheme.subtitle1
                                                    .copyWith(
                                                        color: Colors.black54),
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Column(
                                                  children: <Widget>[
                                                    Text("Date: " +
                                                        data.date +
                                                        "\nTime: " +
                                                        data.time),
                                                    Text("Budget: " +
                                                        data.budget +
                                                        "PHP\nStatus: " +
                                                        status)
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ))),
                                data.status == 2
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          FlatButton(
                                              child: Text("Report"),
                                              textColor: Colors.red,
                                              onPressed: () {
                                                return showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        content: TextFormField(
                                                            controller:
                                                                this._reason,
                                                            decoration:
                                                                const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              hintText:
                                                                  'Tell us why we should accept you as a service provider.',
                                                              helperText:
                                                                  'keep it short and precise.',
                                                              labelText:
                                                                  'Why should we accept you?',
                                                            ),
                                                            maxLines: 2),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                              child: Text(
                                                                  "Report"),
                                                              textColor:
                                                                  Colors.red,
                                                              onPressed: () {
                                                                Query().sendReport(
                                                                    context,
                                                                    uid,
                                                                    data.userid,
                                                                    this
                                                                        ._reason
                                                                        .text);
                                                              }),
                                                          FlatButton(
                                                              child: Text(
                                                                  "Cancel"),
                                                              textColor:
                                                                  Colors.blue,
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              }),
                                                        ],
                                                      );
                                                    });
                                              }),
                                          FlatButton(
                                              child: Text("View"),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            new GoogleMaps(
                                                                provlat: data
                                                                    .provlat,
                                                                provlong: data
                                                                    .provlong,
                                                                lat: data
                                                                    .latitude,
                                                                long: data
                                                                    .longitude)));
                                              }),
                                          FlatButton(
                                            textColor: Colors.green,
                                            child: Text('Accept'),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        "Are you sure you want to accept this request?",
                                                        style: theme.textTheme
                                                            .bodyText2,
                                                      ),
                                                      content:
                                                          SingleChildScrollView(
                                                              child: Column(
                                                        children: <Widget>[
                                                          Text(
                                                              data.description),
                                                          Text(
                                                              "Note: This cannot be undone",
                                                              style: theme
                                                                  .textTheme
                                                                  .subtitle2)
                                                        ],
                                                      )),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child: Text('Cancel'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        FlatButton(
                                                          child:
                                                              Text('Proceed'),
                                                          onPressed: () {
                                                            Query()
                                                                .changeRequestStatus(
                                                                    context,
                                                                    data.id,
                                                                    uid,
                                                                    1);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                          ),
                                          FlatButton(
                                            textColor: Colors.red,
                                            child: Text('Reject'),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        "Are you sure you want to reject this request?",
                                                        style: theme.textTheme
                                                            .bodyText2,
                                                      ),
                                                      content:
                                                          SingleChildScrollView(
                                                              child: Column(
                                                        children: <Widget>[
                                                          Text(
                                                              data.description),
                                                          Text(
                                                              "Note: This cannot be undone",
                                                              style: theme
                                                                  .textTheme
                                                                  .subtitle2)
                                                        ],
                                                      )),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child: Text('Cancel'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        FlatButton(
                                                          child:
                                                              Text('Proceed'),
                                                          onPressed: () {
                                                            Query()
                                                                .changeRequestStatus(
                                                                    context,
                                                                    data.id,
                                                                    uid,
                                                                    0);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          FlatButton(
                                              child: Text("Report"),
                                              textColor: Colors.red,
                                              onPressed: () {
                                                return showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        content: TextFormField(
                                                            controller:
                                                                this._reason,
                                                            decoration:
                                                                const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              hintText:
                                                                  'Tell us the reason for reporting this person',
                                                              helperText:
                                                                  'keep it short and precise.',
                                                              labelText:
                                                                  'What did this person do?',
                                                            ),
                                                            maxLines: 2),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                              child: Text(
                                                                  "Report"),
                                                              textColor:
                                                                  Colors.red,
                                                              onPressed: () {
                                                                Query().sendReport(
                                                                    context,
                                                                    uid,
                                                                    data.userid,
                                                                    this
                                                                        ._reason
                                                                        .text);
                                                              }),
                                                          FlatButton(
                                                              child: Text(
                                                                  "Cancel"),
                                                              textColor:
                                                                  Colors.blue,
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              }),
                                                        ],
                                                      );
                                                    });
                                              }),
                                          (data.starttime == null)
                                              ? new FlatButton(
                                                  child: Text("Start"),
                                                  onPressed: () {
                                                    Query().startRequest(
                                                        context, uid, data.id);
                                                  },
                                                  textColor: Colors.green,
                                                )
                                              : data.done == 0
                                                  ? new FlatButton(
                                                      child: Text("Stop"),
                                                      onPressed: () {
                                                        return showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                  content:
                                                                      TextFormField(
                                                                obscureText:
                                                                    !_showPassword,
                                                                onFieldSubmitted:
                                                                    (value) {
                                                                  Query().finishRequest(
                                                                      context,
                                                                      uid,
                                                                      data.id,
                                                                      value);
                                                                },
                                                                decoration: InputDecoration(
                                                                    border: const UnderlineInputBorder(),
                                                                    filled: true,
                                                                    hintText: "i.e abcd123",
                                                                    labelText: "Code",
                                                                    helperText: "Type the code to stop the time",
                                                                    suffixIcon: GestureDetector(
                                                                        onTap: () {
                                                                          setState(
                                                                              () {
                                                                            _showPassword =
                                                                                !_showPassword;
                                                                          });
                                                                        },
                                                                        child: Icon(_showPassword ? Icons.visibility : Icons.visibility_off))),
                                                              ));
                                                            });
                                                      },
                                                      textColor: Colors.red,
                                                    )
                                                  : Row(),
                                          new FlatButton(
                                              child: Text("View"),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            new GoogleMaps(
                                                                provlat: data
                                                                    .provlat,
                                                                provlong: data
                                                                    .provlong,
                                                                lat: data
                                                                    .latitude,
                                                                long: data
                                                                    .longitude)));
                                              })
                                        ],
                                      )
                              ],
                            ))))
              ],
            )));
  }

  Widget _buildUserRequest(BuildContext context, data, uid) {
    String status = "Pending";
    int stars = 0;
    if (data.status != 2) {
      status = data.status == 1
          ? data.done == 0 ? "Accepted" : "Finished | Code: " + data.code
          : "Declined";
    }

    final description = FormBuilderTextField(
      attribute: "description",
      maxLines: 5,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText:
              "Write what the Service Provider should do i.e\nClean Bath thub\nScrub Floor\netc.",
          helperText: "Keep it short and simple",
          labelText: "Description"),
      initialValue: data.description,
      validators: [
        FormBuilderValidators.required(errorText: "Description Required"),
      ],
    );
    final datesched = FormBuilderDateTimePicker(
      attribute: "datesched",
      maxLines: 1,
      inputType: InputType.date,
      format: DateFormat("yyyy-MM-dd"),
      initialDate: DateTime.now(),
      initialValue: DateTime.now(),
      decoration: InputDecoration(labelText: "Date"),
      validators: [
        FormBuilderValidators.required(errorText: "Date Required"),
      ],
    );
    final timesched = FormBuilderDateTimePicker(
      attribute: "timesched",
      maxLines: 1,
      inputType: InputType.time,
      format: DateFormat("HH:mm a"),
      initialValue: DateTime.now(),
      initialTime: TimeOfDay.now(),
      decoration: InputDecoration(labelText: "Time"),
      validators: [
        FormBuilderValidators.required(errorText: "Time Required"),
      ],
    );
    final ThemeData theme = Theme.of(context);
    return SafeArea(
        top: false,
        bottom: false,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                SizedBox(
                    height: 260.0,
                    child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                            onTap: () {
                              return data.status == 2
                                  ? showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Edit your request for " +
                                              data.fName),
                                          content: SingleChildScrollView(
                                            child: Container(
                                              color: Colors.white,
                                              child: Column(
                                                children: <Widget>[
                                                  FormBuilder(
                                                      key: formKey,
                                                      initialValue: {
                                                        'date': DateTime.now(),
                                                        'time': DateTime.now(),
                                                        'accept_terms': false,
                                                      },
                                                      autovalidate: false,
                                                      child: Column(
                                                          children: <Widget>[
                                                            description,
                                                            FormBuilderTextField(
                                                              attribute:
                                                                  "budget",
                                                              maxLines: 1,
                                                              initialValue: (data
                                                                          .budget
                                                                          .toString() !=
                                                                      "null")
                                                                  ? data.budget
                                                                      .toString()
                                                                  : "",
                                                              decoration: InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  filled: true,
                                                                  hintText:
                                                                      "100.0",
                                                                  labelText:
                                                                      "Budget"),
                                                              validators: [
                                                                FormBuilderValidators
                                                                    .required(
                                                                        errorText:
                                                                            "Budget Required"),
                                                              ],
                                                            ),
                                                            datesched,
                                                            timesched
                                                          ])),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            FlatButton(
                                              child: Text('Proceed'),
                                              onPressed: () {
                                                if (formKey.currentState
                                                    .saveAndValidate()) {
                                                  final Map value = formKey
                                                      .currentState.value;
                                                  print(value);
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      })
                                  : data.done == 0
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Text(data.fName +
                                                  " has already accepted this request and it can't be edited anymore."),
                                            );
                                          })
                                      : showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Center(
                                                  child: Text("Rate me",
                                                      style: theme.textTheme
                                                          .subtitle2)),
                                              content: Row(
                                                  children:
                                                      List.generate(5, (index) {
                                                return IconButton(
                                                  onPressed: () {
                                                    return showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "Are you sure you want to rate " +
                                                                    (index + 1)
                                                                        .toString() +
                                                                    " stars to " +
                                                                    data.fName,
                                                                style: theme
                                                                    .textTheme
                                                                    .subtitle2),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    Query().updateStars(
                                                                        context,
                                                                        data.id,
                                                                        data
                                                                            .providerid,
                                                                        index +
                                                                            1);
                                                                  },
                                                                  child: Text(
                                                                      "Proceed")),
                                                              FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                      "Cancel")),
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  icon: Icon(index < stars
                                                      ? Icons.star
                                                      : Icons.star_border),
                                                  color: index < stars
                                                      ? Colors.amber
                                                      : Colors.black,
                                                );
                                              })),
                                            );
                                          });
                            },
                            splashColor: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.12),
                            highlightColor: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                    height: 115,
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned.fill(
                                          child: Ink.image(
                                            image: AssetImage(
                                              'assets/app/default_cover.jpg',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 16,
                                            left: 16,
                                            right: 16,
                                            child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  data.job,
                                                  style: theme
                                                      .textTheme.headline6
                                                      .copyWith(
                                                          color: Colors.white),
                                                ))),
                                      ],
                                    )),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 16, 16, 0),
                                    child: DefaultTextStyle(
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.subtitle1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Text(
                                                data.fName + " " + data.lName,
                                                style: theme.textTheme.subtitle1
                                                    .copyWith(
                                                        color: Colors.black54),
                                              ),
                                            ),
                                            Text("Date: " +
                                                data.date +
                                                "\nTime: " +
                                                data.time),
                                            Text("Budget: " +
                                                data.budget +
                                                "PHP\nStatus: " +
                                                status)
                                          ],
                                        )))
                              ],
                            ))))
              ],
            )));
  }

  _changeScreen(BuildContext content, int index, int type, int uid) {
    if (type == 2) {
      switch (index) {
        case 0:
          {
            return Dashboard(
                jobCategory: Query().fetchJobCategory(), userID: uid);
          }
        case 1:
          {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Your Request"),
                  backgroundColor: Colors.blue[900],
                ),
                body: FutureBuilder<List<PersonalRequest>>(
                    future: Query().fetchPersonalRequest(uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List data = snapshot.data;
                        return ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: data.length,
                            itemBuilder: (context, i) {
                              return _buildUserRequest(context, data[i], uid);
                            });
                      }
                      return Center(child: CircularProgressIndicator());
                    }));
          }
        case 2:
          {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Client Request"),
                  backgroundColor: Colors.blue[900],
                ),
                body: FutureBuilder<List<ClientRequest>>(
                    future: Query().fetchClientRequest(uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List data = snapshot.data;
                        return ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: data.length,
                            itemBuilder: (context, i) {
                              return _buildProviderRequest(
                                  context, data[i], uid);
                            });
                      }
                      return Center(child: CircularProgressIndicator());
                    }));
          }
        case 3:
          {
            return UserProfilePage(userid: uid, type: type);
          }
      }
    } else if (type == 1) {
      switch (index) {
        case 0:
          {
            return Dashboard(
                jobCategory: Query().fetchJobCategory(), userID: uid);
          }
        case 1:
          {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Your Request"),
                  backgroundColor: Colors.blue[900],
                ),
                body: FutureBuilder<List<PersonalRequest>>(
                    future: Query().fetchPersonalRequest(uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List data = snapshot.data;
                        return ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: data.length,
                            itemBuilder: (context, i) {
                              return _buildUserRequest(context, data[i], uid);
                            });
                      }
                      return Center(child: CircularProgressIndicator());
                    }));
          }
        case 2:
          {
            return UserProfilePage(userid: uid);
          }
      }
    }
  }

  userNavigation(int type) {
    switch (type) {
      case 1:
        {
          return const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Dashboard', style: TextStyle(color: Colors.white54)),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.table_chart),
              title: Text('Your Request'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_pin),
              title: Text('User Profile'),
            ),
          ];
        }
      case 2:
        {
          return const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Dashboard'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.table_chart),
              title: Text('Your Request'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              title: Text('Job Request'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_pin),
              title: Text('User Profile'),
            ),
          ];
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final int userID = this.id;
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

    return Stack(children: <Widget>[
      WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: _changeScreen(context, _selectedIndex, type, userID),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.blue[900],
            items: userNavigation(type),
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            onTap: _onItemTapped,
          ),
        ),
      )
    ]);
  }
}

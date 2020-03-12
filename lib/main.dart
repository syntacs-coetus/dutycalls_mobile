import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login.dart';
import 'dashboard.dart';
import 'requests.dart';
import 'user_profile.dart';

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
  _MyHomePageState createState() => _MyHomePageState(id: this.id, type: this.type);
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final _suggestions = <WordPair>[];
  final _secondSuggestion = <WordPair>[];
  DateTime currentBackPressTime;
  int beforeExit = 0;
  final int id;
  final int type;

  _MyHomePageState({this.id, this.type});

  Future<UserDetails> userDetails;
  Future<List<JobCategory>> categories;

  void initState(){
    super.initState();
    if(id != null){
      userDetails = Query().fetchUser(id);
    }
    categories = Query().fetchJobCategory();
  }

  _onItemTapped(int index){
    setState((){
      _selectedIndex = index;
    });
  }

  Widget _buildRow(int id, WordPair pair, WordPair secondPair){
    return ExpansionTile(
        title: Text("Title: "+pair.asPascalCase),
        subtitle: Text("Service Provider: "+secondPair.asPascalCase),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Location: Lawesbra, Lapasan'),
                    ],
                  ),
                ),
              ]
            )
          ),
          Align(
            alignment: Alignment.bottomRight,
            child:Padding(
                padding: const EdgeInsets.symmetric(horizontal:16.0, vertical: 10.0),
                child: Row(
                        children: <Widget>[FlatButton(
                            onPressed: () {},
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text('View'),
                                  new Icon(Icons.search),
                                ],
                              )
                          )
                        ]
                )
            ),
          )
        ]
      );
  }

  _changeScreen(BuildContext content, int index, int type) {
    if(type == 2){
      switch (index) {
        case 0:
          {
            return Dashboard(jobCategory: categories);
          }
        case 1:
          {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Category List"),
                ),
                body: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: 10,
                itemBuilder: (context, i){
                  if (i.isOdd) return Divider();

                  final index = i ~/ 2;

                  if(index >= _suggestions.length){
                    _suggestions.addAll(generateWordPairs().take(10));
                  }
                  if(index >= _secondSuggestion.length){
                    _secondSuggestion.addAll(generateWordPairs().take(10));
                  }
                  return _buildRow(index, _suggestions[index], _secondSuggestion[index]);
                }
              )
            );
          }
        case 2:
          {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Category List"),
                ),
                body: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, i){
                  if (i.isOdd) return Divider();

                  final index = i ~/ 2;

                  if(index >= _suggestions.length){
                    _suggestions.addAll(generateWordPairs().take(10));
                  }
                  if(index >= _secondSuggestion.length){
                    _secondSuggestion.addAll(generateWordPairs().take(10));
                  }
                  return _buildRow(index, _suggestions[index], _secondSuggestion[index]);
                }
              )
            );
          }
        case 3:
        {
            return UserProfilePage(user: userDetails);
        }
      }
    }else if(type == 1){
      switch (index) {
        case 0:
          {
            return Dashboard(jobCategory: categories);
          }
        case 1:
          {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Category List"),
                ),
                body: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: 10,
                itemBuilder: (context, i){
                  if (i.isOdd) return Divider();

                  final index = i ~/ 2;

                  if(index >= _suggestions.length){
                    _suggestions.addAll(generateWordPairs().take(10));
                  }
                  if(index >= _secondSuggestion.length){
                    _secondSuggestion.addAll(generateWordPairs().take(10));
                  }
                  return _buildRow(index, _suggestions[index], _secondSuggestion[index]);
                }
              )
            );
          }
        case 2:
        {
            return UserProfilePage(user: userDetails);
        }
      }
    }
  }

  userNavigation(int type){
    switch(type){
      case 1:{
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
            icon: Icon(Icons.person_pin),
            title: Text('User Profile'),
          ),
        ];
      }
      case 2:{
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
            body: _changeScreen(context, _selectedIndex, type),
            bottomNavigationBar: BottomNavigationBar(
              items: userNavigation(type),
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.blue[800],
              onTap: _onItemTapped,
            ),
          ),
        )
      ]
    );
  }
}
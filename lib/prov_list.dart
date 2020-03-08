import 'package:flutter/material.dart';



class ProvList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Provider List"),
      ),
      body: ListView(
        children: <Widget>[
          Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.album),
                title: Text("name"),
                subtitle: Text("job"),
              ),
              Row(
                children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.star),
                  iconSize: 20.0,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.star),
                  iconSize: 20.0,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.star),
                  iconSize: 20.0,
                ),
              ]
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('HIRE'),
                    onPressed: () { /* ... */ },
                  ),
                ],
              ),
            ],
          ),
        ),
      ])
    );
  }
}
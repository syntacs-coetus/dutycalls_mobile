import 'package:flutter/material.dart';
import 'job_list.dart';
import 'requests.dart';

class Dashboard extends StatelessWidget {

  final Future<List<JobCategory>> jobCategory;
  final int userID;
  Dashboard({this.jobCategory, this.userID});

  createList(BuildContext context, int index, data, int id){
    return new GestureDetector(
        onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context)  =>  JobList(catTitle: data.catTitle, catID: data.id, userID: id)),
            );
        },
        child: Container(
          child: Card(
            color: Colors.blue[900],
            elevation: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text("${data.catTitle}", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category List"),
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: FutureBuilder<List<JobCategory>>(
          future: jobCategory,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List data = snapshot.data;
              return ListView.builder(
                itemCount: data.length,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, i){

                  final index = i ~/ 2;
                  return createList(context, index, data[i], this.userID);
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
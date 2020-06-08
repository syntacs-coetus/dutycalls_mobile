import 'package:flutter/material.dart';
import 'prov_list.dart';
import 'requests.dart';

class JobList extends StatelessWidget {
  final String catTitle;
  final int catID;
  final int userID;

  JobList({this.catTitle, this.catID, this.userID});

  createGrid(BuildContext context, int index, data){
    return new GestureDetector(
      onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context)  =>  new ProvList(jobTitle: data.jobTitle, jobID: data.id, userID: this.userID)),
          );
      },
      child:Card(
        color: Colors.blue[900],
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text("${data.jobTitle}", style: TextStyle(color: Colors.white)),

              subtitle: Text("${data.jobDesc}", style: TextStyle(color: Colors.white, fontSize: 11.0)),
            ),
          ],
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.catTitle),
        backgroundColor: Colors.blue[900],
      ),
      body: FutureBuilder<List<ListedJobs>>(
        future: Query().fetchJobList(catID),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List data = snapshot.data;
            return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: data.length,
                itemBuilder: (context, i){
                  final index = i ~/ 2;
                  return createGrid(context, index, data[i]);
                }
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      )
    );
  }
}
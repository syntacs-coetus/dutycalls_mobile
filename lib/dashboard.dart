import 'package:flutter/material.dart';
import 'job_list.dart';
import 'requests.dart';

class Dashboard extends StatelessWidget {

  final Future<List<JobCategory>> jobCategory;
  final int userID;
  Dashboard({this.jobCategory, this.userID});

  createGrid(BuildContext context, int index, data, int id){
    return new GestureDetector(
        onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context)  =>  JobList(catID: data.id, userID: id)),
            );
        },
        child: Container(
          child: Card(
            color: Colors.lightBlue,
            elevation: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text("${data.catTitle}", style: TextStyle(color: Colors.white)),
                  subtitle: Text("${data.catDesc}", style: TextStyle(color: Colors.white, fontSize: 7.5)),
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
      ),
      body: Center(
        child: FutureBuilder<List<JobCategory>>(
          future: jobCategory,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List data = snapshot.data;
              return GridView.builder(
                itemCount: data.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                   childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 4)
                ),
                itemBuilder: (context, i){

                  final index = i ~/ 2;
                  return createGrid(context, index, data[i], this.userID);
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
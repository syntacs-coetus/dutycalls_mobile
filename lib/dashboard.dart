import 'package:flutter/material.dart';
import 'job_list.dart';
import 'requests.dart';

class Dashboard extends StatelessWidget {

  final Future<List<JobCategory>> jobCategory;

  Dashboard({this.jobCategory});

  createGrid(BuildContext context, int index, data){
    return new GestureDetector(
        onTap: () => (
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context)  =>  JobList(catID: data.id)),
            )
        ),
        child: Container(
          child: Card(
            color: Colors.lightBlue,
            elevation: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: new Center(child: Text("${data.catTitle}", style: TextStyle(color: Colors.white))),
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
                  childAspectRatio: MediaQuery.of(context).size.width/(MediaQuery.of(context).size.height / 5)
                ),
                padding: const EdgeInsets.all(1.0),
                itemBuilder: (context, i){

                  final index = i ~/ 2;
                  return createGrid(context, index, data[i]);
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
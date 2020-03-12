import 'package:flutter/material.dart';
import 'requests.dart';



class ProvList extends StatelessWidget {

  final int jobID;

  ProvList({this.jobID});

  createList(BuildContext context, int index, data, value){
    return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.album),
                title: Text(data.firstname+" "+data.middlename[0]+". "+data.lastname),
                subtitle: Text("job"),
              ),
              Row(
                children: List.generate(5, (index){
                  return Icon(
                    index < value ? Icons.star : Icons.star_border,
                    color: index < value ? Colors.amber : Colors.black,
                  );
                })
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
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Provider List"),
      ),
      body: FutureBuilder<List<Providers>>(
        future: Query().fetchProvidersList(jobID),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List data = snapshot.data;
            return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: data.length,
                itemBuilder: (context, i){
                  final index = i ~/ 2;
                  return createList(context, index, data[i], 3);
                }
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Job Category empty. Contact an Administrator."));
          }
          return Center(child: CircularProgressIndicator());
        }
      )
    );
  }
}
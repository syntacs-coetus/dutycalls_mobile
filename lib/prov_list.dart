import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'requests.dart';



class ProvList extends StatelessWidget {

  final int jobID;
  final int userID;

  ProvList({this.jobID, this.userID});

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

    final description = FormBuilderTextField(
      attribute: "description",
      maxLines: 5,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Write what the Service Provider should do i.e\nClean Bath thub\nScrub Floor\netc.",
        helperText: "Keep it short and simple",
        labelText: "Description"
      ),
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
      decoration:
      InputDecoration(labelText: "Date"),
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
      decoration:
      InputDecoration(
        labelText: "Time"
        ),
      validators: [
        FormBuilderValidators.required(errorText: "Time Required"),
      ],
    );
  createList(BuildContext context, int index, data, value) {
    return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.album),
                title: Text(data.firstname+" "+data.middlename[0]+". "+data.lastname),
                subtitle: __parseSubtitle(context, data.contact, data.latitude, data.longitude),
              ),
              Padding(
                padding: EdgeInsets.only(left: 60.0, top: 20.0),
                child:Row(
                      children: List.generate(5, (index){
                        return Icon(
                          index < value ? Icons.star : Icons.star_border,
                          color: index < value ? Colors.amber : Colors.black,
                        );
                      })
                  ),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('HIRE'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                              title: Text('Hire '+data.firstname),
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
                                                            attribute: "budget",
                                                            maxLines: 1,
                                                            initialValue: (data.fixedrate.toString() != "null") ? data.fixedrate.toString() : "",
                                                            decoration: InputDecoration(
                                                              border: OutlineInputBorder(),
                                                              labelText: "Budget",
                                                              prefixText: "\₱",
                                                              suffixText: "PHP",
                                                              suffixStyle: TextStyle(color: Colors.green)
                                                            ),
                                                            validators: [
                                                              FormBuilderValidators.required(errorText: "Budget Required"),
                                                            ],
                                                          ),
                                                          datesched,
                                                          timesched
                                                        ]
                                                    )
                                                ),
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
                                          if(formKey.currentState.saveAndValidate()){
                                            final Map value = formKey.currentState.value;
                                            final Map details = {
                                              'client_id': this.userID.toString(),
                                              'otj_prov_id': data.providerid.toString(),
                                              'cjr_type': jobID.toString(),
                                              'cjr_description': value['description'].toString(),
                                              'cjr_budget': value['budget'].toString(),
                                              'cjr_sched_date': value['date'].toString(),
                                              'cjr_sched_time': value['time'].toString()
                                            };
                                            Query().hireProvider(context,details);
                                          }
                                      },
                                  ),
                              ],
                          );
                        }
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
  }

  __parseSubtitle(context, String contact, double lat, double long){
    Future<List<Placemark>> placemark = Geolocator().placemarkFromCoordinates(lat, long);
    return FutureBuilder<List<Placemark>>(
      future: placemark,
      builder: (context,  AsyncSnapshot<List<Placemark>> snapshot){
        if(contact == null || contact == ''){
          contact = 'N/A';
        }
        if(snapshot.hasData){
          var data = snapshot.data[0];
          return Text(contact+'\n'+data.locality+', '+data.subAdministrativeArea+', '+data.country, maxLines: 3);
        }else{
          return Text(contact);
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Provider List"),
      ),
      body: FutureBuilder<List<Providers>>(
        future: Query().fetchProvidersList(jobID, userID),
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
            return Center(child: CircularProgressIndicator());
          }else{
            return Center(child: Text("Job Category empty. Contact an Administrator."));
          }
        }
      )
    );
  }
}
import 'dart:async';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

import 'login.dart';

import 'main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

const baseURL = 'http://192.168.43.207:8000/api';

class JobRequested {
  final jobsrequested;

  JobRequested({this.jobsrequested});

  factory JobRequested.fromJson(Map<String, dynamic> json) {
    return JobRequested(jobsrequested: json['totalRequest']);
  }
}

class JobsCompleted {
  final jobscompleted;

  JobsCompleted({this.jobscompleted});

  factory JobsCompleted.fromJson(Map<String, dynamic> json) {
    return JobsCompleted(jobscompleted: json['totalJobs']);
  }
}

class ProviderRating {
  final int rating;

  ProviderRating({this.rating});
  factory ProviderRating.fromJson(Map<String, dynamic> json) {
    return ProviderRating(rating: json['rating']);
  }
}

class JobsByProvider {
  final int id;

  JobsByProvider({this.id});

  factory JobsByProvider.fromJson(Map<String, dynamic> json) {
    return JobsByProvider(id: json['id']);
  }
}

class ProviderJobs {
  final int id;
  final String title;
  final String description;

  ProviderJobs({this.id, this.title, this.description});

  factory ProviderJobs.fromJson(Map<String, dynamic> json) {
    return ProviderJobs(
        id: json['id'],
        title: json['job_title'],
        description: json['job_description']);
  }
}

class ClientRequest {
  final int id;
  final String job;
  final int userid;
  final String fName;
  final String lName;
  final String date;
  final String time;
  final String budget;
  final int status;
  final String description;
  final double longitude;
  final double latitude;
  final double provlat;
  final double provlong;
  final String starttime;
  final int done;
  final int rating;

  ClientRequest(
      {this.id,
      this.job,
      this.userid,
      this.fName,
      this.lName,
      this.date,
      this.time,
      this.budget,
      this.status,
      this.description,
      this.latitude,
      this.longitude,
      this.provlat,
      this.provlong,
      this.starttime,
      this.done,
      this.rating});

  factory ClientRequest.fromJson(Map<String, dynamic> json) {
    return ClientRequest(
      id: json['id'],
      job: json['job_title'],
      userid: json['user_id'],
      fName: json['profile_fname'],
      lName: json['profile_lname'],
      date: json['cjr_sched_date'].toString(),
      time: json['cjr_sched_time'].toString(),
      budget: json['cjr_budget'].toString(),
      status: json['otj_prov_accepts'],
      description: json['cjr_description'],
      latitude: json['cjr_latitude'],
      longitude: json['cjr_longitude'],
      provlat: json['prov_lat'],
      provlong: json['prov_long'],
      starttime: json['otj_starttime'],
      done: json['otj_done'],
      rating: json['otj_prov_output_rating'],
    );
  }
}

class PersonalRequest {
  final int id;
  final int providerid;
  final String job;
  final String fName;
  final String lName;
  final String date;
  final String time;
  final String budget;
  final int status;
  final String description;
  final int done;
  final String code;

  PersonalRequest(
      {this.id,
      this.providerid,
      this.job,
      this.fName,
      this.lName,
      this.date,
      this.time,
      this.budget,
      this.status,
      this.description,
      this.done,
      this.code});

  factory PersonalRequest.fromJson(Map<String, dynamic> json) {
    return PersonalRequest(
        id: json['id'],
        job: json['job_title'],
        providerid: json['user_id'],
        fName: json['profile_fname'],
        lName: json['profile_lname'],
        date: json['cjr_sched_date'].toString(),
        time: json['cjr_sched_time'].toString(),
        budget: json['cjr_budget'].toString(),
        status: json['otj_prov_accepts'],
        description: json['cjr_description'],
        done: json['otj_done'],
        code: json['cjr_code']);
  }
}

class ListedJobs {
  final int id;
  final String jobTitle;
  final String jobDesc;

  ListedJobs({this.id, this.jobTitle, this.jobDesc});

  factory ListedJobs.fromJson(Map<String, dynamic> json) {
    return ListedJobs(
        id: json['id'],
        jobTitle: json['job_title'],
        jobDesc: json['job_description']);
  }
}

class JobCategory {
  final int id;
  final String catTitle;
  final String catDesc;

  JobCategory({this.id, this.catTitle, this.catDesc});

  factory JobCategory.fromJson(Map<String, dynamic> json) {
    return JobCategory(
      id: json['id'],
      catTitle: json['cat_title'],
      catDesc: json['cat_desc'],
    );
  }
}

class UserDetails {
  final int id;
  final String email;
  final String firstname;
  final String middlename;
  final String lastname;
  final String birthdate;
  final int type;
  final int civilstatus;
  final String avatar;
  final bool forhire;
  final int userapproved;

  final dateformat = new DateFormat('F-dd-yyyy');

  UserDetails(
      {this.id,
      this.email,
      this.firstname,
      this.middlename,
      this.lastname,
      this.birthdate,
      this.type,
      this.civilstatus,
      this.avatar,
      this.userapproved,
      this.forhire});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
        id: json['user_id'],
        email: json['user_email'],
        firstname: json['profile_fname'],
        middlename: json['profile_mname'],
        lastname: json['profile_lname'],
        birthdate: json['profile_bdate'],
        type: json['user_type'],
        civilstatus: json['profile_civil_status'],
        avatar: json['profile_avatar'],
        forhire: (json['prov_for_hire'] == 1) ? true : false,
        userapproved: json['user_approved']);
  }
}

class Providers {
  final String firstname;
  final String middlename;
  final String lastname;
  final int providerid;
  final String contact;
  final double latitude;
  final double longitude;
  final double fixedrate;

  Providers(
      {this.providerid,
      this.firstname,
      this.middlename,
      this.lastname,
      this.contact,
      this.latitude,
      this.longitude,
      this.fixedrate});

  factory Providers.fromJson(Map<String, dynamic> json) {
    return Providers(
        providerid: json['provider_id'],
        firstname: json['profile_fname'],
        middlename: json['profile_mname'],
        lastname: json['profile_lname'],
        contact: json['profile_contact_num'],
        latitude: json['prov_lat'],
        longitude: json['prov_long'],
        fixedrate: json['prov_fixed_rate']);
  }
}

class Geolocation {
  providerForHire(BuildContext context, int userID, int type) async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    const url = '$baseURL/accounts/user/forhire';
    final Map<String, dynamic> body = {
      'user_id': userID.toString(),
      'latitude': position.latitude.toString(),
      'longitude': position.longitude.toString()
    };
    final response = await http.post(Uri.encodeFull(url),
        body: body, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  Text(response.body, style: ThemeData().textTheme.subtitle2),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Continue")),
              ],
            );
          });
    }
  }
}

class Query {
  sendReport(
      BuildContext context, int reporterid, int targetid, String reason) async {
    final response = await http.post("$baseURL/provider/sendreport", body: {
      'reported_by': reporterid.toString(),
      'reported': targetid.toString(),
      'reason': reason
    }, headers: {
      "Accept": "application/json"
    });
    if (response.statusCode == 200) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  Text(response.body, style: ThemeData().textTheme.subtitle2),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Continue")),
              ],
            );
          });
    } else {
      throw Exception("Failed to send report");
    }
  }

  updateStars(BuildContext context, int id, int providerid, int stars) async {
    final response = await http.post("$baseURL/provider/updatestars", body: {
      'otj_id': id.toString(),
      'provider_id': providerid.toString(),
      'stars': stars.toString()
    }, headers: {
      "Accept": "application/json"
    });
    if (response.statusCode == 200) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  Text(response.body, style: ThemeData().textTheme.subtitle2),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Continue")),
              ],
            );
          });
    } else {
      throw Exception("Failed to update stars");
    }
  }

  Future<JobRequested> fetchJobsRequested(
      BuildContext context, int userID) async {
    final response = await http.get(
        "$baseURL/request/gettotal/" + userID.toString(),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      return JobRequested.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load Provider Rating");
    }
  }

  Future<JobsCompleted> fetchJobsCompleted(
      BuildContext context, int userID) async {
    final response = await http.get(
        "$baseURL/provider/jobscompleted/" + userID.toString(),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      return JobsCompleted.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load Provider Rating");
    }
  }

  Future<ProviderRating> fetchProviderRating(
      BuildContext context, int userID) async {
    final response = await http.get(
        "$baseURL/provider/fetchrating/" + userID.toString(),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      return ProviderRating.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load Provider Rating");
    }
  }

  updateProviderJob(BuildContext context, int userID, int jobid) async {
    final response = await http.post('$baseURL/provider/updatejob',
        body: {"userID": userID.toString(), "jobID": jobid.toString()},
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  Text(response.body, style: ThemeData().textTheme.bodyText2),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load Job List');
    }
  }

  Future<JobsByProvider> fetchProviderJob(int userID, int jobid) async {
    final response = await http.get('$baseURL/provider/job/$userID/$jobid',
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return JobsByProvider.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load Job List');
    }
  }

  List<ProviderJobs> parseProviderJobs(String responsebody) {
    final parsed = json.decode(responsebody).cast<Map<String, dynamic>>();
    return parsed
        .map<ProviderJobs>((json) => ProviderJobs.fromJson(json))
        .toList();
  }

  Future<List<ProviderJobs>> fetchAllJobs() async {
    final response = await http
        .get('$baseURL/provider/jobs', headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return parseProviderJobs(response.body);
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load Job List');
    }
  }

  finishRequest(BuildContext context, int userid, int id, String code) async {
    final url = "$baseURL/onthejob/stoprequest";
    final response = await http.post(Uri.encodeFull(url), body: {
      'req_id': id.toString(),
      'user_id': userid.toString(),
      'code': code
    }, headers: {
      "Accept": "application/json"
    });
    if (response.statusCode == 200) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  Text(response.body, style: ThemeData().textTheme.bodyText2),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  startRequest(BuildContext context, int userid, int id) async {
    final url = "$baseURL/onthejob/startrequest";
    final response = await http.post(Uri.encodeFull(url),
        body: {'req_id': id.toString(), 'user_id': userid.toString()},
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  Text(response.body, style: ThemeData().textTheme.bodyText2),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  changeRequestStatus(
      BuildContext context, int id, int userid, int status) async {
    final url = "$baseURL/onthejob/requeststatus";
    final response = await http.post(Uri.encodeFull(url), body: {
      'req_id': id.toString(),
      'user_id': userid.toString(),
      'status': status.toString()
    }, headers: {
      "Accept": "application/json"
    });
    if (response.statusCode == 200) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  Text(response.body, style: ThemeData().textTheme.bodyText2),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception(response.body);
    }
  }

  List<ClientRequest> parseClientRequest(String responsebody) {
    final parsed = json.decode(responsebody).cast<Map<String, dynamic>>();
    return parsed
        .map<ClientRequest>((json) => ClientRequest.fromJson(json))
        .toList();
  }

  Future<List<ClientRequest>> fetchClientRequest(int userid) async {
    final response = await http.get('$baseURL/provider/request/$userid',
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return parseClientRequest(response.body);
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load Job List');
    }
  }

  List<PersonalRequest> parsePersonalRequest(String responsebody) {
    final parsed = json.decode(responsebody).cast<Map<String, dynamic>>();
    return parsed
        .map<PersonalRequest>((json) => PersonalRequest.fromJson(json))
        .toList();
  }

  Future<List<PersonalRequest>> fetchPersonalRequest(int userid) async {
    final response = await http.get('$baseURL/client/requests/$userid',
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return parsePersonalRequest(response.body);
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load Job List');
    }
  }

  applyForProvider(BuildContext context, int id, String reason, PickedFile nbi,
      PickedFile barangay) async {
    const url = '$baseURL/accounts/user/apply';
    final Map<String, String> details = {
      'user_id': id.toString(),
      'user_reason': reason
    };
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(details);
    request.files.add(http.MultipartFile.fromBytes(
        'user_nbi', await nbi.readAsBytes(),
        filename: nbi.path.split("/").last));
    request.files.add(http.MultipartFile.fromBytes(
        'user_barangay', await barangay.readAsBytes(),
        filename: barangay.path.split("/").last));
    final response = await request.send();
    final stream = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Await for confirmation"),
                content: Text(stream),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Okay"),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));
    } else {
      return showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Unprocessed"),
                content: Text(stream),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Okay"),
                    onPressed: () => Navigator.pop(context, 'Okay'),
                  )
                ],
              ));
    }
  }

  hireProvider(BuildContext context, Map details) async {
    const url = '$baseURL/accounts/user/hire';
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final Map<String, String> body = {
      'client_id': details['client_id'].toString(),
      'otj_prov_id': details['otj_prov_id'].toString(),
      'cjr_type': details['cjr_type'].toString(),
      'cjr_description': details['cjr_description'].toString(),
      'cjr_budget': details['cjr_budget'].toString(),
      'cjr_sched_date': details['cjr_sched_date'].toString(),
      'cjr_sched_time': details['cjr_sched_time'].toString(),
      'cjr_latitude': position.latitude.toString(),
      'cjr_longitude': position.longitude.toString()
    };
    final response = await http.post(Uri.encodeFull(url),
        body: body, headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      Navigator.pop(context);
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: new Text("Your request has been delivered"),
              ),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text("Continue"),
                ),
              ],
            );
          });
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: new Text("Something went wrong! Try again"),
              ),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text("Continue"),
                ),
              ],
            );
          });
    }
  }

  logoutUser(BuildContext context) {
    Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new LoginView()));
  }

  List<Providers> parseProvidersList(String responsebody) {
    final parsed = json.decode(responsebody).cast<Map<String, dynamic>>();
    return parsed.map<Providers>((json) => Providers.fromJson(json)).toList();
  }

  Future<List<Providers>> fetchProvidersList(int id, int userid) async {
    final response = await http.get('$baseURL/jobtype/providers/$id/$userid',
        headers: {"Accept": "application/json"});
    // print(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return parseProvidersList(response.body);
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load Job List');
    }
  }

  loginUser(BuildContext context, Map user) async {
    final url = '$baseURL/accounts/user/login';
    final Map<String, String> body = {
      'user_email': user['email'].toString(),
      'user_password': user['password'].toString()
    };
    final response = await http.post(Uri.encodeFull(url),
        body: body, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      if (data['success'] == false) {
        switch (data['type']) {
          case 1:
            {
              return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SingleChildScrollView(
                        child:
                            new Text("Incorrect Login Credentials, try again."),
                      ),
                      actions: <Widget>[
                        new FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: new Text("Continue"),
                        ),
                      ],
                    );
                  });
            }
          case 2:
            {
              return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SingleChildScrollView(
                        child: new Text(
                            "Your Email Address is not yet confirmed."),
                      ),
                      actions: <Widget>[
                        new FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: new Text("Continue"),
                        ),
                      ],
                    );
                  });
            }
          case 3:
            {
              return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SingleChildScrollView(
                        child: new Text(
                            "Your account is still being reviewed, please wait for 2 to 3 working days for admins to verify your account."),
                      ),
                      actions: <Widget>[
                        new FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: new Text("Continue"),
                        ),
                      ],
                    );
                  });
            }
          case 4:
            {
              return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SingleChildScrollView(
                        child: new Text(
                            "Email does not exists.\nPlease try typing your email again.",
                            maxLines: 2),
                      ),
                      actions: <Widget>[
                        new FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: new Text("Continue"),
                        ),
                      ],
                    );
                  });
            }
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MyHomePage(id: data['id'], type: data['user_type'])),
        );
      }
    }
  }

  registerUser(BuildContext context, Map user, PickedFile avatar, PickedFile vf,
      PickedFile vb) async {
    const url = '$baseURL/accounts/user/store';
    final Map<String, String> body = {
      "user_email": user['user_email'].toString(),
      "user_password": user['user_password'].toString(),
      'profile_fname': user['profile_fname'].toString(),
      'profile_mname': user['profile_mname'].toString(),
      'profile_lname': user['profile_lname'].toString(),
      'profile_gender': user['profile_gender'].toString(),
      'profile_civil_status': user['profile_civil_status'].toString(),
      'profile_bdate': user['profile_bdate'].toString()
    };
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    request.files.add(http.MultipartFile.fromBytes(
        'profile_avatar', await avatar.readAsBytes(),
        filename: avatar.path.split("/").last));
    request.files.add(http.MultipartFile.fromBytes(
        'user_id_valid_front', await vf.readAsBytes(),
        filename: vf.path.split("/").last));
    request.files.add(http.MultipartFile.fromBytes(
        'user_id_valid_back', await vb.readAsBytes(),
        filename: vb.path.split("/").last));
    final response = await request.send();
    if (response.statusCode == 200) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: new Text(
                    "You have successfully registered. You may have to confirm your email first before logging in."),
              ),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new LoginView()));
                  },
                  child: new Text("Continue"),
                ),
              ],
            );
          });
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: new Text(
                    "Something wrong has happened and you cannot be registered at the moment."),
              ),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  },
                  child: new Text("Continue"),
                ),
              ],
            );
          });
    }
  }

  List<ListedJobs> parseJobList(String responsebody) {
    final parsed = json.decode(responsebody).cast<Map<String, dynamic>>();
    return parsed.map<ListedJobs>((json) => ListedJobs.fromJson(json)).toList();
  }

  Future<List<ListedJobs>> fetchJobList(int id) async {
    final response = await http
        .get('$baseURL/jobtype/$id', headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return parseJobList(response.body);
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load Job List');
    }
  }

  Future<UserDetails> fetchUser(int id) async {
    final response = await http.get('$baseURL/accounts/user/$id',
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return UserDetails.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load User Details');
    }
  }

  List<JobCategory> parseJobCategory(String responsebody) {
    final parsed = json.decode(responsebody).cast<Map<String, dynamic>>();
    return parsed
        .map<JobCategory>((json) => JobCategory.fromJson(json))
        .toList();
  }

  Future<List<JobCategory>> fetchJobCategory() async {
    final response = await http
        .get('$baseURL/jobcategory', headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return parseJobCategory(response.body);
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load Job Category');
    }
  }
}

class File {}

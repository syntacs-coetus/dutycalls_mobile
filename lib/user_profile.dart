import 'package:duty_calls/settings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'requests.dart';

class UserProfilePage extends StatefulWidget {
  final int user_id;
  final int type;
  UserProfilePage({this.user_id, this.type});

  _UserProfilePage createState() => _UserProfilePage(user_id: this.user_id, type: this.type);
}

class _UserProfilePage extends State<UserProfilePage>{
  final int user_id;
  final int type;
  _UserProfilePage({this.user_id, this.type});
  PickedFile nbi;
  PickedFile barangay;
  String _reason;
  final _picker = ImagePicker();

  getNBI() async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      this.nbi = image;
    });
  }

  getBarangay() async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      this.barangay = image;
    });
  }

  // final String _bio =
  //     "\"Hi, I am a Freelance developer working for hourly basis. If you wants to contact me to build your product leave a message.\"";

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.6,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/app/default_cover.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImage(avatar) {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: (avatar != null)
                ? AssetImage('assets/users/$avatar.jpg')
                : AssetImage('assets/users/default-profile.jpg'),
            fit: BoxFit.contain,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 10.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFullName(name) {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.blue,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      name,
      style: _nameTextStyle,
    );
  }

  Widget _buildStatus(BuildContext context, int type) {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.blue,
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      (type == 1) ? "Client" : "Service Provider",
      style: _nameTextStyle,
    );
  }

  Widget _buildStatItem(String label, int count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.blue,
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.blue,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  Widget _buildStatContainer(int type) {
    if (type == 1) {
      return Container(
        height: 60.0,
        margin: EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
          color: Colors.amber,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildStatItem("Job Requested", 125),
          ],
        ),
      );
    } else {
      return Container(
        height: 60.0,
        margin: EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
          color: Colors.amber,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildStatItem("Job Requested", 100),
            _buildStatItem("Client Ratings", 5),
            _buildStatItem("Time Ratings", 5),
          ],
        ),
      );
    }
  }

  // Widget _buildBio(BuildContext context) {
  //   TextStyle bioTextStyle = TextStyle(
  //     fontFamily: 'Spectral',
  //     fontWeight: FontWeight.w400,//try changing weight to w500 if not thin
  //     fontStyle: FontStyle.italic,
  //     color: Color(0xFF799497),
  //     fontSize: 16.0,
  //   );

  //   return Container(
  //     color: Theme.of(context).scaffoldBackgroundColor,
  //     padding: EdgeInsets.all(8.0),
  //     child: Text(
  //       _bio,
  //       textAlign: TextAlign.center,
  //       style: bioTextStyle,
  //     ),
  //   );
  // }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.blue,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  // Widget _buildGetInTouch(BuildContext context, email, firstname) {
  //   return Container(
  //     color: Theme.of(context).scaffoldBackgroundColor,
  //     padding: EdgeInsets.only(top: 8.0),
  //     child: Text(
  //       "Get in Touch with $firstname\n, @$email",
  //       maxLines: 2,
  //       style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
  //     ),
  //   );
  // }

  Widget _switchButton(BuildContext context, int userID, int type, bool hired, bool working, int user_approved) {
    switch (type) {
      case 1:
        {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: 
                  (user_approved == 2) ? 
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
				                  title: const Text("Application pending"),
                          content: const Text("Your application is still being processed. It might take 24 to 48 hours before this process has been finished. Thank you for your patients"),
                          actions: <Widget>[
                            new FlatButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: new Text("Close"),
                              )
                          ],
                        );
                      }
                      );
                    },
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          "Your Application is still on pending",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  )
                  :
                  InkWell(
                    onTap: () => 
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
				                  title: const Text("Becoming a Service Provider"),
                            content: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Tell us why we should accept you as a service provider.',
                                      helperText: 'keep it short and precise.',
                                      labelText: 'Why should we accept you?',
                                    ),
                                    maxLines: 2,
                                    onSaved: (String value) => 
                                      this._reason = value
                                    ,
                                  ),
                                  SizedBox(height: 10.0),
                                  ListTile(title: Text("NBI Clearance")),
                                  GestureDetector(
                                    onTap: () => getNBI(),
                                    child: this.nbi == null ? 
                                    Image.asset(
                                      "assets/app/nbi.png",
                                      scale: 0.5
                                    )
                                    :
                                    Image.asset(
                                      this.nbi.path,
                                      scale: 0.5
                                    ),
                                  ),
                                  Divider(),
                                  ListTile(title: Text("NBI Clearance")),
                                  GestureDetector(
                                    onTap: () => getBarangay(),
                                    child: this.barangay == null ?
                                    Image.asset(
                                      "assets/app/bcl.jpg",
                                      scale: 0.5
                                    )
                                    :
                                    Image.asset(
                                      this.barangay.path,
                                      scale: 0.5
                                    )
                                  )
                                ],
                              ) 
                            ),
                            actions: <Widget>[
                              new FlatButton(
                                onPressed: () =>
                                  Query().applyForProvider(context, userID, this._reason, this.nbi, this.barangay)
                                ,
                                child: new Text("Send Application"),
                              ),
                            ],
                          );
                        }),
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          "Become a Service Provider",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                )
              ],
            ),
          );
        }
      case 2:
        {
          if (working != true) {
            if (hired == true) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () => Geolocation()
                            .providerForHire(context, userID, type),
                        child: Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                          ),
                          child: Center(
                            child: Text(
                              "Resign",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () => Geolocation()
                            .providerForHire(context, userID, type),
                        child: Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: Center(
                            child: Text(
                              "For Hire",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () => {},
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: Text(
                            "Working...",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
    }
    return null;
  }

  Widget _settingsButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)  =>  UserSettings(userID: this.user_id, userType: this.type))
                )
              },
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                child: Center(
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () => Query().logoutUser(context),
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                child: Center(
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: FutureBuilder<UserDetails>(
            future: Query().fetchUser(user_id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: <Widget>[
                    _buildCoverImage(screenSize),
                    SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: screenSize.height / 6.4),
                            _buildProfileImage(snapshot.data.avatar),
                            _buildFullName(snapshot.data.firstname +
                                " " +
                                snapshot.data.middlename[0] +
                                ". " +
                                snapshot.data.lastname),
                            _buildStatus(context, snapshot.data.type),
                            _buildStatContainer(snapshot.data.type),
                            // _buildBio(context),
                            _buildSeparator(screenSize),
                            SizedBox(height: 10.0),
                            // _buildGetInTouch(context, snapshot.data.email, snapshot.data.firstname),
                            SizedBox(height: 6.0),
                            _switchButton(context, user_id, snapshot.data.type,
                                snapshot.data.forhire, false, snapshot.data.user_approved),
                            _settingsButton(context),
                            _logoutButton(context)
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              }
              return CircularProgressIndicator();
            }));
  }
}

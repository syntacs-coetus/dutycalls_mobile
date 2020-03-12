import 'package:flutter/material.dart';
import 'requests.dart';

class UserProfilePage extends StatelessWidget {
  final Future<UserDetails> user;
  UserProfilePage({this.user});
  final String _bio =
      "\"Hi, I am a Freelance developer working for hourly basis. If you wants to contact me to build your product leave a message.\"";

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
            image: (avatar != null) ? AssetImage('assets/users/$avatar.jpg') : AssetImage('assets/users/default-profile.jpg'),
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        (type == 1) ? "Client" : "Service Provider",
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.blue,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
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
    if(type == 1){
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
    }else{
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

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400,//try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Text(
        _bio,
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.blue,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Widget _buildGetInTouch(BuildContext context, email, firstname) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        "Get in Touch with $firstname, @$email",
        style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
      ),
    );
  }

  Widget _switchButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () => print("followed"),
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
        future: user,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return Stack(
              children: <Widget>[
                _buildCoverImage(screenSize),
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: screenSize.height / 6.4),
                        _buildProfileImage(snapshot.data.avatar),
                        _buildFullName(snapshot.data.firstname+" "+snapshot.data.middlename[0]+". "+snapshot.data.lastname),
                        _buildStatus(context, snapshot.data.type),
                        _buildStatContainer(snapshot.data.type),
                        _buildBio(context),
                        _buildSeparator(screenSize),
                        SizedBox(height: 10.0),
                        _buildGetInTouch(context, snapshot.data.email, snapshot.data.firstname),
                        SizedBox(height: 6.0),
                        (snapshot.data.type == 1) ? _switchButton() : Row(),
                        _logoutButton(context)
                      ],
                    ),
                  ),
                ),
              ],
            );
          }else if(snapshot.hasError){
            return Center(
              child: Text("${snapshot.error}")
            );
          }
          return CircularProgressIndicator();
        }
      )
    );
  }
}
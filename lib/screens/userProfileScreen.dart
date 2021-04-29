import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final username = 'Gon Freices';
  final casesNum = 999;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
            child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.teal[200], Colors.teal[800]])),
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 50, 16, 0),
            child: ListView(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.account_circle,
                      size: 50,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        '$username',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(
                      height: 30,
                      color: Colors.black,
                    ),
                    SizedBox(height: 20),
                    TextButton.icon(
                        onPressed: () {},
                        style: TextButton.styleFrom(primary: Colors.white),
                        icon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        label: Text(
                          'My Cases',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        )),
                    TextButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/reportedScreen');
                          // push according to user ID
                        },
                        style: TextButton.styleFrom(primary: Colors.white),
                        icon: Icon(
                          Icons.archive,
                          color: Colors.black,
                        ),
                        label: Text(
                          'All Reported Cases',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        )),
                    TextButton.icon(
                        onPressed: () {},
                        style: TextButton.styleFrom(primary: Colors.white),
                        icon: Icon(
                          Icons.save,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Saved POIs for volunteering',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        )),
                  ],
                ),
                TextButton(
                    onPressed: () {
                      // another page to change username and password
                    },
                    child: Text(
                      'Edit profile',
                      style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
        )));
  }
}

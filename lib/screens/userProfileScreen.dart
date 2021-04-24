import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
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
          color: Colors.grey[200],
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 50, 16, 0),
            child: ListView(
              children: [
                Center(
                  // add change avatar functionality *****
                  child: CircleAvatar(
                    radius: 30,
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
                            color: Colors.orange[800]),
                      ),
                    ),
                    Divider(
                      height: 30,
                      color: Colors.black,
                    ),
                    SizedBox(height: 20),
                    TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        label: Text(
                          'My Case/s',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        )),
                    TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.archive,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Reported Cases',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        )),
                    TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.save,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Saved POI',
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

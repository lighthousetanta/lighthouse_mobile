import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/auth.dart';
import '../screens/userReportedScreen.dart';
import './reportedScreen.dart';

class UserProfile extends StatelessWidget {
  static const routeName = '/userProfile';

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<Auth>(context, listen: false).getuser;
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
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage(
                          'assets/images/appImages/johndoe.png',
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        '${user.username}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    InkWell(
                      child: ListTile(
                        leading: Icon(Icons.search),
                        title: Text(
                          "My Reported Cases",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed(
                              UserReportedScreen.routeName);
                        },
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.report),
                      title: Text(
                        "All Reported Cases",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(ReportedScreen.routeName);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.check),
                      title: Text(
                        "Marked People",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      onTap: () {},
                    ),
                    Divider(),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        // another page to change username and password
                      },
                      style: ElevatedButton.styleFrom(),
                      child: Text(
                        'Edit profile',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
          ),
        )));
  }
}

import 'package:flutter/material.dart';
import '../screens/userProfileScreen.dart';
import '../screens/reportedScreen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friend'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Feed'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ReportedScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.of(context).pushNamed(UserProfile.routeName);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}

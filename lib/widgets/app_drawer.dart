import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_lighthouse/providers/auth.dart';
import 'package:the_lighthouse/screens/userReportedScreen.dart';
import '../screens/userProfileScreen.dart';
import '../screens/reportedScreen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Puplic Feed'),
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
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(UserProfile.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.report),
            title: Text('Reported Cases'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(UserReportedScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}

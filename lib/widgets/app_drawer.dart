import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_lighthouse/providers/auth.dart';
import 'package:the_lighthouse/providers/poi_provider.dart';
import 'package:the_lighthouse/screens/resultScreen.dart';
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
          Divider(),
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
              Navigator.of(context).pushNamed(UserReportedScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.restore_outlined),
            title: Text('Last Search Results'),
            onTap: () async {
              try {
                // Navigator.of(context).pop();
                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (c) {
                      return WillPopScope(
                          onWillPop: () async => false,
                          child: LoadingDialogue());
                    });
                await Provider.of<PoiProvider>(context, listen: false)
                    .getSearchResults();
                Navigator.of(context).pop(); // pop the dialogue
                Navigator.of(context)
                    .pop(); // pop the drawer - back button show exit dialoge instead of poping
                Navigator.of(context).pushNamed(ResultScreen.routeName);
              } catch (error) {
                print(error);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Not Available")));
              }
            },
          ),
          Divider(),
          Expanded(child: SizedBox()),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              bool logout = await logoutAlert(context);
              if (logout == true) {
                Navigator.of(context).pop();
                Provider.of<Auth>(context, listen: false).logout();
              }
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}

class LoadingDialogue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white.withOpacity(0.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                child: Container(
                    child: CircularProgressIndicator(strokeWidth: 3),
                    width: 32,
                    height: 32),
                padding: EdgeInsets.only(bottom: 16)),
            Padding(
                child: Text(
                  'Please wait …',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.only(bottom: 4)),
          ],
        ),
      ),
    );
  }
}

Future<bool> logoutAlert(BuildContext ctx) async {
  return await showDialog(
      context: ctx,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Attention'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(fontSize: 15),
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text(
                  'No',
                  style: TextStyle(fontSize: 15),
                ))
          ],
          content: Text("Do you want to Logout?"),
        );
      });
}

import 'package:flutter/material.dart';
import 'package:the_lighthouse/screens/editPoiProfile.dart';
import 'package:the_lighthouse/screens/poiProfileScreen.dart';
import 'package:the_lighthouse/screens/reportedScreen.dart';
import 'package:the_lighthouse/screens/loginScreen.dart';
import 'package:the_lighthouse/screens/userProfileScreen.dart';
import 'package:the_lighthouse/screens/addPersonScreen.dart';
import 'package:the_lighthouse/screens/resultScreen.dart';
import 'package:the_lighthouse/screens/searchScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Lighthouse',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
                fontWeight: FontWeight.bold),
            headline5: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            headline4: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            headline3: TextStyle(
                fontSize: 22,
                // fontWeight: FontWeight.bold,
                color: Colors.white)),

        //   visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) =>Login(),
        '/loginScreen': (context) => Login(),
        '/UserProfileScreen': (context) => UserProfile(),
        '/searchScreen': (context) => SearchScreen(),
        '/addPersonScreen': (context) => AddPerson(),
        '/resultScreen': (context) =>
            ResultScreen(), // todo: for multiple faces
        '/reportedScreen': (context) => Reported(),
        '/poiProfileScreen': (context) => PoiProfile(),
        'editPoiProfile': (context) => EditPoi()
      },
      initialRoute: '/UserProfileScreen',
    );
  }
}

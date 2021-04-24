import 'package:flutter/material.dart';
import 'package:the_lighthouse/screens/poiProfileScreen.dart';
import 'package:the_lighthouse/screens/reportedScreen.dart';
import 'package:the_lighthouse/screens/loginScreen.dart';
import 'package:the_lighthouse/screens/userProfileScreen.dart';
import 'package:the_lighthouse/screens/addPersonScreen.dart';
import 'package:the_lighthouse/screens/resultScreen.dart';
import 'package:the_lighthouse/screens/searchScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Lighthouse',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
        '/': (context) => Login(),
        '/loginScreen': null,
        '/profileScreen': (context) => Profile(),
        '/searchScreen': (context) => SearchScreen(),
        '/addPersonScreen': (context) => AddPerson(),
        '/resultScreen': (context) => ResultScreen(),
        '/reportedScreen': (context) => Reported(),
        '/poiProfileScreen': (context) => PoiProfile()
      },
      initialRoute: '/reportedScreen',
    );
  }
}

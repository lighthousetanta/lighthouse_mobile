import 'package:flutter/material.dart';
import 'package:the_lighthouse/screens/loginScreen.dart';
import 'package:the_lighthouse/screens/profileScreen.dart';
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
        //   visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Login(),
        '/loginScreen': null,
        '/profileScreen': (context) => Profile(),
        '/searchScreen': (context) => SearchScreen(),
        '/addPersonScreen': (context) => AddPerson(),
        '/resultScreen': (context) => ResultScreen()
      },
      initialRoute: '/addPersonScreen',
    );
  }
}

import 'package:flutter/material.dart';
import 'package:the_lighthouse/screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Lighthouse',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Login(),
        '/login': null,
        '/profile': null,
        '/searchImage': null,
        '/addPerson': null
      },
      initialRoute: '/',
    );
  }
}
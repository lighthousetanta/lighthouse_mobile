import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_lighthouse/screens/editPoiProfile.dart';
import 'package:the_lighthouse/screens/poiProfileScreen.dart';
import 'package:the_lighthouse/screens/reportedScreen.dart';
import 'package:the_lighthouse/screens/loginScreen.dart';
import 'package:the_lighthouse/screens/userProfileScreen.dart';
import 'package:the_lighthouse/screens/addPersonScreen.dart';
import 'package:the_lighthouse/screens/resultScreen.dart';
import 'package:the_lighthouse/screens/searchScreen.dart';
import 'package:the_lighthouse/screens/auth_screen.dart';

import 'providers/poi_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => PoiProvider()),
      ],
      child: MaterialApp(
        title: 'The Lighthouse',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              headline5: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              headline4: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              headline3: TextStyle(fontSize: 22, color: Colors.white)),

            visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          AuthScreen.routeName: (context) => AuthScreen(),
          Login.routeName: (context) => Login(),
          UserProfile.routeName: (context) => UserProfile(),
          SearchScreen.routeName: (context) => SearchScreen(),
          AddPerson.routeName: (context) => AddPerson(),
          ResultScreen.routeName: (context) => ResultScreen(),
          ReportedScreen.routeName: (context) => ReportedScreen(),
          PoiProfile.routeName: (context) => PoiProfile(),
          EditPoi.routeName: (context) => EditPoi(),
        },
        home: ReportedScreen(),
      ),
    );
  }
}

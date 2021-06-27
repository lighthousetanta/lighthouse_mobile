import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/poi_provider.dart';
import './providers/auth.dart';
import './helpers/custom_route.dart';
import './screens/auth_screen.dart';
import './screens/waitingScreen.dart';
import './screens/userReportedScreen.dart';
import './screens/editPoiProfile.dart';
import './screens/poiProfileScreen.dart';
import './screens/poiReviewProfile.dart';
import './screens/reportedScreen.dart';
import './screens/loginScreen.dart';
import './screens/userProfileScreen.dart';
import './screens/addPersonScreen.dart';
import './screens/resultScreen.dart';
import './screens/searchScreen.dart';
import 'screens/reporterDetailsScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, PoiProvider>(
            //creating an instance of the PoiProvider
            create: (ctx) => PoiProvider([], []),
            update: (ctx, auth, previousPoiState) => PoiProvider(
                auth.getCookies,
                // prevent state loss after Auth Provider changes or hot reload
                previousPoiState == null ? [] : previousPoiState.getPersons)),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'The Lighthouse',
          theme: ThemeData(
              primarySwatch: Colors.teal,
              textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                      // Card Info Font
                      fontFamily: 'Raleway',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  headline5: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  headline3: TextStyle(
                      fontSize: 22, color: Colors.amber), // details titles font
                  headline4: TextStyle(
                      // details font
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              })),
          debugShowCheckedModeBanner: false,
          // home: auth.isAuthed ? ReportedScreen() : AuthScreen(),
          home: auth.isAuthed
              ? ReportedScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, futureSnapshot) =>
                      //wait until the tryAutoLogin notify listeners if the token is valid
                      futureSnapshot.connectionState == ConnectionState.waiting
                          ? WaitingScreen()
                          : AuthScreen()),
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
            PoiReviewProfile.routeName: (context) => PoiReviewProfile(),
            UserReportedScreen.routeName: (context) => UserReportedScreen(),
            ReporterDetailsScreen.routeName: (context) =>
                ReporterDetailsScreen()
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:the_lighthouse/models/poi.dart';
import 'package:the_lighthouse/screens/reporterDetailsScreen.dart';

class PoiDetailsSheet extends StatelessWidget {
  final Poi poi;
  PoiDetailsSheet({this.poi});
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.80,
      builder: (context, controller) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(125, 187, 185, 1),
                  Color.fromRGBO(228, 202, 174, 1),
                ])),
        padding: EdgeInsets.all(20),
        child: ListView(
          controller: controller,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: FittedBox(
                    child: Text(
                      poi.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Last Known Location ',
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(height: 6),
            Text(
              'Cairo',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 17),
            Text(
              'Reported By',
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(height: 6),
            Text(
              poi.reporter.username,
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              width: 30,
            ),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(ReporterDetailsScreen.routeName,
                    arguments: poi.reporter); // ** pass the reporter ID here **
              },
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: Flexible(
                child: Text(
                  'Reporter Profile',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

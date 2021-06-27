import 'package:flutter/material.dart';

class ReporterDetailsScreen extends StatelessWidget {
  static const routeName = '/reporterDetailsScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reporter Details'),
      ),
      body: Container(
        color: Color.fromRGBO(100, 200, 200, 0.5),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
              child: CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage(
                  'assets/images/appImages/johndoe.png',
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color.fromRGBO(100, 200, 200, 1),
                        Color.fromRGBO(76, 161, 175, 1)
                      ]),
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: Text(
                              'MOHAMED YAHIA EID',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Raleway',
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
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
                      SizedBox(
                        height: 25,
                      ),
                      Text('Phone Number',
                          style: Theme.of(context).textTheme.headline3),
                      SizedBox(height: 6),
                      Text(
                        '0107071776',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      SizedBox(
                        height: 17,
                      ),
                      Text('Address',
                          style: Theme.of(context).textTheme.headline3),
                      SizedBox(
                        height: 6,
                      ),
                      FittedBox(
                        child: Text(
                          'Nasr city, Cairo',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

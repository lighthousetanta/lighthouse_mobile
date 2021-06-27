import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:the_lighthouse/screens/reporterDetailsScreen.dart';
import '../models/poi.dart';
import '../providers/poi_provider.dart';

class PoiReviewProfile extends StatelessWidget {
  static const routeName = '/poiReviewProfile';

  @override
  Widget build(BuildContext context) {
    final poiID = ModalRoute.of(context).settings.arguments as int;
    final poiData = Provider.of<PoiProvider>(context);
    Poi poi = poiData.getById(poiID);
    return Scaffold(
      appBar: AppBar(
        title: Text("${poi.name.split(' ')[0]}'s Profile"),
      ),
      body: Container(
        color: Colors.lightBlue[100],
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Hero(
              tag: poi.id,
              child: InteractiveViewer(
                child: Container(
                    height: 300,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: poi.image,
                      fit: BoxFit.contain,
                    )),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color.fromRGBO(100, 200, 200, 1),
                            Color.fromRGBO(76, 161, 175, 1)
                          ])),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Clark Kent',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(ReporterDetailsScreen.routeName);
                              },
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)))),
                              icon: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              label: Flexible(
                                child: Text(
                                  'Reporter Profile',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                        ],
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

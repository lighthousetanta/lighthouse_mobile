import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../screens/reporterDetailsScreen.dart';
import '../widgets/poi_details_Sheet.dart';
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
        color: Color.fromRGBO(100, 200, 200, 0.5),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 2),
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
            SizedBox(height: 2),
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
                            Color.fromRGBO(169, 196, 94, 1),
                            Color.fromRGBO(0, 170, 170, 1)
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
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(ReporterDetailsScreen.routeName);
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 2,
                                // primary: Color.fromRGBO(76, 144, 175, 1),
                                padding: EdgeInsets.all(10),
                                side: BorderSide(color: Colors.white),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
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
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
            Divider(
              height: 0,
              thickness: 1,
              color: Colors.white,
            ),
            Container(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      // primary: Color.fromRGBO(76, 144, 175, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  icon: Icon(Icons.more_horiz, color: Colors.white),
                  label: Text('More Details',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  onPressed: () async {
                    await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return PoiDetailsSheet(poi: poi);
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

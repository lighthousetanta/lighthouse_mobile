import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/poi_provider.dart';
import '../models/poi.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as spinKit;
import '../screens/poiProfileScreen.dart';
import '../screens/poiReviewProfile.dart';

class PoiCard extends StatelessWidget {
  final Poi poi;
  PoiCard(this.poi);
  @override
  Widget build(BuildContext context) {
    final List<Poi> reported =
        Provider.of<PoiProvider>(context, listen: false).getUserReported;
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: () {
          bool isUserReported = false;
          for (Poi x in reported) {
            if (x.id == poi.id) {
              isUserReported = true;
              break;
            }
          }

          isUserReported
              ? Navigator.pushNamed(context, PoiProfile.routeName,
                  arguments: poi.id)
              : Navigator.pushNamed(context, PoiReviewProfile.routeName,
                  arguments: poi.id);
        },
        child: Row(
          children: [
            Container(
                height: 200,
                width: 200,
                child: Hero(
                  tag: poi.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: CachedNetworkImage(
                        imageUrl: poi.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => spinKit.SpinKitRing(
                              color: Colors.teal[200],
                              size: 50,
                              lineWidth: 2,
                            )),
                  ),
                )),
            Container(
              height: 204,
              padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 190,
                    child: Text(
                      poi.name,
                      style: Theme.of(context).textTheme.headline6,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text('Age',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  Text(
                    '12', // persons[idx].age.toString()
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 15),
                  Text('Last known location',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  Text(
                    'Cairo', //persons[idx].address
                    style: Theme.of(context).textTheme.headline6,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

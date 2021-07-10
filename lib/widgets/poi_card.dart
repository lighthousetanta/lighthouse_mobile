import 'package:flutter/material.dart';
import '../models/poi.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as spinKit;
import '../screens/poiProfileScreen.dart';

class PoiCard extends StatelessWidget {
  final Poi poi;
  PoiCard(this.poi);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, PoiProfile.routeName, arguments: poi.id);
        },
        child: Row(
          children: [
            Flexible(
              child: Container(
                  height: 200,
                  width: 200,
                  child: Hero(
                    tag: poi.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                          imageUrl: poi.image,
                          errorWidget: (ctx, _, s) => Image.asset(
                              'assets/images/appImages/johndoe.png'),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => spinKit.SpinKitRing(
                                color: Colors.teal[200],
                                size: 50,
                                lineWidth: 2,
                              )),
                    ),
                  )),
            ),
            Flexible(
              child: Container(
                height: 204,
                padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: FittedBox(
                        child: Text(
                          poi.name,
                          style: Theme.of(context).textTheme.headline6,
                          softWrap: true,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Flexible(
                      child: Text('Age',
                          style: TextStyle(
                            fontSize: 16,
                          )),
                    ),
                    FittedBox(
                      child: Text(
                        '12', // persons[idx].age.toString()
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    SizedBox(height: 15),
                    Flexible(
                      child: FittedBox(
                        child: Text('Last known location',
                            style: TextStyle(
                              fontSize: 16,
                            )),
                      ),
                    ),
                    Flexible(
                      child: FittedBox(
                        child: Text(
                          'Cairo', //persons[idx].address
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

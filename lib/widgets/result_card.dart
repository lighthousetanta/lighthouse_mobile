import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_lighthouse/providers/poi_provider.dart';
import '../models/poi.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as spinKit;
import '../screens/poiProfileScreen.dart';

class ResultCard extends StatelessWidget {
  final Poi poi;
  ResultCard(this.poi);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, PoiProfile.routeName, arguments: poi.id);
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
                        errorWidget: (ctx, _, s) =>
                            Image.asset('assets/images/appImages/johndoe.png'),
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
                  Text(
                    'Similarity Ratio',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Consumer<PoiProvider>(
                    builder: (context, provider, c) => Center(
                      child: Text(
                        '${provider.similarityMap[poi.id].toString()}%',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

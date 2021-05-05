import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import '../models/poi.dart';
import '../providers/poi_provider.dart';
import '../screens/editPoiProfile.dart';

class PoiProfile extends StatefulWidget {
  static const routeName = '/poiProfile';

  @override
  _PoiProfileState createState() => _PoiProfileState();
}

class _PoiProfileState extends State<PoiProfile> {
  bool loadingOverlay = false;
  bool deleted = false;

  Future<void> removePoi(int poiID) async {
    try {
      await Provider.of<PoiProvider>(context, listen: false).deletePoi(poiID);
      deleted = true;
    } catch (error) {
      deleted = false;
      print('DELETE Error --> $error');
      setState(() {
        loadingOverlay = false;
      });
      await _showMyDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final poiID = ModalRoute.of(context).settings.arguments as int;
    final poiData = Provider.of<PoiProvider>(context);
    Poi poi = poiData.getById(poiID);
    print(poi.id);
    return Scaffold(
      appBar: AppBar(
        title: Text("${poi.name.split(' ')[0]}'s Profile"),
      ),
      body: LoadingOverlay(
        isLoading: loadingOverlay,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.teal[200], Colors.teal[800]])),
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                    height: 200,
                    width: 200,
                    child: poi.image == null
                        ? Image.asset("assets/images/appImages/johndoe.png")
                        : CachedNetworkImage(imageUrl: poi.image)),
                SizedBox(
                  height: 15,
                ),
                Text(poi.name, style: Theme.of(context).textTheme.headline5),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Last known Location: ',
                            style: Theme.of(context).textTheme.headline4),
                        SizedBox(height: 6),
                        Text('Cairo',
                            style: Theme.of(context).textTheme.headline3),
                        SizedBox(height: 8),
                        Text(
                          'Relative/Reporter:',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Batman',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    )),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        width: 100,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, EditPoi.routeName,
                                arguments: poiID);
                          },
                          child: Text('Edit',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                              elevation: 5, primary: Colors.indigo[100]),
                        )),
                    Container(
                        width: 100,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              loadingOverlay = true;
                            });
                            await removePoi(poi.id);
                            if (deleted) {
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Delete',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.redAccent[700])),
                          style: ElevatedButton.styleFrom(
                              elevation: 5, primary: Colors.indigo[100]),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _showMyDialog(ctx) async {
  return showDialog<void>(
    context: ctx,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('we couldn\'t delete!'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Approve', style: TextStyle(fontSize: 18)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

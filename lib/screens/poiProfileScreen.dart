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
  Poi poi;
  bool isInit = true;
  bool listen = true;
  Future<void> removePoi(int poiID) async {
    listen = false;
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
  void didChangeDependencies() {
    if (isInit) {
      // final poiID = ModalRoute.of(context).settings.arguments as int;

      // poi = Provider.of<PoiProvider>(context, listen: true).getById(poiID);
    }
    isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final poiID = ModalRoute.of(context).settings.arguments as int;
    /*Very complicated 
    So, it's better to make the deletion option from outside -swipe the card or x-
    and make an edit icon
     */
    if (!deleted) {
      poi = Provider.of<PoiProvider>(context, listen: false).getById(poiID);
    }
    Provider.of<PoiProvider>(context, listen: listen);
    return Scaffold(
      appBar: AppBar(
        title: Text("${poi.name.split(' ')[0]}'s Profile"),
      ),
      body: LoadingOverlay(
        isLoading: loadingOverlay,
        child: Container(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
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
                                      fontSize: 22,
                                      color: Colors.redAccent[700])),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.amber[200],
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, EditPoi.routeName,
                                    arguments: poi.id);
                              },
                              child: Text('Edit',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.black)),
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 10),
                                  primary: Colors.amber[200]),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                      Expanded(
                        child: Text(
                          'Clark Kent',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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

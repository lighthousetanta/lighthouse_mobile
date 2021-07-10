import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:the_lighthouse/providers/auth.dart';
import '../widgets/poi_details_Sheet.dart';
import '../models/poi.dart';
import '../providers/poi_provider.dart';
import '../screens/editPoiProfile.dart';
import 'reporterDetailsScreen.dart';

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
  bool isRelated;
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

  Future<bool> deleteAlert(BuildContext ctx) async {
    return await showDialog(
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Attention'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(fontSize: 15),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'No',
                    style: TextStyle(fontSize: 15),
                  ))
            ],
            content: Text("Are you sure you want to delete?"),
          );
        });
  }

  Widget deleteButton() {
    return Expanded(
      child: ElevatedButton(
        onPressed: () async {
          bool deleteAction = await deleteAlert(context);
          if (deleteAction == true) {
            setState(() {
              loadingOverlay = true;
            });
            await removePoi(poi.id);
            if (deleted) {
              Navigator.pop(context);
            }
          }
        },
        child:
            Text('Delete', style: TextStyle(fontSize: 22, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          primary: Colors.teal,
          side: BorderSide(color: Colors.white),
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        ),
      ),
    );
  }

  Widget editButton() {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, EditPoi.routeName, arguments: poi.id);
        },
        child:
            Text('Edit', style: TextStyle(fontSize: 22, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          primary: Colors.teal,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          side: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget reporterProfileButton() {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.of(context).pushNamed(ReporterDetailsScreen.routeName,
            arguments: poi.reporter);
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(10),
        side: BorderSide(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
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
    );
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
    /* 
    This is very complicated 
    So, it's better to make the deletion option from outside -swipe the card or x-
    and make an edit icon
     */

    // isRelated = true;
    if (!deleted) {
      poi = Provider.of<PoiProvider>(context, listen: false).getById(poiID);
      poi.reporter.id == Provider.of<Auth>(context, listen: false).userID
          ? isRelated = true
          : isRelated = false;
    }
    Provider.of<PoiProvider>(context, listen: listen);
    return Scaffold(
      appBar: AppBar(
        title: Text("${poi.name.split(' ')[0]}'s Profile"),
      ),
      body: LoadingOverlay(
        isLoading: loadingOverlay,
        child: Container(
          color: Colors.grey[300],
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
                        errorWidget: (ctx, _, s) =>
                            Image.asset('assets/images/appImages/johndoe.png'),
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
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(125, 187, 185, 1),
                            Color.fromRGBO(228, 202, 174, 1),
                          ])),
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      SizedBox(height: 5),
                      if (isRelated)
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              deleteButton(),
                              SizedBox(width: 15),
                              editButton(),
                            ]),
                      SizedBox(height: 10),
                      Flexible(
                        child: FittedBox(
                          child: Text('Last Known Location ',
                              style: Theme.of(context).textTheme.headline3),
                        ),
                      ),
                      Flexible(
                        child: FittedBox(
                            child: Text('Cairo',
                                style: Theme.of(context).textTheme.headline4)),
                      ),
                      SizedBox(height: 15),
                      if (!isRelated) reporterProfileButton()
                    ],
                  ),
                ),
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
                        primary:
                            Colors.teal, // Color.fromRGBO(76, 144, 175, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        // elevation: 0,
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
      ),
    );
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
}

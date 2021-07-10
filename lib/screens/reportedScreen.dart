import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as spinKit;
import 'package:provider/provider.dart';
import 'package:the_lighthouse/providers/auth.dart';
import 'package:the_lighthouse/screens/searchScreen.dart';
import 'package:the_lighthouse/widgets/poi_card.dart';
import '../providers/poi_provider.dart';
import './addPersonScreen.dart';
import '../widgets/app_drawer.dart';

class ReportedScreen extends StatefulWidget {
  static const routeName = '/reportedScreen';
  @override
  _ReportedScreenState createState() => _ReportedScreenState();
}

class _ReportedScreenState extends State<ReportedScreen> {
  bool isInit = true;
  bool fetchError = false;
  bool isLoading = false;
  bool _drawerIsOpened;

  Future _future;
  Future fetchPersons() {
    // Provider.of<PoiProvider>(context, listen: false).fetchReported();
    return Provider.of<PoiProvider>(context, listen: false).fetchPersons();
  }

  @override
  void initState() {
    if (isInit) {
      isInit = false;
      _future = fetchPersons();
    }
    isInit = false;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    print('>>>>>>> built <<<<<<<');
    return Scaffold(
      
      appBar: AppBar(
        title: Text('Missing Persons Feed'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.pushNamed(context, SearchScreen.routeName);
              })
        ],
      ),
      drawer: AppDrawer(),
      onDrawerChanged: (isopened) => _drawerIsOpened = isopened,
      body: WillPopScope(
        onWillPop: () {
          if (_drawerIsOpened == true) {
            Navigator.of(context).pop();
            return Future.value(false);
          }

          return exitAlert(context);
        },
        child: RefreshIndicator(
          onRefresh: () => fetchPersons(),
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          size: 90,
                          color: Colors.grey[600],
                        ),
                        Text('Something went wrong',
                            style: TextStyle(fontSize: 22)),
                        SizedBox(height: 15),
                        Text(
                          'Please, check out your connection',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return spinKit.SpinKitRing(color: Colors.teal[500], size: 70);
                } else if (Provider.of<PoiProvider>(context)
                    .allPersons
                    .isEmpty) {
                  return Center(
                      child: Text(
                    'No persons yet in our Database',
                    style: TextStyle(fontSize: 22),
                  ));
                } else {
                  return Consumer<PoiProvider>(
                    builder: (context, provider, _) => ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: provider.allPersons.length,
                        itemBuilder: (context, idx) {
                          return PoiCard(provider.allPersons[idx]);
                        }),
                  );
                }
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddPerson.routeName);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

Future<bool> exitAlert(BuildContext ctx) async {
  return await showDialog(
      context: ctx,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Attention'),
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop(true);
                  await Provider.of<Auth>(ctx, listen: false).logout();
                },
                child: Text(
                  'Yes',
                  style: TextStyle(fontSize: 15),
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text(
                  'No',
                  style: TextStyle(fontSize: 15),
                ))
          ],
          content: Text("Do you want to Exit?"),
        );
      });
}

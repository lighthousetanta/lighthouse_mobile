import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as spinKit;
import 'package:provider/provider.dart';
import 'package:the_lighthouse/models/poi.dart';
import 'package:the_lighthouse/screens/searchScreen.dart';
import 'package:the_lighthouse/widgets/poi_card.dart';
import '../providers/poi_provider.dart';
import './addPersonScreen.dart';

class UserReportedScreen extends StatefulWidget {
  static const routeName = '/userReportedScreen';
  @override
  _UserReportedScreenState createState() => _UserReportedScreenState();
}

class _UserReportedScreenState extends State<UserReportedScreen> {
  bool isInit = true;
  bool fetchError = false;
  bool isLoading = false;

  Future _future;
  Future fetchPerUser() {
    return Provider.of<PoiProvider>(context, listen: false).fetchReported();
  }

  @override
  @override
  void initState() {
    if (isInit) {
      isInit = false;
      _future = fetchPerUser();
    }
    isInit = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('>>>>>>> built <<<<<<<');
    return Scaffold(
      appBar: AppBar(
        title: Text('My Reported Cases'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.pushNamed(context, SearchScreen.routeName);
              })
        ],
      ),
      body: RefreshIndicator(
          onRefresh: () => fetchPerUser(),
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          child: Consumer<PoiProvider>(
            builder: (context, provider, _) => FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  List<Poi> reported = provider.reported;
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
                          TextButton(
                              onPressed: () async {
                                try {
                                  await fetchPerUser();
                                  setState(() {});
                                } catch (error) {
                                  // doesn't work ??????????!!
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('Network Error'),
                                    duration: Duration(seconds: 3),
                                  ));
                                }
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.teal,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                              child: Text(
                                'Try Again',
                                style: TextStyle(fontSize: 18),
                              ))
                        ],
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return spinKit.SpinKitRing(
                        color: Colors.teal[500], size: 70);
                  } else if (reported.isEmpty) {
                    return SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Text(
                              'You didn\'t add any person. \n pull down to refresh',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 22),
                            )),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: reported.length,
                        itemBuilder: (context, idx) {
                          return PoiCard(reported[idx]);
                        });
                  }
                }),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddPerson.routeName);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

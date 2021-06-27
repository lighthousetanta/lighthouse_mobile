import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as spinKit;
import 'package:provider/provider.dart';
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

  Future<void> _fetch() async {
    try {
      await Provider.of<PoiProvider>(context, listen: false)
          .fetchPersons()
          .then((_) {
        setState(() {
          isLoading = false;
        });
      });
    } catch (error) {
      print('Fetching Error -->$error');
      setState(() {
        isLoading = false;
        fetchError = true;
      });
    }
  }

  Future _future;
  Future fetchPersons() {
    Provider.of<PoiProvider>(context, listen: false).fetchPerUser();
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
      body: RefreshIndicator(
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
                      TextButton(
                          onPressed: () async {
                            try {
                              await _fetch();
                              setState(() {});
                            } catch (error) {
                              // doesn't work ??????????!!
                              ScaffoldMessenger(
                                  child: SnackBar(
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
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return spinKit.SpinKitRing(color: Colors.teal[500], size: 70);
              } else if (snapshot.data == []) {
                return Center(
                    child: Text(
                  'No persons yet in our Database',
                  style: TextStyle(fontSize: 22),
                ));
              } else {
                return Consumer<PoiProvider>(
                  builder: (context, provider, _) => ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: provider.getPersons.length,
                      itemBuilder: (context, idx) {
                        return PoiCard(provider.getPersons[idx]);
                      }),
                );
              }
            }),
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

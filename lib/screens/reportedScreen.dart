import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as spinKit;
import 'package:provider/provider.dart';
import '../providers/poi_provider.dart';
import './poiProfileScreen.dart';
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

  @override
  void didChangeDependencies() {
    if (isInit) {
      isInit = false;
      setState(() {
        isLoading = true;
      });
      _fetch();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('>>>>>>> built <<<<<<<');
    final persons = Provider.of<PoiProvider>(context).getPersons;
    return Scaffold(
      appBar: AppBar(
        title: Text('Missing Persons Feed'),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _fetch(),
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        child: Builder(builder: (context) {
          if (fetchError) {
            return Center(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                      minHeight: MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height -
                          25),
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
                        'Please, check out your connection\n or Pull down to Refresh ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (isLoading) {
            return spinKit.SpinKitRing(color: Colors.teal[500], size: 70);
          } else {
            return ListView.builder(
                itemCount: persons.length,
                itemBuilder: (context, idx) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, PoiProfile.routeName,
                          arguments: persons[idx].id);
                    },
                    child: Card(
                      child: Row(
                        children: [
                          Container(
                              height: 200,
                              width: 200,
                              child: CachedNetworkImage(
                                imageUrl: persons[idx].image,
                                fit: BoxFit.contain,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                              )),
                          Container(
                            height: 204,
                            padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Name',
                                    style: TextStyle(
                                      fontSize: 16,
                                    )),
                                Container(
                                  width: 190,
                                  child: Text(
                                    persons[idx].name,
                                    style:
                                        Theme.of(context).textTheme.headline6,
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
                });
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

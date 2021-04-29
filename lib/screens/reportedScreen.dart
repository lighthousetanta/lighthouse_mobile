import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:the_lighthouse/models/poi.dart';
import 'package:the_lighthouse/screens/addPersonScreen.dart';
import 'package:the_lighthouse/screens/poiProfileScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as spinKit;

class Reported extends StatefulWidget {
  @override
  _ReportedState createState() => _ReportedState();
}

class _ReportedState extends State<Reported> {
  List<Poi> persons = [];

  Future<List<Poi>> getPersons() async {
    var dio = Dio();

    String endPoint = "https://lighthousetanta.herokuapp.com/api/missing";

    try {
      Response response = await dio.get(endPoint);

      if (response.statusCode == 200) {
        print('GET --> Successfully [OK 200]');

        for (var newPerson in response.data) {
          persons.add(Poi.fromJson(newPerson));
        }
      }
    } catch (e) {
      print('GET Error --> $e');
    }
    return persons;
  }

  Future<List<Poi>> _future;

  @override
  void initState() {
    // caching the retrieved List to Prevent Multiple GET requests
    _future = getPersons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Reported Persons'),
      ),
      body: FutureBuilder(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return spinKit.SpinKitRing(
                color: Colors.teal[500],
                size: 70,
              );
            }

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, idx) {
                return GestureDetector(
                  onTap: () async {
                    List result;
                    result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PoiProfile(poi: snapshot.data[idx])),
                    );
                    bool updated;
                    Poi updatedPoi;
                    bool deleted;
                    if (result.length == 2) {
                      updated = result[0];
                      updatedPoi = result[1];
                    } else {
                      deleted = result[0];
                    }

                    if (deleted == true) {
                      setState(() {
                        persons.removeAt(idx);
                      });
                    }
                    if (updated) {
                      setState(() {
                        persons[idx] = updatedPoi;
                      });
                    }
                  },
                  child: Card(
                    child: Row(
                      children: [
                        Container(
                            height: 200,
                            width: 200,
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data[idx].image,
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
                                  snapshot.data[idx].name,
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
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPoi = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPerson()));

          if (newPoi != null) {
            setState(() => persons.add(newPoi));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

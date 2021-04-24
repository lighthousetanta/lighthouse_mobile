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
  // final List<Poi> persons = [
  // Poi(name: 'Robin', age: 12, address: 'Gotham'),
  // Poi(name: 'Ali Mojahed Moustafa', age: 22, address: 'Cairo'),
  // Poi(name: 'Emad Mahmoud', age: 33, address: 'Alex'),
  // Poi(name: 'Alaa Abdullah', age: 44, address: 'New Jersey'),
  // Poi(name: 'Rami faris', age: 55, address: 'Los Angeles'),
  // Poi(name: 'Othman Adel', age: 66, address: 'London'),
  // Poi()
  // ];
  List<Poi> newPersons = [];
  Future<List<Poi>> getPersons() async {
    var dio = Dio();

    String endPoint =
        "https://murmuring-thicket-06467.herokuapp.com/api/missing";

    try {
      Response response = await dio.get(endPoint);

      if (response.statusCode == 200) {
        print('GET --> Successfully [OK 200]');
        // print(response.data);

        for (var newPerson in response.data) {
          newPersons.add(Poi.fromJson(newPerson));
        }
      }
    } catch (e) {
      print('GET Error --> $e');
    }

    return newPersons;
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
        title: Text('Reported Persons'),
      ),
      body: Container(
        child: FutureBuilder(
            future: _future,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.data == null
                  ? spinKit.SpinKitFadingCircle(
                      color: Colors.blue,
                      size: 70,
                    )
                  : ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, idx) {
                        return GestureDetector(
                          onTap: () async {
                            bool deleted;
                            deleted = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PoiProfile(poi: snapshot.data[idx])),
                            );

                            if (deleted == true) {
                              setState(() {
                                newPersons.removeAt(idx);
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
                                      imageUrl: snapshot.data[idx].images[0],
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                    )),
                                Container(
                                  height: 204,
                                  padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('Name',
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                      Container(
                                        width: 190,
                                        child: Text(
                                          snapshot.data[idx].name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      SizedBox(height: 15),
                                      Text('Last known location',
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                      Text(
                                        'Cairo', //persons[idx].address
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPoi = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPerson()));
          print("00000000000");
          print(newPoi);
          if (newPoi != null) {
            setState(() => newPersons.add(newPoi));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

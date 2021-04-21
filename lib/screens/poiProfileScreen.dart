import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:the_lighthouse/models/poi.dart';

class PoiProfile extends StatelessWidget {
  final Poi poi;
  PoiProfile({this.poi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${poi.name.split(' ')[0]}'s Profile"),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.indigo[200], Colors.indigo])),
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                  height: 200,
                  width: 200,
                  child: poi.images == null
                      ? Image.asset("assets/images/appImages/johndoe.png")
                      : CachedNetworkImage(imageUrl: poi.images[0])),
              SizedBox(
                height: 15,
              ),
              Text(poi.name, style: Theme.of(context).textTheme.headline5),
              Container(
                  width: double.infinity,
                  // margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Text(
                      //   'Age: ',
                      //   style: Theme.of(context).textTheme.headline4,
                      // ),
                      // SizedBox(height: 6),
                      // Text("${poi.age.toString()} years old",
                      //     style: Theme.of(context).textTheme.headline3),
                      // SizedBox(height: 8),
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
                        onPressed: () {},
                        child: Text('Edit',
                            style: TextStyle(
                                fontSize: 20, color: Colors.blue[700])),
                        style: ElevatedButton.styleFrom(
                            elevation: 5, primary: Colors.indigo[100]),
                      )),
                  Container(
                      width: 100,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          var dio = Dio();
                          String endPoint =
                              "https://murmuring-thicket-06467.herokuapp.com/api/missing/${poi.id}";
                          try {
                            Response response = await dio.delete(endPoint);
                            print(response.statusCode);

                            if (response.statusCode == 204) {
                              print(
                                  "${poi.name} whose ID is ${poi.id} Was removed from Database");
                              final bool deleted = true;
                              Navigator.pop(context, deleted);
                            }
                          } catch (e) {
                            _showMyDialog(context);
                          }
                        },
                        child: Text('Delete', // Delete it from the list too!
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

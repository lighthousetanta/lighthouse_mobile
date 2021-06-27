import 'package:flutter/material.dart';
import 'package:the_lighthouse/models/poi.dart';

class ResultScreen extends StatelessWidget {
  static const routeName = '/resultScreen';
  // todo: show multiple faces
  @override
  Widget build(BuildContext context) {
    Poi poi = ModalRoute.of(context).settings.arguments as Poi;
    return Scaffold(
        appBar: AppBar(
          title: Text("Result"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  poi.image,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 50),
              Text(
                poi.name,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway'),
              ),
            ],
          ),
        ));
  }
}

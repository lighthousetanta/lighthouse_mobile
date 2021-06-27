import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:loading_overlay/loading_overlay.dart';
import 'package:the_lighthouse/models/poi.dart';
import 'package:the_lighthouse/screens/resultScreen.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/searchScreen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = false;
  File _image;
  bool res = false;
  Poi result;
  double similarity;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        _image = null;
      }
    });
  }

  Future<void> _search() async {
    String img =
        'https://images.unsplash.com/photo-1477239439998-839196943351?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=714&q=80';
    Poi dummyData = Poi(id: 500, image: img, name: 'alex');
    try {
      var response =
          await Future.delayed(Duration(seconds: 2), () => dummyData);
      if (response != null) {
        result = response;
      }
      setState(() {
        isLoading = false;
        res = true;
        Navigator.pushNamed(context, ResultScreen.routeName, arguments: result);
      });
    } catch (error) {
      //throw error
      setState(() {
        isLoading = false;
      });
      print('Search Error --> $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        centerTitle: true,
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        child: Padding(
            padding: EdgeInsets.all(5),
            child: _image == null
                ? Center(
                    child: Text(
                    "You didn't select an image",
                    style: TextStyle(color: Colors.redAccent, fontSize: 22),
                  ))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          height: 400,
                          child: Image.file(
                            _image,
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await _search();
                          },
                          child: Text(
                            "Search",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                          )),
                    ],
                  )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImage();
        },
        
        tooltip: "Pick an Image",
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

class Result extends StatelessWidget {
  final data;
  Result({this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "$data",
        style: TextStyle(color: Colors.amber, fontSize: 40),
      ),
    );
  }
}

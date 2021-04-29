import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  File _image;
  bool res = false;
  String similarity;
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

  // ignore: unused_element
  //Future              async
  void _search() {
    Map<String, Object> data = {"name": "mohamed", "sim": 99};
    setState(() {
      similarity = data["sim"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.all(5),
          child: _image == null
              ? Center(
                  child: Text(
                  "You didn't select an image",
                  style: TextStyle(color: Colors.amber[900], fontSize: 22),
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
                        onPressed: () {
                          _search();
                          setState(() {
                            res = true;
                          });
                        },
                        child: Text(
                          "Search",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    res == true
                        ? Text(
                            "$similarity%",
                            style: TextStyle(fontSize: 20),
                          )
                        : SizedBox()
                  ],
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImage();
          res = false;
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

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:the_lighthouse/models/poi.dart';

class AddPerson extends StatefulWidget {
  @override
  _AddPersonState createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson> {
  final _fName = TextEditingController();

  final _mName = TextEditingController();

  final _lName = TextEditingController();

  final _age = TextEditingController();
  bool loaded = false;
  File _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        // _image = null;
      }
    });
  }

  Future<void> _submit() async {
    String imgPath = _image.path;
    String imgName = imgPath.split("/").last;

    try {
      var formData = FormData.fromMap({
        // "fname": _fName.text,
        // "mName": _mName.text,
        // "lname": _lName.text,
        // "age": 15,
        // "contactPerson": {'username': 0},
        "name": _fName.text,
        'image': await MultipartFile.fromFile(imgPath, filename: imgName),
      });

      var dio = Dio();
      String endpoint =
          "https://murmuring-thicket-06467.herokuapp.com/api/missing";
      Response response = await dio.post(endpoint, data: formData);
      print("Submit Response: $response");
      if (response.statusCode == 201) {
        print('POST --> Successfully [OK 201]');

        final Poi newPoi = Poi.fromJson(response.data);
        // loaded = true;
        Navigator.pop(context, newPoi);
      }
    } catch (e) {
      print("POST Erorr -->: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add a Missing Person',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            child: ListView(children: [
              TextField(
                controller: _fName,
                decoration: InputDecoration(
                  hintText: 'First Name',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white70,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _mName,
                decoration: InputDecoration(
                  hintText: 'Middle Name',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white70,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _lName,
                decoration: InputDecoration(
                  hintText: 'Last Name',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white70,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _age,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Age',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white70,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              Row(
                children: [
                  // ignore: deprecated_member_use
                  FlatButton.icon(
                    padding: EdgeInsets.only(left: 10),
                    onPressed: getImage,
                    icon: Icon(Icons.add_a_photo),
                    label: Text(
                      'Add a Photo',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              // add a button for optional information
              // date of went missing, last known location and clothes
              // build this in a a seperate class that is called on pressing the button
              // ElevatedButton.icon(
              //     onPressed: () {},
              //     icon: Icon(Icons.add),
              //     label: Text('add info')),
              // MoreInfo(),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      //padding: EdgeInsets.fromLTRB(45, 10, 45, 10),
                      //color: Colors.yellow[800],
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                      onPressed: () {
                        FocusScope.of(context)
                            .unfocus(); // dismiss keyboard on login ..
                        // need to be dismissed on any part of sreen
                        //Navigator.pushNamed(context, routeName)
                        _submit();

                        print('submited');
                        // Future.delayed(Duration(seconds: 10),()=>);
                      },
                    ),
                    SizedBox(height: 20),
                    loaded
                        ? Text(
                            "Submited Successfully",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                        : SizedBox()
                  ],
                ),
              ),
            ]),
          )),
    );
  }
}

class MoreInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'more details',
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white70,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

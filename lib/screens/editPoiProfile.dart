import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:the_lighthouse/models/poi.dart';
import 'package:loading_overlay/loading_overlay.dart';

class EditPoi extends StatefulWidget {
  final Poi poi;
  EditPoi({this.poi});
  @override
  _EditPoiState createState() => _EditPoiState();
}

class _EditPoiState extends State<EditPoi> {
/* Provider is comming */
  String _fName;
  String _mName;
  String _lName;
  int _age;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loadingOverlay = false;

  bool imageLoaded = false;
  File _image;
  final picker = ImagePicker();

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageLoaded = true;
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _update(int poiID) async {
    String imgPath;
    String imgName;

    if (imageLoaded) {
      imgPath = _image.path;
      imgName = imgPath.split("/").last;
    }

    bool updated = false;
    var body = {
      "name": _fName,
      'image': imageLoaded ? await MultipartFile.fromFile(imgPath, filename: imgName): null,
    };
    body.removeWhere((key, value) => value == null);
    try {
      var formData = FormData.fromMap(body);

      var dio = Dio();
      String endpoint =
          "https://lighthousetanta.herokuapp.com/api/missing/$poiID";

      Response response = await dio.patch(endpoint, data: formData);

      print('UPDATE Code--> ${response.statusCode}');
     
      if (response.statusCode == 202) {
        updated = true;
        Poi updatedPoi = Poi.fromJson(response.data);
        Navigator.pop(context, [updated, updatedPoi]);
      }
    } catch (e) {
      print("UPDATE Error -->: $e");

      _showMyDialog(context);
      //removing  the LoadingOverlay effect
      setState(() {
        loadingOverlay = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: LoadingOverlay(
          isLoading: loadingOverlay,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 120,
                  height: 90,
                  child: ElevatedButton.icon(
                    onPressed: _getImage,
                    icon: Icon(Icons.add_a_photo),
                    label: Text(
                      'Update the current Image',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                imageLoaded
                    ? Text("Successfully Loaded.",
                        style: TextStyle(color: Colors.green[700]))
                    : Text(
                        'Choose a new image',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                SizedBox(height: 8),
                Form(
                  key: _formKey,
                  child: Container(
                    height: 400,
                    child: ListView(children: [
                      Column(children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          // controller: _fName,
                          initialValue: widget.poi.name,
                          maxLength: 20,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "This field cann't be empty.";
                            }
                            return null;
                          },
                          onSaved: (String value) => _fName = value,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          decoration: InputDecoration(
                            hintText: 'First Name',
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.tealAccent[700], width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.teal, width: 2),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return "This field cann't be empty.";
                          //   }
                          //   return null;
                          // },
                          onSaved: (String value) => _mName = value,
                          decoration: InputDecoration(
                            hintText: 'Middle Name',
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.tealAccent[700], width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.teal, width: 2),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return "This field cann't be empty.";
                          //   }
                          //   return null;
                          // },
                          onSaved: (String value) => _lName = value,
                          decoration: InputDecoration(
                            hintText: 'Last Name',
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.tealAccent[700], width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.teal, width: 2),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          // validator: (value) {
                          //   int val = int.tryParse(value);
                          //   if (value.isEmpty) {
                          //     return "This field cann't be empty.";
                          //   } else if (val <= 0) {
                          //     return "Enter a valid Age.";
                          //   }
                          //   return null;
                          // },
                          //  onSaved: (String value) => _age = value as int,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Age ex: 12 years old.',
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.tealAccent[700], width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.teal, width: 2),
                            ),
                          ),
                        ),
                        SizedBox(height: 20)
                      ]),
                      Center(
                          child: Container(
                        width: 160,
                        height: 50,
                        child: ElevatedButton(
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();

                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                loadingOverlay = true;
                                _update(widget.poi.id);
                              }
                            }),
                      )),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

Future<void> _showMyDialog(ctx) async {
  return showDialog<void>(
    context: ctx,
    barrierDismissible: false, // user must tap the button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Check your connection'),
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

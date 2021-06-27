import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/poi.dart';
import '../providers/poi_provider.dart';
import 'package:loading_overlay/loading_overlay.dart';

class EditPoi extends StatefulWidget {
  static const routeName = '/EditPoi';
  @override
  _EditPoiState createState() => _EditPoiState();
}

class _EditPoiState extends State<EditPoi> {
  String _fName;
  // String _mName;
  // String _lName;
  // int _age;
  bool updated = false;
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

  Future<void> _update(Map<String, dynamic> poiData) async {
    try {
      await Provider.of<PoiProvider>(context, listen: false)
          .updatePoi(poiData, _image);
      updated = true;
    } catch (error) {
      updated = false;
      print("UPDATE Error -->: $error");

      setState(() {
        loadingOverlay = false;
      });

      await _showMyDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    int poiID = ModalRoute.of(context).settings.arguments as int;
    Poi oldPoi = Provider.of<PoiProvider>(context).getById(poiID);
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
                          initialValue: oldPoi.name,
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
                          // onSaved: (String value) => _mName = value,
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
                          // onSaved: (String value) => _lName = value,
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
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                setState(() {
                                  loadingOverlay = true;
                                });
                                Map<String, dynamic> poiData = {
                                  'id': poiID,
                                  'name': _fName,
                                };
                                await _update(poiData);
                                if (updated) {
                                  Navigator.pop(context);
                                }
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

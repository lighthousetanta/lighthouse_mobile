import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../providers/poi_provider.dart';

class AddPerson extends StatefulWidget {
  static const routeName = '/addPersonScreen';
  @override
  _AddPersonState createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson> {
  final _fName = TextEditingController();

  final _mName = TextEditingController();

  final _lName = TextEditingController();

  final _age = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loadingOverlay = false;
  bool imageLoaded = false;
  bool added = false;
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

  Future<void> _submit(Map<String, dynamic> userInput) async {
    try {
      await Provider.of<PoiProvider>(context, listen: false)
          .submitNewPoi(_image.path, userInput);
      added = true;
    } catch (error) {
      added = false;
      print("POST Erorr --> $error");

      setState(() {
        loadingOverlay = false;
      });
      await _showMyDialog(context);
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
        body: LoadingOverlay(
          isLoading: loadingOverlay,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                Column(
                  children: [
                    Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: _image == null
                          ? Image.asset(
                              'assets/images/appImages/johndoe.png',
                            )
                          : Image.file(_image),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                imageLoaded
                    ? Text("Successfully Loaded.",
                        style: TextStyle(color: Colors.green[700]))
                    : Text(
                        'You must Choose an Image.',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                SizedBox(height: 5),
                Container(
                  child: ElevatedButton.icon(
                    onPressed: _getImage,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                    ),
                    icon: Icon(Icons.photo),
                    label: Text(
                      'Add a Photo',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Form(
                  key: _formKey,
                  child: Container(
                    height: 400,
                    child: ListView(children: [
                      Column(children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _fName,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "This field cann't be empty.";
                            }
                            return null;
                          },
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
                                    BorderSide(color: Colors.teal, width: 2)),
                            errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.redAccent[700])),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.teal, width: 2)),
                          ),
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _mName,
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return "This field cann't be empty.";
                          //   }
                          //   return null;
                          // },
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
                          controller: _lName,
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return "This field cann't be empty.";
                          //   }
                          //   return null;
                          // },
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
                          controller: _age,
                          // validator: (value) {
                          //   int val = int.tryParse(value);
                          //   if (value.isEmpty) {
                          //     return "This field cann't be empty.";
                          //   } else if (val <= 0) {
                          //     return "Enter a valid Age.";
                          //   }
                          //   return null;
                          // },
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
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 15),
                            ),
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
                              if (_formKey.currentState.validate() &&
                                  imageLoaded) {
                                setState(() {
                                  loadingOverlay = true;
                                });
                                Map<String, dynamic> input = {
                                  'name': _fName.text
                                };
                                print('submiting...');
                                await _submit(input);
                                if (added) {
                                  Navigator.of(context).pop();
                                }
                              }
                            }),
                      ),
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
            child: Text('OK', style: TextStyle(fontSize: 18)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

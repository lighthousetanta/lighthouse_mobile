import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:the_lighthouse/models/poi.dart';
import 'package:loading_overlay/loading_overlay.dart';

class AddPerson extends StatefulWidget {
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

  Future<void> _submit() async {
    String imgPath = _image.path;
    String imgName = imgPath.split("/").last;

    try {
      var formData = FormData.fromMap({
        "name": _fName.text,
        'image': await MultipartFile.fromFile(imgPath, filename: imgName),
      });

      var dio = Dio();
      String endpoint =
          "https://murmuring-thicket-06467.herokuapp.com/api/missing";
      Response response = await dio.post(endpoint, data: formData);

      if (response.statusCode == 201) {
        print('POST --> Successfully [OK 201]');

        final Poi newPoi = Poi.fromJson(response.data);

        Navigator.pop(context, newPoi);
      }
    } catch (e) {
      print("POST Erorr -->: $e");

      _showMyDialog(context);
      //removing  the LoadingOverlay effect
      setState(() {});
      loadingOverlay = false;
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
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 120,
                  height: 90,
                  child: ElevatedButton.icon(
                    onPressed: _getImage,
                    icon: Icon(Icons.add_a_photo),
                    label: Text(
                      'Add a Photo',
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
                        'You must Choose an Image.',
                        style: TextStyle(color: Colors.redAccent),
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
                          maxLength: 20,
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
                                  BorderSide(color: Colors.teal, width: 2),
                            ),
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

                              if (_formKey.currentState.validate() &&
                                  imageLoaded) {
                                print('submitted');
                                loadingOverlay = true;
                                _submit();
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

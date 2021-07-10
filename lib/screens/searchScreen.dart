import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import '../providers/poi_provider.dart';
import '/screens/resultScreen.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/searchScreen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = false;
  File _image;
  bool res = false;
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
    try {
      await Provider.of<PoiProvider>(context, listen: false)
          .searchByImg(_image.path);
      setState(() {
        isLoading = false;
        res = true;
        Navigator.pushNamed(context, ResultScreen.routeName); 
      });
    } catch (error) {
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
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.grey[300]),
                      height: 400,
                      child: _image == null
                          ? Center(
                              child: Text(
                              "You didn't add an image",
                              style: Theme.of(context).textTheme.headline3,
                            ))
                          : Image.file(
                              _image,
                            ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 70, vertical: 10)),
                        onPressed: () {
                          getImage();
                        },
                        icon: Icon(
                          Icons.photo,
                          size: 40,
                        ),
                        label: Flexible(
                          child: Text(
                            _image == null ? 'Add a photo' : 'Change the photo',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )),
                  ),
                  if (_image != null)
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      width: double.infinity,
                      child: ElevatedButton.icon(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await _search();
                          },
                          icon: Icon(
                            Icons.search,
                            size: 40,
                            semanticLabel: 'Search by image',
                          ),
                          label: Text(
                            "Search",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 15),
                          )),
                    ),
                ],
              ),
            )),
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

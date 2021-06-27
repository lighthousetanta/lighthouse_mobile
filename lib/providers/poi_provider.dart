import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import '../models/poi.dart';

class PoiProvider with ChangeNotifier {
  List<Poi> _persons = [];
  List _cookies;
  PoiProvider(this._cookies, this._persons);
  static const missingEndpoint =
      "https://stormy-lake-08470.herokuapp.com/api/missing";

  List<Poi> _userReported = [];

  List<Poi> get getPersons {
    return [..._persons];
  }

  List<Poi> get getUserReported {
    return [..._userReported];
  }

  Poi getById(int id) {
    int idx = _persons.indexWhere((element) => element.id == id);

    return _persons[idx];
  }

  Future<void> fetchPersons() async {
    print('FETCHING ALL MISSING POIs');

    var dio = Dio();
    String endPoint = missingEndpoint;
    List<Poi> loadedData = [];

    try {
      Response response = await dio.get(endPoint);

      if (response.statusCode >= 200) {
        print('GET --> Successfully [OK ${response.statusCode}]');

        for (var newPerson in response.data) {
          loadedData.add(Poi.fromJson(newPerson));
        }

        _persons = loadedData;

        notifyListeners();
      } else {
        print('GET --> ${response.statusCode}');
      }
    } catch (error) {
      print('GET Error --> $error');
      throw error;
    }
  }

  Future<void> fetchPerUser() async {
    print('FETCHING per user');

    var dio = Dio();
    String endPoint = missingEndpoint; //+ '&$_userID' ;
    List<Poi> loadedData = [];

    try {
      Response response = await dio.get(endPoint);

      if (response.statusCode >= 200) {
        print('GET --> Successfully [OK ${response.statusCode}]');

        for (var newPerson in response.data) {
          loadedData.add(Poi.fromJson(newPerson));
        }

        _userReported = loadedData;

        notifyListeners();
      } else {
        print('GET --> ${response.statusCode}');
      }
    } catch (error) {
      print('GET Error --> $error');
      throw error;
    }
  }

  Future<void> submitNewPoi(
      String imagePath, Map<String, dynamic> userInput) async {
    String imgName = imagePath.split("/").last;
    print(imagePath);
    try {
      var formData = FormData.fromMap({
        "name": userInput['name'],
        'image': await MultipartFile.fromFile(imagePath, filename: imgName),
      });

      var dio = Dio();
      String endpoint = missingEndpoint;
      Response response = await dio.post(
        endpoint,
        data: formData,
        options: Options(
          headers: {'cookie': _cookies},
        ),
      );

      if (response.statusCode >= 200) {
        print('POST --> Successfully [OK 201]');

        final Poi newPoi = Poi.fromJson(response.data);
        _userReported.add(newPoi);
        _persons.add(newPoi);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> deletePoi(int poiID) async {
    var dio = Dio();
    String endPoint = "$missingEndpoint/$poiID";
    try {
      Response response = await dio.delete(endPoint);
      print('DELETE --> ${response.statusCode}');

      if (response.statusCode >= 200) {
        _userReported.removeWhere((poi) => poi.id == poiID);
        notifyListeners();
        _persons.removeWhere((poi) => poi.id == poiID);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> updatePoi(Map<String, dynamic> poiData, File image) async {
    String imgPath;
    String imgName;
    bool imageLoaded = false;
    if (image != null) {
      imageLoaded = true;
      imgPath = image.path;
      imgName = imgPath.split("/").last;
    }
    var body = {
      "name": poiData['name'],
      'image': imageLoaded
          ? await MultipartFile.fromFile(imgPath, filename: imgName)
          : null,
    };
    body.removeWhere((key, value) => value == null);
    try {
      var formData = FormData.fromMap(body);

      Dio dio = Dio();

      String endpoint = "$missingEndpoint/${poiData['id']}";

      Response response = await dio.patch(endpoint, data: formData);

      print('UPDATE Code--> ${response.statusCode}');

      if (response.statusCode == 202) {
        Poi updatedPoi = Poi.fromJson(response.data);
        int oldPoiIdx =
            _userReported.indexWhere((poi) => poi.id == poiData['id']);
        _userReported[oldPoiIdx] = updatedPoi;

        int oldPoiIdxAllPos =
            _persons.indexWhere((poi) => poi.id == poiData['id']);
        _persons[oldPoiIdxAllPos] = updatedPoi;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }
}

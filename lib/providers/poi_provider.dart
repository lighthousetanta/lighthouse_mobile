import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import '../models/poi.dart';

class PoiProvider with ChangeNotifier {
  static const missingEndpoint =
      "https://lighthousetanta.herokuapp.com/api/missing";
  List<Poi> _persons = [];

  List<Poi> get getPersons {
    return [..._persons];
  }

  Poi getById(int id) {
    return _persons.firstWhere((element) => element.id == id, orElse: null);
  }

  Future<void> fetchPersons() async {
    print('FETCHING');

    var dio = Dio();
    String endPoint = missingEndpoint;
    List<Poi> loadedData = [];

    try {
      Response response = await dio.get(endPoint);

      if (response.statusCode == 200) {
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

  void addPoi(Poi poi) {
    _persons.add(poi);
    notifyListeners();
  }

  Future<void> submitNewPoi(
      String imagePath, Map<String, dynamic> userInput) async {
    String imgName = imagePath.split("/").last;

    try {
      var formData = FormData.fromMap({
        "name": userInput['name'],
        'image': await MultipartFile.fromFile(imagePath, filename: imgName),
      });

      var dio = Dio();
      String endpoint = missingEndpoint;
      Response response = await dio.post(endpoint, data: formData);

      if (response.statusCode == 201) {
        print('POST --> Successfully [OK 201]');

        final Poi newPoi = Poi.fromJson(response.data);
        addPoi(newPoi);
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

      if (response.statusCode == 204) {
        _persons.removeWhere((poi) => poi.id == poiID);

        notifyListeners();
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
        int oldPoiIdx = _persons.indexWhere((poi) => poi.id == poiData['id']);
        _persons[oldPoiIdx] = updatedPoi;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }
}

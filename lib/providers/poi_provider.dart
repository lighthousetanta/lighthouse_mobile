import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import '../models/poi.dart';

class PoiProvider with ChangeNotifier {
  Dio dio = Dio();
  List<Poi> _persons = [];
  List<Poi> _reported = [];
  List _cookies = [];
  List<Poi> _searchResult = [];
  Map<int, int> _similarityRatiosMap = {};
  int _searchProcessID;

  static const api = '';
  String missingEndpoint = '$api/api/missing';
  String profileEndpoint = '$api/api/profile';
  String findEndpoint = '$api/api/find';
  String resultEndpoint = '$api/api/result';
  // "https://stormy-lake-08470.herokuapp.com/api/";

  void update(List cookie, List<Poi> persons, List<Poi> reported) {
    _persons = persons;
    _cookies = cookie;
    _reported = reported;
  }

  List<Poi> get allPersons {
    return [..._persons];
  }

  List<Poi> get reported {
    return [..._reported];
  }

  Poi getById(int id) {
    int idx = _persons.indexWhere((element) => element.id == id);

    return _persons[idx];
  }

  List<Poi> get searchResults {
    return [..._searchResult];
  }

  Map<int, int> get similarityMap {
    return _similarityRatiosMap;
  }

  Future<void> fetchPersons() async {
    print('FETCHING ALL MISSING POIs');

    try {
      Response response = await dio.get(missingEndpoint);

      if (response.statusCode >= 200) {
        print('GET --> Successfully [OK ${response.statusCode}]');
        List<Poi> fetchedPersons = [];

        for (var newPerson in response.data) {
          fetchedPersons.add(Poi.fromJson(newPerson));
        }

        _persons = fetchedPersons;

        notifyListeners();
      } else {
        print('GET --> ${response.statusCode}');
      }
    } catch (error) {
      print('GET Error --> $error');
      throw error;
    }
  }

  Future<void> fetchReported() async {
    print('FETCHING per user');

    String endPoint = profileEndpoint;
    List<Poi> fetchedPersons = [];
    print(_cookies);

    try {
      Response response = await dio.get(endPoint,
          options: Options(headers: {'cookie': _cookies}));

      if (response.statusCode >= 200) {
        print('GET --> Successfully [OK ${response.statusCode}]');

        for (var newPerson in response.data) {
          fetchedPersons.add(Poi.fromJson(newPerson));
        }

        _reported = fetchedPersons;

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
    try {
      String endpoint = missingEndpoint;
      var formData = FormData.fromMap({
        "name": userInput['name'],
        'image': await MultipartFile.fromFile(imagePath, filename: imgName),
      });

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
        _reported.add(newPoi);
        _persons.add(newPoi);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> deletePoi(int poiID) async {
    try {
      String endPoint = "$missingEndpoint/$poiID";
      Response response = await dio.delete(endPoint);
      print('DELETE --> ${response.statusCode}');

      if (response.statusCode >= 200) {
        _reported.removeWhere((poi) => poi.id == poiID);
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

      String endpoint = "$missingEndpoint/${poiData['id']}";

      Response response = await dio.patch(endpoint, data: formData);

      print('UPDATE Code--> ${response.statusCode}');
      print(response.data);
      if (response.statusCode == 202) {
        Poi updatedPoi = Poi.fromJson(response.data);
        if (reported.isNotEmpty) {
          int oldPoiIdx =
              _reported.indexWhere((poi) => poi.id == poiData['id']);
          _reported[oldPoiIdx] = updatedPoi;
        }

        int oldPoiIdxAllPos =
            _persons.indexWhere((poi) => poi.id == poiData['id']);
        _persons[oldPoiIdxAllPos] = updatedPoi;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> searchByImg(String imagePath) async {
    String imgName = imagePath.split("/").last;

    try {
      var formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath, filename: imgName),
      });

      print('iniate first');
      Response response = await dio.post(findEndpoint, data: formData);
      if (response.statusCode >= 200) {
        var processID = response.data['id'];
        _searchProcessID = processID;
        var delayTime = int.parse(response.data['time']);
        print(delayTime); ////////// NOT USED yet
        await Future.delayed(Duration(seconds: 10));
        print('Initiate Search Process');
        print(response.data);
        print('Model has finished searching');
        await getSearchResults();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> getSearchResults() async {
    Response resposne = await dio
        .get(resultEndpoint, queryParameters: {'id': _searchProcessID});
    print('Getting Results ...');
    if (resposne.statusCode >= 200) {
      print('Result GET --> ${resposne.statusCode}');
      Map<int, int> personsScore = {};
      List<Poi> similarPersons = [];
      for (var result in resposne.data) {
        Poi poi = Poi.fromJson(result['person']);
        similarPersons.add(poi);
        personsScore.putIfAbsent(
            poi.id, () => (((result['score'] - 1) * 100).round()));
      }
      _searchResult = similarPersons;
      _similarityRatiosMap = personsScore;
    }
    notifyListeners();
  }
}

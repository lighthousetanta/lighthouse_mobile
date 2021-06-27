import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  List cookies;
  String _token;
  DateTime _expiryDate;
  String _userID;
  Timer _authTimer;
  bool get isAuthed {
    return getToken != null;
  }

  String get getToken {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  List get getCookies {
    return cookies;
  }

  Future<void> _authenticate(String email, String password, String action,
      {String name = ''}) async {
    Dio dio = Dio();

    final endpoint = 'https://stormy-lake-08470.herokuapp.com/api/$action';

    try {
      final preBody = {'name': name, 'email': email, 'password': password};

      preBody['name'] = 'Yahia';
      if (action == 'login') {
        preBody.remove('name');
      }
      var body = json.encode(preBody);

      final Response response = await dio.post(endpoint, data: body);
      print(response.statusCode);
      print(response.headers);
      cookies = response.headers['set-cookie'];
      print(">>>> $cookies");
      _token = cookies[0].toString().split(';').first.substring(4);
      print("TOKEN ------> $_token");
      _expiryDate = DateTime.now().add(Duration(hours: 1));

      _autoLogout();
      notifyListeners();
      final prefrences = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userID': _userID,
        'expiryDate': _expiryDate.toIso8601String()
      });
      prefrences.setString('userData', userData);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> signup(String name, String email, String password) async {
    return _authenticate(email, password, 'register', name: name);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'login');
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userID = null;
    // canceling the timer for the drawer logout also
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    preferences.remove('userData');
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> tryAutoLogin() async {
    final prefrences = await SharedPreferences.getInstance();
    if (!prefrences.containsKey('userData')) {
      return false;
    }
    final extractedData =
        json.decode(prefrences.getString('userData')) as Map<String, Object>;
    if (extractedData['token'] == null) {
      return false;
    }
    final savedExpiryDate = DateTime.parse(extractedData['expiryDate']);
    if (savedExpiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'];
    _userID = extractedData['userID'];
    _expiryDate = savedExpiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }
}

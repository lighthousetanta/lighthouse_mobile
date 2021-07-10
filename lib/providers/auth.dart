import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_lighthouse/models/user.dart';

class Auth with ChangeNotifier {
  Dio dio = Dio();
  List _cookie;
  DateTime _expiryDate;
  User _user;
  Timer _authTimer;
  static const api = '';

  String _registerEndpoint = '$api/api/register';
  String _loginEndpoint = '$api/api/login';
  String _logoutEndpoint = '$api/api/logout';

  bool get isAuthed {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _cookie != null) {
      return true;
    } else {
      return false;
    }
  }

  List get getCookie {
    return _cookie;
  }

  int get userID {
    return _user.id;
  }

  User get getuser {
    return _user;
  }

  Future<void> register(String userName, String email, String password) async {
    print('Register ...');
    try {
      final body = json
          .encode({'username': userName, 'email': email, 'password': password});

      final Response response = await dio.post(_registerEndpoint, data: body);
      if (response.statusCode >= 200) {
        _user = User.fromJson(response.data);
        _cookie = response.headers['set-cookie'];
        print(response.headers);
        print(_cookie);

        _expiryDate = DateTime.now().add(Duration(hours: 1));

        _autoLogout();
        notifyListeners();
        final prefrences = await SharedPreferences.getInstance();
        final userData = json.encode({
          'cookie': _cookie,
          'user': _user.toJson(),
          'expiryDate': _expiryDate.toIso8601String()
        });
        prefrences.setString('userData', userData);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    print("Login ...");
    try {
      final body = json.encode({'email': email, 'password': password});
      print(body);
      final Response response = await dio.post(_loginEndpoint, data: body);
      print(response.data);
      if (response.statusCode >= 200) {
        _user = User.fromJson(response.data);
        _cookie = response.headers['set-cookie'];
        print(response.headers);
        print(_cookie);

        _expiryDate = DateTime.now().add(Duration(hours: 1));

        _autoLogout();
        notifyListeners();
        final prefrences = await SharedPreferences.getInstance();
        final userData = json.encode({
          'cookie': _cookie,
          'user': _user.toJson(),
          'expiryDate': _expiryDate.toIso8601String()
        });
        prefrences.setString('userData', userData);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> logout() async {
    print('Logout');
    await dio.post(_logoutEndpoint,
        options: Options(headers: {'cookie': _cookie}));
    _cookie = null;
    _expiryDate = null;
    _user = null;
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
    print("try login");
    final prefrences = await SharedPreferences.getInstance();
    if (!prefrences.containsKey('userData')) {
      return false;
    }
    final extractedData =
        json.decode(prefrences.getString('userData')) as Map<String, Object>;
    if (extractedData['cookie'] == null) {
      return false;
    }
    final savedExpiryDate = DateTime.parse(extractedData['expiryDate']);
    if (savedExpiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _cookie = extractedData['cookie'];
    _user = User.fromJson(extractedData['user']);
    _expiryDate = savedExpiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }
}

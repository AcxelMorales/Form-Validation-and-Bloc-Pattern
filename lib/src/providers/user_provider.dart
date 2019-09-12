import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:Fluttergram/src/settings/user_preferences.dart';

class UserProvider {
  final String _firebaseToken = 'AIzaSyCA4b6aNWwhpdmIEQstVZS-I28VYMXr73Y';
  final _prefs = UserPreferences();

  Future<Map<String, dynamic>> signUp(String email, String password) async {
    final authData = {
      'email'            : email,
      'password'         : password,
      'returnSecureToken': true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedData = json.decode(resp.body);

    if (decodedData.containsKey('idToken')) {
      this._prefs.token = decodedData['idToken'];

      return {
        'ok'   : true,
        'token': decodedData['idToken']
      };
    } else {
      return {
        'ok'     : false,
        'message': decodedData['error']['message'] 
      };
    }
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final authData = {
      'email'            : email,
      'password'         : password,
      'returnSecureToken': true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedData = json.decode(resp.body);

    if (decodedData.containsKey('idToken')) {
      this._prefs.token = decodedData['idToken'];

      return {
        'ok'   : true,
        'token': decodedData['idToken']
      };
    } else {
      return {
        'ok'     : false,
        'message': decodedData['error']['message'] 
      };
    }
  }
}
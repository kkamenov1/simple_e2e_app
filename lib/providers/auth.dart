import 'dart:convert';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  Future<void> signup(String username, String password) async {
    try {
      final url = Uri.parse('http://10.0.2.2:8888/register');
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({'username': username, 'password': password}));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      } else {
        // login user after signing up
        await this.login(username, password);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String username, String password) async {
    try {
      final url = Uri.parse('http://10.0.2.2:8888/auth/token');
      const clientID = 'com.test_project.server';
      final body = "username=$username&password=$password&grant_type=password";
      final String clientCredentials =
          const Base64Encoder().convert("$clientID:".codeUnits);
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Basic $clientCredentials"
          },
          body: body);
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }

      _token = responseData['access_token'];
      _expiryDate =
          DateTime.now().add(Duration(seconds: responseData['expires_in']));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

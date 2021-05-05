import 'dart:convert';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class Drawing with ChangeNotifier {
  List<dynamic> _drawings = [];

  List<dynamic> get drawings {
    return _drawings;
  }

  Future<void> saveImage(String points, int userId) async {
    final url = Uri.parse('http://10.0.2.2:8888/drawings/$userId');
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'points': points}));

    final responseData = json.decode(response.body);
    _drawings.add(responseData);
    notifyListeners();
  }

  Future<void> getAllImages() async {
    final url = Uri.parse('http://10.0.2.2:8888/drawings');
    final response = await http.get(url);
    final responseData = json.decode(response.body);

    for (var i = 0; i < responseData.length; i++) {
      _drawings.add(responseData[i]);
    }
    notifyListeners();
  }

  Future<void> deleteImage(int index) async {
    final url =
        Uri.parse('http://10.0.2.2:8888/drawings/${_drawings[index]['id']}');
    await http.delete(url);

    _drawings.removeAt(index);
    notifyListeners();
  }
}

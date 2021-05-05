import 'dart:convert';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Drawing with ChangeNotifier {
  Future<void> saveImage(String points) async {
    final url = Uri.parse('http://10.0.2.2:8888/drawings');
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'points': points}));

    print(response.body); // REMOVE THIS
  }

  Future<List<dynamic>> getAllImages() async {
    final url = Uri.parse('http://10.0.2.2:8888/drawings');
    final response = await http.get(url);
    final responseData = json.decode(response.body);
    return responseData;
  }

  Future<dynamic> deleteImage(int id) async {
    final url = Uri.parse('http://10.0.2.2:8888/drawings/$id');
    return await http.delete(url);
  }
}

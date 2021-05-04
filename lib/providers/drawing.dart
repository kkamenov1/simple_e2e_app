import 'dart:typed_data';
import 'dart:ui';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Drawing with ChangeNotifier {
  String _img;

  Future<void> saveImage(String img) async {
    final url = Uri.parse('http://10.0.2.2:8888/image');
    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'img': img}));

    print(response.body); // REMOVE THIS
  }
}

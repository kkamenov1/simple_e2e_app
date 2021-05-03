import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/draw.dart';
import 'screens/history.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Open Sans',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/draw': (context) => Draw(),
        '/history': (context) => History(),
      }
    );
  }
}

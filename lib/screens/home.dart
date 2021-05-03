import 'package:flutter/material.dart';
class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _HomeState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DrawApp"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text('Draw'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/draw');
                  },
                ),
                ElevatedButton(
                  child: Text('History'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/history');
                  },
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}

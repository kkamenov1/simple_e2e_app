import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_e2e_app/providers/drawing.dart';
import 'package:simple_e2e_app/screens/draw.dart';

class History extends StatefulWidget {
  History({Key key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  _HistoryState();

  void _showNotificationDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Drawing deletion'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay'))
              ],
            ));
  }

  void _showDrawingDialog(dynamic drawing) {
    // extract and convert points;
    RegExp exp = RegExp(r"(\d+\.\d+;\d+\.\d+)|(null)");
    final drawingPoints = drawing['points'];
    List<Offset> points = [];
    Iterable<RegExpMatch> matches = exp.allMatches(drawingPoints);
    matches.forEach((match) {
      final strMatch = drawingPoints.substring(
          match.start, match.end); // 12.123;24.231 OR null
      if (strMatch == 'null') {
        points.add(null);
      } else {
        final offsetCoords =
            drawingPoints.substring(match.start, match.end).split(';');
        Offset point = Offset(
            double.parse(offsetCoords[0]), double.parse(offsetCoords[1]));
        points.add(point);
      }
    });

    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Drawing ${drawing['id']}'),
              content: Center(
                child: Container(
                  child: CustomPaint(
                    painter: MyCustomPainter(points: points),
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay'))
              ],
            ));
  }

  Future<void> deleteDrawing(int id) async {
    final response =
        await Provider.of<Drawing>(context, listen: false).deleteImage(id);

    if (response.statusCode == 200) {
      _showNotificationDialog('Successfully deleted drawing!');
      await Provider.of<Drawing>(context, listen: false).getAllImages();
    } else {
      _showNotificationDialog('An Error Occured!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text("DrawApp"),
          ),
          body: Stack(
            children: [
              Container(decoration: BoxDecoration(color: Colors.orange)),
              Center(
                child: (() {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    if (snapshot.hasError)
                      return Text('An Error Occured!');
                    else
                      return snapshot.data.length == 0
                          ? Text('No drawings')
                          : Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                for (var i = 0; i < snapshot.data.length; i++)
                                  Container(
                                    width: width * 0.9,
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all()),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text('Drawing #${i + 1}')),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0.0, 0.0, 10.0, 0.0),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                _showDrawingDialog(
                                                    snapshot.data[i]);
                                              },
                                              child: Text('View')),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              deleteDrawing(
                                                  snapshot.data[i]['id']);
                                            },
                                            child: Text('Delete')),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            );
                  }
                }()),
              )
            ],
          ),
        );
      },
      future: Provider.of<Drawing>(context, listen: false).getAllImages(),
    );
  }
}

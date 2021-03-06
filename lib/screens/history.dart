import 'dart:core';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_e2e_app/providers/drawing.dart';
import 'package:simple_e2e_app/screens/draw.dart';
import 'package:flutter/foundation.dart';

class History extends StatefulWidget {
  History({Key key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  _HistoryState();

  List<Offset> parsePoints(String drawingPoints) {
    RegExp exp = RegExp(r"(\d+\.\d+;\d+\.\d+)|(null)");
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

    return points;
  }

  void _showDrawingDialog(dynamic drawing, int index) {
    final points = parsePoints(drawing['points']);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Drawing #$index'),
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
      ),
    );
  }

  @override
  void initState() {
    final drawing = Provider.of<Drawing>(context, listen: false);

    if (drawing.drawings.isEmpty) {
      Provider.of<Drawing>(context, listen: false).getAllImages();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final drawing = Provider.of<Drawing>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Drawings'),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: drawing.drawings.length,
              itemBuilder: (ctx, i) => Card(
                margin: EdgeInsets.all(15),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Drawing #${i + 1}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          // _showDrawingDialog(drawing.drawings[i], i + 1);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Draw(
                                    points: parsePoints(
                                  drawing.drawings[i]['points'],
                                )),
                              ));
                        },
                        child: Text('View'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<Drawing>(context, listen: false)
                              .deleteImage(i);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Successfully deleted drawing!'),
                            ),
                          );
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

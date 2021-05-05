import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/drawing.dart';

class Draw extends StatefulWidget {
  Draw({Key key}) : super(key: key);

  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  _DrawState();

  List<Offset> points = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> saveDrawing() async {
    var result = '';
    for (var i = 0; i < points.length; i++) {
      if (points[i] != null) {
        result += '[${points[i].dx};${points[i].dy}]';
      } else {
        result += '[null]';
      }
    }

    await Provider.of<Drawing>(context, listen: false).saveImage(result);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text("DrawApp"),
        ),
        body: Stack(
          children: [
            Container(decoration: BoxDecoration(color: Colors.orange)),
            Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Container(
                    width: width * 0.9,
                    height: height * 0.6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 5.0,
                              spreadRadius: 1.0)
                        ]),
                    child: GestureDetector(
                        onPanDown: (details) {
                          this.setState(() {
                            points.add(details.localPosition);
                          });
                        },
                        onPanUpdate: (details) {
                          this.setState(() {
                            points.add(details.localPosition);
                          });
                        },
                        onPanEnd: (details) {
                          this.setState(() {
                            points.add(null);
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          child: CustomPaint(
                            painter: MyCustomPainter(points: points),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: saveDrawing,
                    child: Text('Save'),
                  )
                ]))
          ],
        ));
  }
}

class MyCustomPainter extends CustomPainter {
  List<Offset> points;

  MyCustomPainter({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);

    Paint paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 2.0;
    paint.isAntiAlias = true;
    paint.strokeCap = StrokeCap.round;

    for (int x = 0; x < points.length - 1; x++) {
      if (points[x] != null && points[x + 1] != null) {
        // user draws
        canvas.drawLine(points[x], points[x + 1], paint);
      } else if (points[x] != null && points[x + 1] == null) {
        // user just taps on the screen
        canvas.drawPoints(PointMode.points, [points[x]], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

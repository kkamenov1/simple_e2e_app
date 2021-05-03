import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class DrawingArea {
  Offset point;
  Paint areaPaint;

  DrawingArea({ this.point, this.areaPaint });
}

class Draw extends StatefulWidget {
  Draw({Key key}) : super(key: key);

  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  _DrawState();

  List<DrawingArea> points = [];
  Color selectedColor;
  double strokeWidth;

  @override
  void initState() {
    super.initState();
    selectedColor = Colors.black;
    strokeWidth = 2.0;
  }

  void selectColor() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Color Chooser'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) {
              this.setState(() {
                selectedColor = color;
              });
            },
          )
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Close"),
          )
        ],
      ),
    );
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
          Container(
            decoration: BoxDecoration(
              color: Colors.orange
            )
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.9,
                  height: height * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 5.0,
                        spreadRadius: 1.0
                      )
                    ]
                  ),
                  child: GestureDetector(
                    onPanDown: (details){
                      this.setState(() {
                        points.add(DrawingArea(
                          point: details.localPosition,
                          areaPaint: Paint()
                            ..strokeCap = StrokeCap.round
                            ..isAntiAlias = true
                            ..color = selectedColor
                            ..strokeWidth = strokeWidth
                        ));
                      });
                    },
                    onPanUpdate: (details){
                      this.setState(() {
                        points.add(DrawingArea(
                          point: details.localPosition,
                          areaPaint: Paint()
                            ..strokeCap = StrokeCap.round
                            ..isAntiAlias = true
                            ..color = selectedColor
                            ..strokeWidth = strokeWidth
                        ));
                      });
                    },
                    onPanEnd: (details){
                      this.setState(() {
                        points.add(null);
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      child: CustomPaint(
                        painter: MyCustomPainter(points: points),
                      ),
                    )
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.color_lens, color: selectedColor,),
                        onPressed: () {
                          selectColor();
                        }
                      ),
                      Expanded(
                        child: Slider(
                          value: strokeWidth,
                          onChanged: (value) {
                            this.setState(() {
                              strokeWidth = value;
                            });
                          },
                          min: 1.0,
                          max: 7.0,
                          activeColor: selectedColor,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.layers_clear),
                        onPressed: () {
                          this.setState(() {
                            points.clear();
                          });
                        }
                      )
                    ],
                  )
                )
              ]
            )
          )
        ],
      )
    );
  }
}

class MyCustomPainter extends CustomPainter {
  List<DrawingArea> points;

  MyCustomPainter({ this.points });

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);

    for (int x = 0; x < points.length - 1; x++) {
      if (points[x] != null && points[x + 1] != null) { // user draws
        Paint paint = points[x].areaPaint;
        canvas.drawLine(points[x].point, points[x + 1].point, paint);
      } else if (points[x] != null && points[x + 1] == null) { // user just taps on the screen
        Paint paint = points[x].areaPaint;
        canvas.drawPoints(PointMode.points, [points[x].point], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

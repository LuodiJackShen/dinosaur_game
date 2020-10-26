import 'package:dinosaur_game/bean/tree.dart';
import 'package:dinosaur_game/util/rubble_factory.dart';
import 'package:flutter/material.dart';

class Ground extends CustomPainter {
  Color color;
  double height;
  Tree tree;

  Ground({this.color = Colors.white, this.tree});

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    height = size.height;

    var linePaint = Paint()
      ..color = color ?? Colors.white
      ..strokeWidth = 2.0;

    //地平线
    canvas.drawLine(
      Offset(0, 0),
      Offset(width, 0),
      linePaint,
    );

    if (tree.isDouble) {
      if (tree.isAfter) {
        drawTree(canvas, startX: tree.start, isSmall: tree.isSmall);
        drawTree(canvas, startX: tree.start + 25.0);
      } else {
        drawTree(canvas, startX: tree.start - 25.0);
        drawTree(canvas, startX: tree.start, isSmall: tree.isSmall);
      }
    } else {
      drawTree(canvas, startX: tree.start, isSmall: tree.isSmall);
    }

    //碎石子
    RubbleFactory.instance.createRubbles(width, height).forEach((rubble) {
      canvas.drawLine(rubble.start, rubble.end, linePaint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  void drawTree(
    Canvas canvas, {
    double startX = 50.0,
    bool isSmall = true,
  }) {
    var treePaint = Paint()
      ..color = color ?? Colors.white
      ..strokeWidth = 4.0;

    //中间树干
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        startX,
        isSmall ? -22.5 : -45,
        isSmall ? startX + 5.0 : startX + 6.0,
        height,
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
      treePaint,
    );
    //左边的竖杈
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        isSmall ? startX - 8.0 : startX - 10.0,
        isSmall ? -20 : -33,
        isSmall ? startX - 4 : startX - 5.0,
        isSmall ? -6 : -10,
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
        bottomLeft: Radius.circular(20.0),
      ),
      treePaint,
    );
    //左侧横杈
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        isSmall ? startX - 8.0 : startX - 10.0,
        isSmall ? -10 : -15,
        startX,
        isSmall ? -5 : -10,
        bottomLeft: Radius.circular(20.0),
      ),
      treePaint,
    );
    //右侧竖杈
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        isSmall ? startX + 8.5 : startX + 11.0,
        isSmall ? -21 : -37,
        isSmall ? startX + 13 : startX + 17,
        isSmall ? -11 : -16,
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
        bottomRight: Radius.circular(8.0),
      ),
      treePaint,
    );
    //右侧横杈
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        startX,
        isSmall ? -13 : -19,
        isSmall ? startX + 12 : startX + 17,
        isSmall ? -9 : -13,
        bottomRight: Radius.circular(20.0),
      ),
      treePaint,
    );
  }
}

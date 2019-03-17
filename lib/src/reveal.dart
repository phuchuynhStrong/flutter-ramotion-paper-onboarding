import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RevealProgressButtonPainter extends CustomPainter {
  double _fraction = 0.0;
  Size _screenSize;
  Color _color;

  RevealProgressButtonPainter(this._fraction, this._screenSize, this._color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = this._color ?? Colors.green
      ..style = PaintingStyle.fill;

    var finalRadius =
    sqrt(pow(_screenSize.width, 2) + pow(_screenSize.height, 2));
    var radius = 16 + finalRadius * _fraction;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(RevealProgressButtonPainter oldDelegate) {
    return oldDelegate._fraction != _fraction;
  }
}
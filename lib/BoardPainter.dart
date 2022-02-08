import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoardPainter extends CustomPainter
{
  @override
  void paint(Canvas canvas, Size size)
  {
        Paint paint = new Paint();
        paint.color = Color(0xFF707070); // dark gray
        paint.strokeCap = StrokeCap.square;
        paint.style = PaintingStyle.fill;
        paint.strokeWidth = size.width/30;

        var width = size.width/3;
        var padding = size.width/20;
        for (var i = 1; i < 3; i++)
        {
           canvas.drawLine(Offset(width* i, padding), Offset(width* i, size.width - padding), paint);
           canvas.drawLine(Offset(padding, width * i), Offset(size.width - padding, width * i), paint);
        }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate)
  {
    return false;
  }
}
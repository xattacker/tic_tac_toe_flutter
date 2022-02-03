import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'logic/ChessGrid.dart';


class ChessPainter extends CustomPainter
{
  ChessType type;

  ChessPainter(this.type);

  @override
  void paint(Canvas canvas, Size size)
  {
        Paint paint = new Paint();
        paint.strokeCap = StrokeCap.round;
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = size.width / 10;

        switch (this.type)
        {
            case ChessType.circle:
              {
                  paint.color = Colors.lightBlue;

                  var padding = size.width/10;
                  canvas.drawCircle(Offset(size.width/2, size.height/2), (size.width/2) - (padding*2), paint);
              }
              break;

            case ChessType.fork:
              {
                  paint.color = Colors.redAccent;

                  var padding = size.width/5;
                  canvas.drawLine(Offset(padding, padding), Offset(size.width - padding, size.height - padding), paint);
                  canvas.drawLine(Offset(size.width - padding, padding), Offset(padding, size.height - padding), paint);
              }
              break;

            default:
              break;
        }
  }

  @override
  bool shouldRepaint(ChessPainter oldDelegate)
  {
      return oldDelegate.type != this.type;
  }
}
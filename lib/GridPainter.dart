import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'logic/TicTacToeGrid.dart';


class ChessPainter extends CustomPainter
{
  GridChessType _status;

  ChessPainter(this._status);

  @override
  void paint(Canvas canvas, Size size)
  {
        Paint paint = new Paint();
        paint.strokeCap = StrokeCap.round;
        paint.style = PaintingStyle.stroke;

        var chess_width = min(size.width, size.height);
        paint.strokeWidth = chess_width / 10;

        var x_offset = (size.width - chess_width)/2;
        var y_offset = (size.height - chess_width)/2;

        switch (this._status)
        {
            case GridChessType.circle:
              {
                  paint.color = Colors.redAccent;

                  var padding = chess_width/10;
                  canvas.drawCircle(
                      Offset(chess_width/2 + x_offset, chess_width/2 + y_offset),
                      (chess_width/2) - (padding*2),
                      paint);
              }
              break;

            case GridChessType.fork:
              {
                 paint.color = Colors.lightBlue;

                  var padding = chess_width/5;
                  canvas.drawLine(
                      Offset(padding + x_offset, padding + y_offset),
                      Offset(chess_width - padding + x_offset, chess_width - padding + y_offset),
                      paint);

                  canvas.drawLine(
                      Offset(chess_width - padding + x_offset, padding + y_offset),
                      Offset(padding + x_offset, chess_width - padding + y_offset),
                      paint);
              }
              break;

            default:
              break;
        }
  }

  @override
  bool shouldRepaint(ChessPainter oldDelegate)
  {
      return oldDelegate._status != this._status;
  }
}
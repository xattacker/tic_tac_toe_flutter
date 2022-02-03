import 'package:flutter/cupertino.dart';

import 'ChessPainter.dart';
import 'logic/ChessGrid.dart';

class ChessWidget extends StatefulWidget
{
  ChessState createState() => ChessState();
}

class ChessState extends State<ChessWidget>
{
  ChessType type = ChessType.none;

  @override
    Widget build(BuildContext context) {
          return GestureDetector(
              onTap: () {
                  if (this.type == ChessType.none)
                  {
                      setState(() {
                        this.type = ChessType.circle;
                      });
                  }
              },
              child:  CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
                  painter: ChessPainter(this.type)
              )
          );
    }
}
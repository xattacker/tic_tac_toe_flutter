import 'package:flutter/cupertino.dart';

import 'GridPainter.dart';
import 'logic/TicTacToeGrid.dart';

class GridWidget extends StatefulWidget
{
  GridState createState() => GridState();
}

class GridState extends State<GridWidget>
{
  GridStatus status = GridStatus.none;

  @override
    Widget build(BuildContext context) {
          return GestureDetector(
              onTap: () {
                  if (this.status == GridStatus.none)
                  {
                      setState(() {
                        this.status = GridStatus.circle;
                      });
                  }
              },
              child:  CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
                  painter: ChessPainter(this.status)
              )
          );
    }
}
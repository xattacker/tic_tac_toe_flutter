import 'package:flutter/cupertino.dart';

import 'GridPainter.dart';
import 'logic/TicTacToeGrid.dart';

class GridWidget extends StatefulWidget implements TicTacToeGrid
{
  @override
  GridStatus status = GridStatus.none;

  @override
  int x;

  @override
  int y;

  GridWidget(this.x, this.y);

  GridState createState() => GridState();
}

class GridState extends State<GridWidget>
{
  @override
    Widget build(BuildContext context) {
          return GestureDetector(
              onTap: () {
                  if (this.widget.status == GridStatus.none)
                  {
                      setState(() {
                        this.widget.status = GridStatus.circle;
                      });
                  }
              },
              child:  CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
                  painter: ChessPainter(this.widget.status)
              )
          );
    }
}
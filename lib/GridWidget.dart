import 'package:flutter/cupertino.dart';

import 'GridPainter.dart';
import 'logic/TicTacToeGrid.dart';

class GridWidget extends StatefulWidget implements TicTacToeGrid
{
  GridStatus _status = GridStatus.none;

  @override
  int x;

  @override
  int y;

  @override
  GridStatus get status => _status;

  @override
  set status(GridStatus status)
  {
      _status = status;
      this.listener.onGridStatusUpdated(_status, this);
  }

  GridWidget(this.x, this.y);

  GridState createState() => GridState();

  @override
  late TicTacToeGridListener listener;
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
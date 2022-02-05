import 'package:flutter/cupertino.dart';

import 'GridPainter.dart';
import 'logic/TicTacToeGrid.dart';

class GridWidget extends StatefulWidget implements TicTacToeGrid
{
  GridChessStatus _status = GridChessStatus.none;

  @override
  int x;

  @override
  int y;

  @override
  GridChessStatus get status => _status;

  @override
  set status(GridChessStatus status)
  {
      _status = status;
      this.listener.onGridStatusUpdated(_status, this);
  }

  GridWidget(this.x, this.y);

  GridState createState() => GridState();

  @override
  late TicTacToeGridListener listener;

  void chess()
  {
      this.listener.chess(this);
  }
}

class GridState extends State<GridWidget>
{
  @override
    Widget build(BuildContext context) {
          return GestureDetector(
              onTap: () {
                  if (this.widget.status == GridChessStatus.none)
                  {
                      setState(() {
                          this.widget.chess();
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